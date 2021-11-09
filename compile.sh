#!/bin/bash

targetDirectory="testCompilation"


rm -rf CMakeCache.txt CMakeFiles/ build/ generated/ Illicium/ $targetDirectory
mkdir build
cmake -S ./ -B build -DPHARO_DEPENDENCIES_PREFER_DOWNLOAD_BINARIES=True
cd build && make

mkdir $targetDirectory

./movestuff.sh $targetDirectory


