#!/bin/bash

targetDirectory="testCompilation"


rm -rf CMakeCache.txt CMakeFiles/ build/ generated/ Illicium/ $targetDirectory
cmake .
make

mkdir $targetDirectory

./movestuff.sh $targetDirectory


