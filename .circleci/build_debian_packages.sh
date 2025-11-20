set -x
ls -lah
git submodule sync
git submodule update --init --recursive
cd fixposition-sdk
greenzie-release changelog -r "noetic" --with-submodules
