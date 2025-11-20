#!/bin/bash
set -x

# --- DEFINITION: dictionary mapping directories → deb prefixes ---
declare -A DEB_MAP=(
    ["fixposition-sdk/fpsdk_common"]="ros-noetic-fpsdk-common"
    ["fixposition-sdk/fpsdk_ros1"]="ros-noetic-fpsdk-ros1"
    ["fixposition_driver_lib"]="ros-noetic-fixposition-driver-lib"
    ["fixposition_driver_msgs"]="ros-noetic-fixposition-driver-msgs"
    ["fixposition_driver_ros1"]="ros-noetic-fixposition-driver-ros1"
    ["rtcm_msgs"]="ros-noetic-rtcm-msgs"
)

# Build order is the dictionary's key order (already correct)
# Build order comes directly from dictionary keys
ALL_PACKAGES=(
    "${!DEB_MAP[@]}"
)

# --- Helper function ---
build_pkg() {
    local DIR="$1"

    echo "=== Building $DIR ==="

    if [[ ! -d "$DIR" ]]; then
        echo "[WARN] Directory $DIR does not exist, skipping"
        return
    fi

    cd "$DIR"

    greenzie-release changelog -r "noetic" --with-submodules
    apt -y build-dep .

    debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt || {
        echo "[ERROR] Build failed for $DIR"
        exit 1
    }

    cd - >/dev/null
    echo "=== Finished $DIR ==="
    echo
}

# --- Global setup ---
ls -lah
apt update

git submodule sync
git submodule update --init --recursive

greenzie-release changelog -r "noetic" --with-submodules || true

# --- Main loop ---
for PKG in "${ALL_PACKAGES[@]}"; do
    build_pkg "$PKG"

    DEB_PREFIX="${DEB_MAP[$PKG]}"
    DEB_DIR="$(dirname "$PKG")"

    # debuild places .deb files in parent directory of pkg
    if ls "$DEB_DIR"/${DEB_PREFIX}*.deb 1>/dev/null 2>&1; then
        echo "Installing ${DEB_PREFIX}*.deb from $DEB_DIR"
        apt -y install "$DEB_DIR"/${DEB_PREFIX}*.deb
    else
        echo "[WARN] Expected deb ${DEB_PREFIX} not found in $DEB_DIR"
        exit 1
    fi
done

echo "All package builds complete."
