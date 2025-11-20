#!/bin/bash
set -x

# --- Helper functions ---
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
        cd - >/dev/null
        return
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

# --- Build all packages in strict order (each must install before next) ---
ALL_PACKAGES=(
  "fixposition-sdk/fpsdk_common"
  "fixposition-sdk/fpsdk_ros1"
  "fixposition_driver_lib"
  "fixposition_driver_msgs"
  "fixposition_driver_ros1"
  "rtcm_msgs"
)

greenzie-release changelog -r "noetic" --with-submodules || true

for PKG in "${ALL_PACKAGES[@]}"; do
    build_pkg "$PKG"

    # Install *all* .deb files produced by this package before building the next
    if ls "$PKG"/*.deb 1>/dev/null 2>&1; then
        echo "Installing generated packages from $PKG"
        apt -y install "$PKG"/../*.deb || true
    fi
done

# (Removed duplicate driver loop — everything now handled in ALL_PACKAGES)

echo "All package builds complete."
