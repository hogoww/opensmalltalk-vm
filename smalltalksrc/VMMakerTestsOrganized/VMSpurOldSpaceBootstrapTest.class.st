Class {
	#name : #VMSpurOldSpaceBootstrapTest,
	#superclass : #VMOldSpaceStructureTests,
	#category : #'VMMakerTestsOrganized-tests'
}

{ #category : #'tests-memory-bootstrap' }
VMSpurOldSpaceBootstrapTest >> testFreeListHasAsManySlotsAsRequiredByTheVM [

	| freeListOop |
	freeListOop := memory initializeFreeList.

	self assert: (memory numSlotsOf: freeListOop) equals: memory numFreeLists
]

{ #category : #'tests-memory-bootstrap' }
VMSpurOldSpaceBootstrapTest >> testFreeListIsWordIndexable [

	| freeListOop |
	freeListOop := memory initializeFreeList.

	self assert: (memory formatOf: freeListOop) equals: memory wordIndexableFormat
]

{ #category : #'tests-memory-bootstrap' }
VMSpurOldSpaceBootstrapTest >> testNewFreeListHasAllSlotsInitializedInZero [
	<doNotGenerate>
	"  0 to: memory numFreeLists
	typing issue"
	
	| freeListOop |
	freeListOop := memory initializeFreeList.

	0 to: memory numFreeLists - 1 do: [ :i |
		self assert: (memory fetchPointer: i ofObject: freeListOop) equals: 0 ]
]

{ #category : #'tests-memory-bootstrap' }
VMSpurOldSpaceBootstrapTest >> testNewFreeListIsValid [

	memory initializeFreeList.
	memory validFreeTree
]

{ #category : #'tests-memory-bootstrap' }
VMSpurOldSpaceBootstrapTest >> testNewFreeListIsValid2 [

	memory initializeFreeList.
	memory totalFreeListBytes
]
