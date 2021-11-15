echo "moving stuff into directory $1"

#####cannot seem to use bash variables with cp, I give up.
#To adapt to your own image name
#imageName="Fangleureu"

vmLibraryDirectory=""
#imagePath=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    vmLibraryDirectory="./build/build/vm/*"
    #imagePath="~/Pharo/images/"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    vmLibraryDirectory="./build/build/vm/Debug/Pharo.app/Contents/MacOS/Plugins/*"
    #imagePath="~/Documents/Pharo/images/"
fi

cp $vmLibraryDirectory $1
cp ./build/generated/64/vm/src/* $1
cp ./build/generated/64/vm/include/*.h $1
cp ./tempConversion-64.image $1
cp ./src/loadImage.c $1
cp ../llstructures/llDictionary.* $1

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cp ~/Pharo/images/muOvm/generated/tests/Makefile $1
    cp ~/Pharo/images/muOvm/generated/tests/*.makefile $1
    cp ~/Pharo/images/muOvm/generated/tests/*.h $1
    cp ~/Pharo/images/muOvm/generated/tests/*.c $1
elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp ~/Documents/Pharo/images/muovm/generated/tests/Makefile $1
    cp ~/Documents/Pharo/images/muovm/generated/tests/*.makefile $1
    cp ~/Documents/Pharo/images/muovm/generated/tests/*.h $1
    cp ~/Documents/Pharo/images/muovm/generated/tests/*.c $1
fi
