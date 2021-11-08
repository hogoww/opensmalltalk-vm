#!/bin/bash

targetDirectory="testCompilation"


rm -rf CMakeCache.txt CMakeFiles/ build/ generated/ Illicium/ $targetDirectory
cmake . -DPHARO_DEPENDENCIES_PREFER_DOWNLOAD_BINARIES=True

make

mkdir $targetDirectory

./movestuff.sh $targetDirectory


