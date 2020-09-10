#!/bin/bash
rm -rf CMakeCache.txt CMakeFiles/ build/ generated/ Illicium/
cmake .
make
