#!/bin/bash
rm -rf CMakeFileS/ build/ generated/ Illicium/ CMakeCache.txt
cmake .
make
