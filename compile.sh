#!/bin/bash
rm -rf CMakeCache.txt CMakeFiles/ build/ generated/ Illicium/
cmake .
make

echo "moving stuff"
./movestuff.sh

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "moving to the directory"
    cd ./build/vm

    echo "Linking flag set"
    LIBPATH=$(pwd)
    export LD_LIBRARY_PATH=$LIBPATH

    echo "compilling"
    gcc -fPIC -o main main.c -L. -lPharoVMCore -lpthread -ldl -lm -I../../extracted/vm/include/common -I../../include/pharovm/ -I../../include/ -I../../generated/include/ -I../../extracted/vm/include/unix/ -I../include/pharovm -DLSB_FIRST -DNDEBUG -DDEBUGVM=0 -DIMMUTABILITY=1 -DCOGMTVM=0 -DPharoVM=1 -DVM_LABEL\(foo\)=0 -I. -g

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "moving to the directory"
    cd ./build/vm/Pharo.app/Contents/MacOS/Plugins

    echo "Linking flag set"
    LIBPATH=$(pwd)
    export DYLD_LIBRARY_PATH=$LIBPATH

    echo "compilling"
    gcc -fPIC -o main main.c -L. -lPharoVMCore -lpthread -ldl -lm -I/Users/hogoww/ovm/extracted/vm/include/common -I/Users/hogoww/ovm/include/pharovm -I/Users/hogoww/ovm/include/ -I/Users/hogoww/ovm/generated/include/ -I/Users/hogoww/ovm/extracted/vm/include/osx -I/Users/hogoww/ovm/build/include/pharovm -DNO_ISNAN -DNO_SERVICE -D'TZ=CEST' -D'VM_LABEL(foo)=0' -DLSB_FIRST=1 -DAllocationCheckFiller=0xADD4E55 -I.

fi

./main
gdb main
