CC=gcc
LIBRARIES_FLAGS=-lpthread -ldl -lm
VM_LIBRARY_FLAG=-lPharoVMCore
VM_PATHS=-L. -I. -I../extracted/vm/include/common/ -I../include/pharovm/ -I../include/ -I../generated/include/ -I../extracted/vm/include/unix/ -I../build/include/pharovm/
VM_MACROS=-DLSB_FIRST -DNDEBUG -DDEBUGVM=0 -DIMMUTABILITY=1 -DCOGMTVM=0 -DPharoVM=1 -DVM_LABEL\(foo\)=0
FLAGS=-fPIC -g
SUPPORT_FILES=cTestCase.c loadImage.c
TEST_CLASS_FILE=VMPinnedObjectTest.c

TESTS=VMPinnedObjectTest__testAllocatingObjectAfterTwoPinObjectShouldSlideAtStartOfOldSpace\
VMPinnedObjectTest__testAllocatingObjectRightAfterPinnedShouldMoveItOnFirstDead\
VMPinnedObjectTest__testAllocatingObjectAfterAPinObjectShouldSlideAtStartOfOldSpace\
VMPinnedObjectTest__testPinANewObjectShouldMoveItToTheOldSpaceAndLeaveAForwarderBehind\
VMPinnedObjectTest__testAllocatingObjectAfterAPinObjectShouldSlideBeforeLastPinnedObject\
VMPinnedObjectTest__testPinANewObjectShouldMoveItToTheOldSpace\
VMPinnedObjectTest__testAllocatingObjectAfterManyPinnedObjectShouldSlideAtStartOfOldSpace\
VMPinnedObjectTest__testPinnedObjectShouldNotBeMovedByGC\
VMPinnedObjectTest__testAllocatingObjectAfterManyPinnedObjectShouldSlideBeforeFirstPinned

.DELETE_ON_ERROR:
default_target: $(TESTS)
.PHONY: default_target

sayCompile:
	rm log.txt
	@echo "compiling all $(TEST_CLASS_FILE) tests."

$(TESTS):
	@echo " compiling $@."
	$(CC) -o $@ $@.c $(LIBRARIES_FLAGS) $(VM_LIBRARY_FLAG) $(VM_PATHS) $(VM_MACROS) $(FLAGS)  $(SUPPORT_FILES) $(TEST_CLASS_FILE)
	echo "$@" >> log.txt
	./$@ >> log.txt
	rm $@

compileAllTests: sayCompile $(TESTS)
	@echo "done"


cleanTests: 
