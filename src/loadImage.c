#include "loadImage.h"

int loadPharoImage(char* fileName)
{
    size_t imageSize = 0;
    sqImageFile imageFile = NULL;

    /* Open the image file. */
    imageFile = sqImageFileOpen(fileName, "rb");
    if(!imageFile)
	{
    	logErrorFromErrno("Opening Image");
        return false;
    }

    /* Get the size of the image file*/
    sqImageFileSeekEnd(imageFile, 0);
    imageSize = sqImageFilePosition(imageFile);
    sqImageFileSeek(imageFile, 0);

    readImageFromFileHeapSizeStartingAt(imageFile, 0, 0);
    sqImageFileClose(imageFile);

    char* fullImageName = alloca(FILENAME_MAX);
	fullImageName = getFullPath(fileName, fullImageName, FILENAME_MAX);

    setImageName(fullImageName);

    return true;
}
 
