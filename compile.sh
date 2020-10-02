#!/bin/bash

targetDirectory="testCompilation"


rm -rf CMakeCache.txt CMakeFiles/ build/ generated/ Illicium/ $targetDirectory
cmake .
make

mkdir $targetDirectory


echo "moving stuff"
./movestuff.sh $targetDirectory

echo "moving to the directory 'target directory' "
source $targetDirectory


if [[ "$OSTYPE" == "linux-gnu"* ]]; then

    echo "Linking flag set"
    LIBPATH=$(pwd)
    export LD_LIBRARY_PATH=$LIBPATH

elif [[ "$OSTYPE" == "darwin"* ]]; then

    echo "Linking flag set"
    LIBPATH=$(pwd)
    export DYLD_LIBRARY_PATH=$LIBPATH

fi
