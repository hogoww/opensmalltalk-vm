Class {
	#name : #VMSpurOldSpaceTest,
	#superclass : #VMAllocationInOldSpaceTests,
	#category : #'VMMakerTestsOrganized-tests'
}

{ #category : #helper }
VMSpurOldSpaceTest >> allFreeListHeadsSize [
	"initialy from SpurMemoryManager>>#, however its only usage is in self >> #testFreeChunksWithSameSizeShouldShareSingleHead"
	
	| counter |
	counter := 0.
	2 to: memory numFreeLists - 1 do: [:i| | obj |
		obj := memory freeLists at: i.
		obj ~= 0 ifTrue: [ counter := counter + 1 ]].
	^ counter
]

{ #category : #'tests-4-free-tree' }
VMSpurOldSpaceTest >> testAllocateHalfOfTreeNodeShouldSplitIt [
	| size childAddress smallerChildOop largerChildOop aBitBiggerThanHalf |
	
	size := 1600.	"Big enough size to be in the tree"
	childAddress := memory allocateOldSpaceChunkOfBytes: size.
	memory freeChunkWithBytes: size at: childAddress.
	
	aBitBiggerThanHalf := size / 2 + 8.	"node a bit bigger than half"
	childAddress := memory allocateOldSpaceChunkOfBytes: aBitBiggerThanHalf.
	memory freeChunkWithBytes: aBitBiggerThanHalf at: childAddress.
	
	smallerChildOop := self smallerNodeOf: self freeTreeRootOop.
	self assert: (memory bytesInObject: smallerChildOop) equals: (size - aBitBiggerThanHalf).

	largerChildOop := self largerNodeOf: smallerChildOop.
	self assert: (memory bytesInObject: largerChildOop) equals: aBitBiggerThanHalf
]

{ #category : #'tests-4-free-tree' }
VMSpurOldSpaceTest >> testAllocateInFreeTreeShouldChangeRoot [

	| freeRootOopBeforeAllocation |
	freeRootOopBeforeAllocation := self freeTreeRootOop.
	
	memory allocateOldSpaceChunkOfBytes: 800 "Big enough to be in the tree".
	
	self deny: freeRootOopBeforeAllocation equals: self freeTreeRootOop
]

{ #category : #'tests-4-free-tree' }
VMSpurOldSpaceTest >> testAllocationLargerThanFreeListLimitShouldUseFreeTree [

	| firstAddress byteSize smallerNodeOop |
	
	byteSize := memory numFreeLists * memory allocationUnit.
	firstAddress := memory allocateOldSpaceChunkOfBytes: byteSize.
	memory freeChunkWithBytes: byteSize at: firstAddress.
	
	smallerNodeOop := self smallerNodeOf: self freeTreeRootOop.
	self assert: smallerNodeOop equals: firstAddress
]

{ #category : #'tests-3-free-lists' }
VMSpurOldSpaceTest >> testFreeAChunkShouldBePutAsHeadOfFreeList [
	| firstAddress secondAddress freeListHead chunkSize |
	chunkSize := 32.

	firstAddress := memory allocateOldSpaceChunkOfBytes: chunkSize.
	secondAddress := memory allocateOldSpaceChunkOfBytes: chunkSize.
	memory freeChunkWithBytes: chunkSize at: firstAddress.
	memory freeChunkWithBytes: chunkSize at: secondAddress.
	
	freeListHead := self freeListForSize: chunkSize.
	self assert: freeListHead equals: secondAddress
]

{ #category : #'tests-3-free-lists' }
VMSpurOldSpaceTest >> testFreeChunkShouldKnowNextChunkOfSameSize [
	| firstAddress secondAddress freeListHead nextFreeChunk allocationSize |
	allocationSize := 32.
	
	firstAddress := memory allocateOldSpaceChunkOfBytes: allocationSize.
	secondAddress := memory allocateOldSpaceChunkOfBytes: allocationSize.
	memory freeChunkWithBytes: allocationSize at: firstAddress.
	memory freeChunkWithBytes: allocationSize at: secondAddress.
	
	freeListHead := self freeListForSize: allocationSize.
	nextFreeChunk := self nextNodeOf: freeListHead.

	self assert: nextFreeChunk equals: firstAddress
]

{ #category : #'tests-3-free-lists' }
VMSpurOldSpaceTest >> testFreeChunkShouldKnowPreviousChunkOfSameSize [
	| firstAddress secondAddress freeListHead nextFreeChunk allocationSize previousFreeChunk |
	allocationSize := 32.
	
	firstAddress := memory allocateOldSpaceChunkOfBytes: allocationSize.
	secondAddress := memory allocateOldSpaceChunkOfBytes: allocationSize.
	memory freeChunkWithBytes: allocationSize at: firstAddress.
	memory freeChunkWithBytes: allocationSize at: secondAddress.
	
	freeListHead := self freeListForSize: allocationSize.
	nextFreeChunk := self nextNodeOf: freeListHead.

	previousFreeChunk := self previousNodeOf: nextFreeChunk.
	self assert: previousFreeChunk equals: freeListHead
]

{ #category : #'tests-3-free-lists' }
VMSpurOldSpaceTest >> testFreeChunksWithSameSizeShouldShareSingleHead [
	| secondAddress allocationSize firstAddress |
	allocationSize := 32.
	
	firstAddress := memory allocateOldSpaceChunkOfBytes: allocationSize.
	secondAddress := memory allocateOldSpaceChunkOfBytes: allocationSize.
	memory freeChunkWithBytes: allocationSize at: firstAddress.
	memory freeChunkWithBytes: allocationSize at: secondAddress.
	
	self assert: self allFreeListHeadsSize equals: 1
]

{ #category : #'tests-3-free-lists' }
VMSpurOldSpaceTest >> testFreeListsShouldBeIndexedBySlotSize [

	| firstAddress freeListHead |
	
	2 to: 63 do: [ :numberOfSlots | | byteSize |
		byteSize := numberOfSlots * memory allocationUnit.
		
		firstAddress := memory allocateOldSpaceChunkOfBytes: byteSize.
		memory freeChunkWithBytes: byteSize at: firstAddress.
	
		freeListHead := memory freeLists at: numberOfSlots.
		self assert: freeListHead equals: firstAddress
	]
]

{ #category : #'tests-1-startup' }
VMSpurOldSpaceTest >> testInitialFreeListShouldBeEmpty [

	2 to: 63 do: [ :numberOfSlots |
		self
			assert: (memory freeLists at: numberOfSlots)
			equals: 0
	]
]

{ #category : #'tests-1-startup' }
VMSpurOldSpaceTest >> testInitialFreeTreeRootHasNoLargerNode [

	| bigChunk nextNode |
	bigChunk := self freeTreeRootOop.
	nextNode := self largerNodeOf: bigChunk.

	self assert: nextNode equals: 0.
]

{ #category : #'tests-1-startup' }
VMSpurOldSpaceTest >> testInitialFreeTreeRootHasNoNextNode [

	| bigChunk nextNode |
	bigChunk := self freeTreeRootOop.
	nextNode := self nextNodeOf: bigChunk.

	self assert: nextNode equals: 0.
]

{ #category : #'tests-1-startup' }
VMSpurOldSpaceTest >> testInitialFreeTreeRootHasNoParentNode [

	| bigChunk nextNode |
	bigChunk := self freeTreeRootOop.
	nextNode := self parentNodeOf: bigChunk.

	self assert: nextNode equals: 0.
]

{ #category : #'tests-1-startup' }
VMSpurOldSpaceTest >> testInitialFreeTreeRootHasNoPreviousNode [

	| bigChunk nextNode |
	bigChunk := self freeTreeRootOop.
	nextNode := self previousNodeOf: bigChunk.

	self assert: nextNode equals: 0.
]

{ #category : #'tests-1-startup' }
VMSpurOldSpaceTest >> testInitialFreeTreeRootHasNoSmallerNode [

	| bigChunk nextNode |
	bigChunk := self freeTreeRootOop.
	nextNode := self smallerNodeOf: bigChunk.

	self assert: nextNode equals: 0.
]

{ #category : #'tests-1-startup' }
VMSpurOldSpaceTest >> testInitialFreeTreeRootIsFreeObject [

	self assert: (memory isFreeObject: self freeTreeRootOop)
]

{ #category : #'tests-1-startup' }
VMSpurOldSpaceTest >> testInitialFreeTreeRootSizeShouldBeTotalFreeSpace [

	self
		assert: (memory bytesInObject: self freeTreeRootOop)
		equals: memory totalFreeListBytes
]

{ #category : #'tests-4-free-tree' }
VMSpurOldSpaceTest >> testLargeFreeChunkInFreeTreeNodeShouldStoreChunkOop [

	| firstAddress byteSize smallerNodeOop |
	
	byteSize := 256 "large chunk min size" * memory allocationUnit.
	firstAddress := memory allocateOldSpaceChunkOfBytes: byteSize.
	memory freeChunkWithBytes: byteSize at: firstAddress.
	
	smallerNodeOop := self smallerNodeOf: self freeTreeRootOop.
	self assert: (memory startOfObject: smallerNodeOop) equals: firstAddress
]

{ #category : #'tests-1-startup' }
VMSpurOldSpaceTest >> testNewMemoryShouldHaveSingleFreeObject [

	self assert: memory howManyFreeObjects equals: 1
]

{ #category : #'tests-3-free-lists' }
VMSpurOldSpaceTest >> testSingleFreeChunkListNextShouldBeZero [
	| firstAddress freeListHead allocationSize |
	allocationSize := 32.

	firstAddress := memory allocateOldSpaceChunkOfBytes: allocationSize.
	memory freeChunkWithBytes: allocationSize at: firstAddress.

	freeListHead := self freeListForSize: allocationSize.
	self assert: (self nextNodeOf: freeListHead) equals: 0
]

{ #category : #'tests-3-free-lists' }
VMSpurOldSpaceTest >> testSingleFreeChunkListPreviousShouldBeZero [
	| firstAddress freeListHead allocationSize |
	allocationSize := 32.

	firstAddress := memory allocateOldSpaceChunkOfBytes: allocationSize.
	memory freeChunkWithBytes: allocationSize at: firstAddress.

	freeListHead := self freeListForSize: allocationSize.
	self assert: (self previousNodeOf: freeListHead) equals: 0
]
