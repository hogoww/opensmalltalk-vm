#include "theFullInterpreter.h"
#include <stdio.h>
#include "CuTest.h"
#include "VMSpurOldSpaceStructureTest.h"
#include <sys/mman.h>

static void loadPharoImage(char* fileName);

void setUpVMSpurOldSpaceStructureTest(VMSpurOldSpaceStructureTest self){
  loadPharoImage("tempconversion-64.image");
  initStackPages();
}

void tearDownVMSpurOldSpaceStructureTest(VMSpurOldSpaceStructureTest self){
  // can't do that see src/memoryUnix.h
  //munmap((void*)memory, imageSize);
}

void RunAllTests(void)
{
  CuString* output = CuStringNew();
  CuSuite* suite = CuSuiteNew();
  CuSuiteAddSuite(suite,VMSpurOldSpaceStructureTestGetSuite());
  CuSuiteRun(suite);
  CuSuiteSummary(suite, output);
  CuSuiteDetails(suite, output);
  printf("%s\n", output->buffer);
}

int main(){
  RunAllTests();
}

void loadPharoImage(char* fileName)
{
    sqImageFile imageFile = NULL;
    
    /* Open the image file. */
    imageFile = sqImageFileOpen(fileName, "rb");
    if(!imageFile){
      logErrorFromErrno("Opening Image");
      exit(1);
    }

    /* Get the size of the image file*/
    sqImageFileSeekEnd(imageFile, 0);
    sqImageFilePosition(imageFile);
    sqImageFileSeek(imageFile, 0);

    readImageFromFileHeapSizeStartingAt(imageFile, 0, 0);
    sqImageFileClose(imageFile);

    char* fullImageName = alloca(FILENAME_MAX);
}
