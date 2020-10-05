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
    vmLibraryDirectory="" #todo at the office.
    #imagePath="~/Documents/Pharo/images/"
fi

cp $vmLibraryDirectory $1
cp ./main.c $1
cp ./setupImage.c $1
#cp -v $imagePath$imageName/generated/tests/*.h $1
cp ./generated/vm/src/* $1
cp ./generated/vm/include/*.h $1
cp ./tempconversion-64.image $1
cp ./CuTest.* $1

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cp ~/Pharo/images/Fangleureu/generated/tests/*.h $1
    cp ~/Pharo/images/Fangleureu/generated/tests/*.c $1
elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp ~/Documents/Pharo/images/Fangleureu/generated/tests/*.h $1
    cp ~/Documents/Pharo/images/Fangleureu/generated/tests/*.c $1
fi
