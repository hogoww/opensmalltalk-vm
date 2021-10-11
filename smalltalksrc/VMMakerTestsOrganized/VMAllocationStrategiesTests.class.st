Class {
	#name : #VMAllocationStrategiesTests,
	#superclass : #VMMemoryAllocationTests,
	#category : #'VMMakerTestsOrganized-subcategory'
}

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateAllFreeMemoryShouldLeaveNoFreeMemory [

	memory allocateOldSpaceChunkOfBytes: memory totalFreeListBytes.
	
	self assert: memory totalFreeListBytes equals: 0
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateBestFitInListShouldAddLeftoverInList [

	self createFreeChunkOfSize: 120.
	self createFreeChunkOfSize: 160.

	"Not exact, nor multiple of a power of 2"
	memory allocateOldSpaceChunkOfBytes: 96.

	self denyFreeListEmpty: (self freeListForSize: 24)
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateBestFitInListShouldRemoveSmallerNodeFromLists [

	self createFreeChunkOfSize: 120.
	self createFreeChunkOfSize: 160.

	"Not exact, nor multiple of a power of 2"
	memory allocateOldSpaceChunkOfBytes: 96.

	self assertFreeListEmpty: (self freeListForSize: 120)
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateBestFitInListShouldReuseSmallerAddress [

	| smallerAddress newAddress |
	smallerAddress := self createFreeChunkOfSize: 120.
	self createFreeChunkOfSize: 160.

	"Not exact, nor multiple of a power of 2"
	newAddress := memory allocateOldSpaceChunkOfBytes: 96.

	self assert: newAddress equals: smallerAddress
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateBestFitInListShouldUseIgnoreBiggerChunk [

	self createFreeChunkOfSize: 120.
	self createFreeChunkOfSize: 160.

	"Not exact, nor multiple of a power of 2"
	memory allocateOldSpaceChunkOfBytes: 96.

	self denyFreeListEmpty: (self freeListForSize: 160)
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateChunkOfMemoryShouldHaveSoMuchMemoryLessAfter [

	| someBytes freeBytesBefore |
	someBytes := 32.
	freeBytesBefore := memory totalFreeListBytes.
	memory allocateOldSpaceChunkOfBytes: someBytes.
	
	self assert: memory totalFreeListBytes equals: freeBytesBefore - someBytes
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateExactBiggerChunkShouldNotReuseSmallFreeChunk [

	| secondAddress newAddress |
	secondAddress := memory allocateOldSpaceChunkOfBytes: 160.
	memory freeChunkWithBytes: 160 at: secondAddress.

	newAddress := memory allocateOldSpaceChunkOfBytes: 240.
	self deny: newAddress equals: secondAddress
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateExactFitInListShouldIgnoreBiggerChunks [

	self createFreeChunkOfSize: 160.
	self createFreeChunkOfSize: 200.

	memory allocateOldSpaceChunkOfBytes: 160.

	self assertFreeListEmpty: (self freeListForSize: 160).
	self denyFreeListEmpty: (self freeListForSize: 200)
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateExactFitInListShouldRemoveNodeFromList [

	| secondAddress |
	secondAddress := memory allocateOldSpaceChunkOfBytes: 160.
	memory freeChunkWithBytes: 160 at: secondAddress.

	memory allocateOldSpaceChunkOfBytes: 160.
	self assert: (self freeListForSize: 160) equals: 0
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateExactFitInListShouldReuseAddress [

	| secondAddress newAddress |
	secondAddress := self createFreeChunkOfSize: 160.

	newAddress := memory allocateOldSpaceChunkOfBytes: 160.
	self assert: newAddress equals: secondAddress
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateExactFitTreeRootShouldRemoveRootFromTree [

	memory allocateOldSpaceChunkOfBytes: (memory bytesInObject: self freeTreeRootOop).

	self assert: self freeTreeRootOop equals: 0
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateExactTreeRootShouldReuseRootAddress [

	| oldRootAddress newAddress |
	oldRootAddress := self freeTreeRootStartAddress.

	newAddress := memory allocateOldSpaceChunkOfBytes: (memory bytesInObject: self freeTreeRootOop).

	self assert: newAddress equals: oldRootAddress
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateManyChunksShouldKeepSingleFreeEntry [

	"Allocation should be contiguous because we have a single big chunk of memory to take memory from"
	memory allocateOldSpaceChunkOfBytes: 160.
	memory allocateOldSpaceChunkOfBytes: 160.
	memory allocateOldSpaceChunkOfBytes: 160.

	self assert: memory howManyFreeObjects equals: 1
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateMoreThanFreeMemoryShouldFailReturningNil [
	
	| address |
	address := memory allocateOldSpaceChunkOfBytes: memory totalFreeListBytes + 1.
	
	self assert: address isNil
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocatePartOfTreeRootShouldAddBigLeftOverAsFreeTreeRoot [

	| leftOverSize |
	leftOverSize := 64 * 8 "more than 63 slots".
	memory allocateOldSpaceChunkOfBytes: (memory totalFreeListBytes - leftOverSize).

	self assert: (memory bytesInObject: self freeTreeRootOop) equals: leftOverSize
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocatePartOfTreeRootShouldAddSmallLeftOverInFreeList [

	| leftOverSize |
	leftOverSize := 120.
	memory allocateOldSpaceChunkOfBytes: (memory totalFreeListBytes - leftOverSize).

	self denyFreeListEmpty: (self freeListForSize: leftOverSize)
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocatePartOfTreeRootShouldReuseRootAddress [

	| oldRootAddress newAddress |
	oldRootAddress := self freeTreeRootStartAddress.

	"At this point we can allocate whatever we want, only the tree has space, so we will take space from the tree anyways"
	self assert: 120 < (memory bytesInObject: self freeTreeRootOop).
	newAddress := memory allocateOldSpaceChunkOfBytes: 120.

	self assert: newAddress equals: oldRootAddress
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocatePowerInListShouldAddLeftoverInList [

	| sizeToAllocate powerOfSizeToAllocate leftOverSize |
	sizeToAllocate := 80.
	powerOfSizeToAllocate := sizeToAllocate * (2 ** 2).
	leftOverSize := powerOfSizeToAllocate - sizeToAllocate.
	self createFreeChunkOfSize: powerOfSizeToAllocate.

	memory allocateOldSpaceChunkOfBytes: sizeToAllocate.
	self denyFreeListEmpty: (self freeListForSize: leftOverSize)
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocatePowerInListShouldIgnoreNonPowers [

	| sizeToAllocate powerOfSizeToAllocate nonMultipleAddress newAddress |
	sizeToAllocate := 80.
	powerOfSizeToAllocate := sizeToAllocate * (2 ** 2).
	
	nonMultipleAddress := self createFreeChunkOfSize: 120.
	self createFreeChunkOfSize: powerOfSizeToAllocate.

	newAddress := memory allocateOldSpaceChunkOfBytes: sizeToAllocate.
	self deny: newAddress equals: nonMultipleAddress
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocatePowerInListShouldRemoveNodeFromList [

	| sizeToAllocate powerOfSizeToAllocate |
	sizeToAllocate := 80.
	powerOfSizeToAllocate := sizeToAllocate * (2 ** 2).
	self createFreeChunkOfSize: powerOfSizeToAllocate.

	memory allocateOldSpaceChunkOfBytes: sizeToAllocate.
	self assertFreeListEmpty: (self freeListForSize: powerOfSizeToAllocate)
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocatePowerInListShouldReuseMultipleAddress [

	| sizeToAllocate freeMultipleAddress newAddress powerOfSizeToAllocate |
	sizeToAllocate := 80.
	powerOfSizeToAllocate := sizeToAllocate * (2 ** 2).
	freeMultipleAddress := self createFreeChunkOfSize: powerOfSizeToAllocate.

	newAddress := memory allocateOldSpaceChunkOfBytes: sizeToAllocate.
	self assert: newAddress equals: freeMultipleAddress
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocateSmallerChunkShouldReusePartiallyFreeChunk [

	| secondAddress newAddress |
	secondAddress := memory allocateOldSpaceChunkOfBytes: 160.
	memory freeChunkWithBytes: 160 at: secondAddress.

	newAddress := memory allocateOldSpaceChunkOfBytes: 80.
	self assert: newAddress equals: secondAddress
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocatedChunkAddressesShouldBeInAllocationOrder [

	| secondAddress thirdAddress |
	memory allocateOldSpaceChunkOfBytes: 160.
	secondAddress := memory allocateOldSpaceChunkOfBytes: 160.
	thirdAddress := memory allocateOldSpaceChunkOfBytes: 160.
	
	self assert: secondAddress < thirdAddress
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocatedChunkOfMemoryShouldRemoveSpaceFromFreeList [

	| freeChunkStartAddress allocatedSize |
	allocatedSize := 16.
	freeChunkStartAddress := self freeTreeRootStartAddress.
	memory allocateOldSpaceChunkOfBytes: allocatedSize.
	self
		assert: self freeTreeRootStartAddress
		equals: allocatedSize + freeChunkStartAddress  
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocatedChunkOfMemoryShouldStartWhereFreeChunkStarted [

	| freeChunkStartAddressBeforeAllocation allocatedAddress |
	freeChunkStartAddressBeforeAllocation := self freeTreeRootStartAddress.
	allocatedAddress := memory allocateOldSpaceChunkOfBytes: 16.
	self
		assert: allocatedAddress
		equals: freeChunkStartAddressBeforeAllocation
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testAllocationShouldNotLeaveFreeChunkSmallerThanLiliputian [

	| newAddress freeLargeSpaceAddressBeforeAllocation freeAddress |
	freeAddress := memory allocateOldSpaceChunkOfBytes: 32.
	memory freeChunkWithBytes: 32 at: freeAddress.

	"Allocating 24 bytes should not reuse the 32bytes free chunk because it will leave a free chunk < 16bytes (a liliputian)"	
	freeLargeSpaceAddressBeforeAllocation := self freeTreeRootStartAddress.
	newAddress := memory allocateOldSpaceChunkOfBytes: 24.

	self assert: newAddress equals: freeLargeSpaceAddressBeforeAllocation
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testChildNodeShouldHaveRootAsParent [

	| smallerChild freeTreeRoot parentNode |
	memory freeChunkWithBytes: 800 at: (memory allocateOldSpaceChunkOfBytes: 800).
	freeTreeRoot := memory freeLists at: 0.
	smallerChild := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: freeTreeRoot.
	
	parentNode := memory fetchPointer: memory freeChunkParentIndex ofFreeChunk: smallerChild.
	
	self assert: parentNode equals: freeTreeRoot
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testChildSiblingNodesInFreeTreeShouldHavePrevious [

	| freeTreeRoot size child1 child2 nextChildOop child3 siblingOop previousOop |
	size := 800.
	child1 := memory allocateOldSpaceChunkOfBytes: size.
	child2 := memory allocateOldSpaceChunkOfBytes: size.
	child3 := memory allocateOldSpaceChunkOfBytes: size.	
	memory freeChunkWithBytes: size at: child1.
	memory freeChunkWithBytes: size at: child2.
	memory freeChunkWithBytes: size at: child3.
		
	freeTreeRoot := memory freeLists at: 0.

	nextChildOop := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: freeTreeRoot.
	previousOop := memory fetchPointer: memory freeChunkPrevIndex ofFreeChunk: nextChildOop.
	self assert: previousOop equals: 0.
	
	siblingOop := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: nextChildOop.
	previousOop := memory fetchPointer: memory freeChunkPrevIndex ofFreeChunk: siblingOop.
	self assert: previousOop equals: nextChildOop.

	siblingOop := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: nextChildOop.
	previousOop := memory fetchPointer: memory freeChunkPrevIndex ofFreeChunk: siblingOop.
	self assert: previousOop equals: nextChildOop.
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testChildSiblingNodesInFreeTreeShouldNotHaveLarger [

	| freeTreeRoot size child1 child2 nextChildOop child3 largerOop largerThanSmaller siblingOop |
	size := 800.
	child1 := memory allocateOldSpaceChunkOfBytes: size.
	child2 := memory allocateOldSpaceChunkOfBytes: size.
	child3 := memory allocateOldSpaceChunkOfBytes: size.	

	"Create a smaller than smaller chunk to check that this is not propagated to smaller siblings"
	largerThanSmaller := memory allocateOldSpaceChunkOfBytes: 808.

	memory freeChunkWithBytes: size at: child1.
	memory freeChunkWithBytes: size at: child2.
	memory freeChunkWithBytes: size at: child3.
	memory freeChunkWithBytes: 808 at: largerThanSmaller.
		
	freeTreeRoot := memory freeLists at: 0.

	nextChildOop := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: freeTreeRoot.
	largerOop := memory fetchPointer: memory freeChunkLargerIndex ofFreeChunk: nextChildOop.
	self assert: (memory startOfObject: largerOop) equals: largerThanSmaller.
	
	siblingOop := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: nextChildOop.
	largerOop := memory fetchPointer: memory freeChunkLargerIndex ofFreeChunk: siblingOop.
	self assert: largerOop equals: 0.

	siblingOop := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: siblingOop.
	largerOop := memory fetchPointer: memory freeChunkLargerIndex ofFreeChunk: siblingOop.
	self assert: largerOop equals: 0.
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testChildSiblingNodesInFreeTreeShouldNotHaveParent [

	| freeTreeRoot size child1 child2 nextChild child3 parentOop |
	size := 800.
	child1 := memory allocateOldSpaceChunkOfBytes: size.
	child2 := memory allocateOldSpaceChunkOfBytes: size.
	child3 := memory allocateOldSpaceChunkOfBytes: size.
	memory freeChunkWithBytes: size at: child1.
	memory freeChunkWithBytes: size at: child2.
	memory freeChunkWithBytes: size at: child3.
		
	freeTreeRoot := memory freeLists at: 0.

	nextChild := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: freeTreeRoot.
	parentOop := memory fetchPointer: memory freeChunkParentIndex ofFreeChunk: nextChild.
	self assert: parentOop equals: freeTreeRoot.
	
	nextChild := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: nextChild.
	parentOop := memory fetchPointer: memory freeChunkParentIndex ofFreeChunk: nextChild.
	self assert: parentOop equals: 0.

	nextChild := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: nextChild.
	parentOop := memory fetchPointer: memory freeChunkParentIndex ofFreeChunk: nextChild.
	self assert: parentOop equals: 0.
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testChildSiblingNodesInFreeTreeShouldNotHaveSmaller [

	| freeTreeRoot size child1 child2 nextChildOop child3 smallerOop smallerThanSmaller siblingOop |
	size := 800.
	child1 := memory allocateOldSpaceChunkOfBytes: size.
	child2 := memory allocateOldSpaceChunkOfBytes: size.
	child3 := memory allocateOldSpaceChunkOfBytes: size.	

	"Create a smaller than smaller chunk to check that this is not propagated to smaller siblings"
	smallerThanSmaller := memory allocateOldSpaceChunkOfBytes: 792.

	memory freeChunkWithBytes: size at: child1.
	memory freeChunkWithBytes: size at: child2.
	memory freeChunkWithBytes: size at: child3.
	memory freeChunkWithBytes: 792 at: smallerThanSmaller.
		
	freeTreeRoot := memory freeLists at: 0.

	nextChildOop := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: freeTreeRoot.
	smallerOop := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: nextChildOop.
	self assert: (memory startOfObject: smallerOop) equals: smallerThanSmaller.
	
	siblingOop := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: nextChildOop.
	smallerOop := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: siblingOop.
	self assert: smallerOop equals: 0.

	siblingOop := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: siblingOop.
	smallerOop := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: siblingOop.
	self assert: smallerOop equals: 0.
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testDeallocateShouldNotChangeRoot [

	| freeRoot address |	
	address := memory allocateOldSpaceChunkOfBytes: 800.

	freeRoot := memory freeLists at: 0.
	memory freeChunkWithBytes: 800 at: address.
	
	self assert: freeRoot equals: (memory freeLists at: 0)
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testEqualSizeChildNodeInFreeTreeShouldBeInsertedAfterHead [

	| smallerChild freeTreeRoot size child1 child2 nextChild child3 |
	size := 800.
	child1 := memory allocateOldSpaceChunkOfBytes: size.
	child2 := memory allocateOldSpaceChunkOfBytes: size.
	child3 := memory allocateOldSpaceChunkOfBytes: size.
	memory freeChunkWithBytes: size at: child1.
	memory freeChunkWithBytes: size at: child2.
	memory freeChunkWithBytes: size at: child3.
		
	freeTreeRoot := memory freeLists at: 0.
	smallerChild := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: freeTreeRoot.
	
	self assert: smallerChild equals: child1.
	nextChild := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: child1.
	self assert: nextChild equals: child3.
	nextChild := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: child3.
	self assert: nextChild equals: child2.
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testEqualSizeChildNodeShouldBeNextNode [

	| smallerChild freeTreeRoot size child1 child2 nextChild |
	size := 800.
	child1 := memory allocateOldSpaceChunkOfBytes: size.
	child2 := memory allocateOldSpaceChunkOfBytes: size.
	memory freeChunkWithBytes: size at: child1.
	memory freeChunkWithBytes: size at: child2.
		
	freeTreeRoot := memory freeLists at: 0.
	smallerChild := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: freeTreeRoot.
	
	self assert: smallerChild equals: child1.
	nextChild := memory fetchPointer: memory freeChunkNextIndex ofFreeChunk: child1.
	self assert: nextChild equals: child2.
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testFreeChunkDoesNotGetMergedWithExistingFreeChunks [

	| secondAddress |
	secondAddress := memory allocateOldSpaceChunkOfBytes: 160.
	memory freeChunkWithBytes: 160 at: secondAddress.

	self assert: memory howManyFreeObjects equals: 2
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testFreeChunksWithSameSizeShouldBeListedAsDifferentFreeChunks [

	| secondAddress newAddress |
	secondAddress := memory allocateOldSpaceChunkOfBytes: 160.
	memory freeChunkWithBytes: 160 at: secondAddress.
	newAddress := memory allocateOldSpaceChunkOfBytes: 80.
	memory freeChunkWithBytes: 80 at: newAddress.
	
	self assert: memory howManyFreeObjects equals: 3
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testNewBigFreeChunkShouldBeFreeTreeChild [

	| firstAddress freeRoot rootSize moreThanHalf newRoot largerChildOop |
	freeRoot := memory freeLists at: 0.
	rootSize := memory bytesInObject: freeRoot.
	
	moreThanHalf := (rootSize / memory allocationUnit / 2) + 1 * memory allocationUnit.
	
	"Create a free chunk of more than half of the root, the root has changed"
	firstAddress := memory allocateOldSpaceChunkOfBytes: moreThanHalf.
	memory freeChunkWithBytes: moreThanHalf at: firstAddress.
	newRoot := memory freeLists at: 0.

	"Nodes in the free tree are organized as oops. Each oop points to the base header of the object"
	largerChildOop := memory fetchPointer: memory freeChunkLargerIndex ofFreeChunk: newRoot.
	"instead, the address returned by allocateOldSpaceChunkOfBytes: returns always an address, not an oop."
	"To get the real address where the oop starts use #startOfObject:"
	self assert: (memory startOfObject: largerChildOop) equals: firstAddress
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testNewBigFreeChunkShouldHaveRootAsParent [

	| firstAddress freeRoot rootSize moreThanHalf newRoot largerChildOop parentNodeOop |
	freeRoot := memory freeLists at: 0.
	rootSize := memory bytesInObject: freeRoot.
	
	moreThanHalf := (rootSize / memory allocationUnit / 2) + 1 * memory allocationUnit.
	self assert: moreThanHalf > (rootSize / 2).
	
	"Create a free chunk of more than half of the root, the root has changed"
	firstAddress := memory allocateOldSpaceChunkOfBytes: moreThanHalf.
	memory freeChunkWithBytes: moreThanHalf at: firstAddress.
	newRoot := memory freeLists at: 0.

	"Nodes in the free tree are organized as oops. Each oop points to the base header of the object"
	largerChildOop := memory fetchPointer: memory freeChunkLargerIndex ofFreeChunk: newRoot.
	parentNodeOop := memory fetchPointer: memory freeChunkParentIndex ofFreeChunk: largerChildOop.
	
	self assert: parentNodeOop equals: newRoot
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testNewObjectShouldBeOld [
	
	| oop |
	oop := self newOldSpaceObjectWithSlots: 0.
	
	self assert: (memory isOldObject: oop)
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testPartiallyReusingFreeChunkShouldKeepNumberOfEntriesInFreeList [

	| secondAddress freeChunksBefore |
	secondAddress := memory allocateOldSpaceChunkOfBytes: 160.

	memory freeChunkWithBytes: 160 at: secondAddress.
	freeChunksBefore := memory howManyFreeObjects.
	memory allocateOldSpaceChunkOfBytes: 80.
	
	self assert: memory howManyFreeObjects equals: freeChunksBefore.
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testReuseFreeChunkShouldRemoveEntryFromFreeList [

	| secondAddress |
	secondAddress := memory allocateOldSpaceChunkOfBytes: 160.
	memory freeChunkWithBytes: 160 at: secondAddress.
	memory allocateOldSpaceChunkOfBytes: 160.
	
	self assert: memory howManyFreeObjects equals: 1
]

{ #category : #'tests-VMSpurOldspaceTests' }
VMAllocationStrategiesTests >> testSmallerChildNodeShouldBeFreeTreeChild [

	| smallerChild freeTreeRoot parentNode smallerSize rootSize |
	smallerSize := 800.
	rootSize := memory bytesInObject: (memory freeLists at: 0).
	self assert: smallerSize < (rootSize / 2).

	memory freeChunkWithBytes: smallerSize at: (memory allocateOldSpaceChunkOfBytes: smallerSize).
	freeTreeRoot := memory freeLists at: 0.
	smallerChild := memory fetchPointer: memory freeChunkSmallerIndex ofFreeChunk: freeTreeRoot.
	
	parentNode := memory fetchPointer: memory freeChunkParentIndex ofFreeChunk: smallerChild.
	
	self assert: parentNode equals: freeTreeRoot
]
