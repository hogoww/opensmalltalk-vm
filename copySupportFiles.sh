defaultTarget="testCompilation"

#######################
# Argument management #
#######################
targetDirectory=""
if test "$#" -eq 0; then
    #Default
    targetDirectory=$defaultTarget
elif test "$#" -eq 1; then
    #Set from Argument
    targetDirectory=$1
elif test true; then
    echo 'usage: ./copystuff.sh [ targetPath ]'
    exit 1
fi

##########################################
# Checks whether the work is done or not #
##########################################
if [ -d "$targetDirectory" ]; then
    echo "Prep work is done !"
    exit 0
else
    if [ -e "$targetDirectory" ]; then
	#we don't do anything to not risk loosing something
	echo "$targetDirectory already exists !"
	exit 1
    fi
fi

mkdir "$targetDirectory"

##############################
# Copying every support file #
##############################
echo "Copying support files into directory $targetDirectory"

#vmLibraryDirectory
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cp ./build/build/vm/* $targetDirectory
elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp ./build/build/vm/Debug/Pharo.app/Contents/MacOS/Plugins/* $targetDirectory
elif test true; then
    echo "Unsupported OS"
    exit 1
fi

# Sources
cp ./build/generated/64/vm/src/* $targetDirectory
cp ./build/generated/64/vm/include/*.h $targetDirectory

# Support
cp ./tempConversion-64.image $targetDirectory
cp ./src/loadImage.c $targetDirectory
cp ./src/cTestCase.c $targetDirectory
cp ../llstructures/llDictionary.c $targetDirectory
cp ../llstructures/llDictionary.h $targetDirectory
