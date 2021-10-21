echo "moving stuff into directory $1"

#####cannot seem to use bash variables with cp, I give up.
#To adapt to your own image name
#imageName="Fangleureu"

vmLibraryDirectory=""
#imagePath=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    vmLibraryDirectory="./build/vm/*"
    #imagePath="~/Pharo/images/"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    vmLibraryDirectory="./build/vm/Pharo.app/Contents/MacOS/Plugins/*"
    #imagePath="~/Documents/Pharo/images/"
fi

cp $vmLibraryDirectory $1
cp ./main.c $1
cp ./setupImage.c $1
#cp -v $imagePath$imageName/generated/tests/*.h $1
cp ./generated/vm/src/* $1
cp ./generated/vm/include/*.h $1
cp ./tempConversion-64.image $1
cp ./src/loadImage.c $1
cp ./generatedV

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cp ~/Pharo/images/muovm/generated/tests/Makefile $1
    cp ~/Pharo/images/muovm/generated/tests*.makefile $1
    cp ~/Pharo/images/muovm/generated/tests/*.h $1
    cp ~/Pharo/images/muovm/generated/tests/*.c $1
elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp ~/Documents/Pharo/images/muov2m/generated/tests/Makefile $1
    cp ~/Documents/Pharo/images/muovm2/generated/tests/*.makefile $1
    cp ~/Documents/Pharo/images/muovm2/generated/tests/*.h $1
    cp ~/Documents/Pharo/images/muovm2/generated/tests/*.c $1
fi
