#!/bin/bash

targetDirectory="testCompilation"


rm -rf CMakeCache.txt CMakeFiles/ build/ generated/ Illicium/ $targetDirectory
cmake .
make

mkdir $targetDirectory

./movestuff.sh $targetDirectory

echo "moving to the directory '$targetDirectory' "
cd $targetDirectory

LIBPATH=$(pwd)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export LD_LIBRARY_PATH=$LIBPATH
    echo "Linking flag set to: $LD_LIBRARY_PATH"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export DYLD_LIBRARY_PATH=$LIBPATH
    echo "Linking flag set to: $DYLD_LIBRARY_PATH"
fi
