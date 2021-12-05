#!/bin/bash


rm -rf CMakeCache.txt CMakeFiles/ build/ generated/ Illicium/ testCompilation
mkdir build
cmake -S ./ -B build -DPHARO_DEPENDENCIES_PREFER_DOWNLOAD_BINARIES=True
make -C build

./copySupportFiles.sh


