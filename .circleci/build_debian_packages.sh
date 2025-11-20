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

# Build order comes directly from dictionary keys
# Explicit build order (associative arrays are NOT ordered)
ALL_PACKAGES=(
    "fixposition-sdk/fpsdk_common"
    "fixposition-sdk/fpsdk_ros1"
    "fixposition_driver_lib"
    "fixposition_driver_msgs"
    "fixposition_driver_ros1"
    "rtcm_msgs"
)

# --- Helper function ---
build_pkg() {
    local dir="$1"

    echo "=== Building $dir ==="

    if [[ ! -d "$dir" ]]; then
        echo "[ERROR] Directory $dir does not exist, skipping"
        exit 1
    fi

    cd "$dir" || {
        echo "[ERROR] Failed to cd into $dir" >&2
        exit 1
    }

    greenzie-release changelog -r "noetic" --with-submodules
    apt -y build-dep .

    if ! debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt; then
        echo "[ERROR] Build failed for $dir" >&2
        exit 1
    fi

    cd - >/dev/null || true
    echo "=== Finished $dir ==="
    echo
}

# --- Global setup ---
ls -lah
apt update

git submodule sync
git submodule update --init --recursive

greenzie-release changelog -r "noetic" --with-submodules || true

# --- Main loop ---
for pkg in "${ALL_PACKAGES[@]}"; do
    build_pkg "$pkg"

    deb_prefix="${DEB_MAP[$pkg]:-}"
    if [[ -z "$deb_prefix" ]]; then
        echo "[ERROR] No deb prefix defined for $pkg, skipping install step" >&2
        exit 1
    fi

    deb_dir="$(dirname "$pkg")"

    # debuild places .deb files in parent directory of pkg
    local_deb_files=("./$deb_dir"/../"${deb_prefix}"*.deb)

    if ((${#local_deb_files[@]} > 0)); then
        echo "Installing ${deb_prefix}*.deb from $deb_dir"
        apt -y install "${local_deb_files[@]}"
    else
        echo "[ERROR] Expected deb ${deb_prefix} not found in $deb_dir" >&2
        exit 1
    fi

done

echo "All package builds complete."
