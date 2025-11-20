#!/bin/bash
set -x
set -eo pipefail

ls -lah
apt update

git submodule sync
git submodule update --init --recursive

greenzie-release changelog -r "noetic" --with-submodules || true

mkdir -p /tmp/alldebs

### 1) fixposition-sdk / fpsdk_common
cd fixposition-sdk/fpsdk_common
greenzie-release changelog -r "noetic" --with-submodules
apt -y build-dep .
debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt
cd ..
apt -y install ./ros-noetic-fpsdk-common*.deb
cp ./ros-noetic-fpsdk-common_*.deb /tmp/alldebs/


### 2) fixposition-sdk / fpsdk_ros1
cd fpsdk_ros1
greenzie-release changelog -r "noetic" --with-submodules
apt -y build-dep .
debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt
cd ..
apt -y install ./ros-noetic-fpsdk-ros1*.deb
cp ./ros-noetic-fpsdk-ros1_*.deb /tmp/alldebs/

### 3) fixposition_driver_lib
cd ../fixposition_driver_lib
greenzie-release changelog -r "noetic" --with-submodules
apt -y build-dep .
debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt
cd ..
apt -y install ./ros-noetic-fixposition-driver-lib*.deb
cp ./ros-noetic-fixposition-driver-lib_*.deb /tmp/alldebs/

### 4) fixposition_driver_msgs
cd fixposition_driver_msgs
greenzie-release changelog -r "noetic" --with-submodules
apt -y build-dep .
debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt
cd ..
apt -y install ./ros-noetic-fixposition-driver-msgs*.deb
cp ./ros-noetic-fixposition-driver-msgs_*.deb /tmp/alldebs/

### 5) fixposition_driver_ros1
cd fixposition_driver_ros1
greenzie-release changelog -r "noetic" --with-submodules
apt -y build-dep .
debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt
cd ..
apt -y install ./ros-noetic-fixposition-driver-ros1*.deb
cp ./ros-noetic-fixposition-driver-ros1_*.deb /tmp/alldebs/

### 6) rtcm_msgs
cd rtcm_msgs
greenzie-release changelog -r "noetic" --with-submodules
apt -y build-dep .
debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt
cd ..
apt -y install ./ros-noetic-rtcm-msgs*.deb
cp ./ros-noetic-rtcm-msgs_*.deb /tmp/alldebs/


### Package collection
mkdir -p /artifacts
cd /tmp
tar cvf /artifacts/all_debs.tar ./alldebs/*.deb
### Done
echo "All package builds complete."
