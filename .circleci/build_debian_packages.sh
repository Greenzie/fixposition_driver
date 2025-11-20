#!/bin/bash
set -x
ls -lah
apt update
git submodule sync
git submodule update --init --recursive
cd fixposition-sdk
greenzie-release changelog -r "noetic" --with-submodules
apt -y build-dep ./fpsdk_common
apt -y build-dep ./fpsdk_ros1
cd fpsdk_common && debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt
apt -y install ../ros-noetic-fpsdk-common*.deb
cd ../fpsdk_ros1 && debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt
apt -y install ../ros-noetic-fpsdk-ros1*.deb
cd ../../
cd fixposition_driver_lib/
greenzie-release changelog -r "noetic" --with-submodules
apt -y build-dep .
debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt


