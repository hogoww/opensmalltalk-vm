Class {
	#name : #VMSpurNewSpaceStructureTest,
	#superclass : #VMNewSpaceStructureTests,
	#category : #'VMMakerTestsOrganized-tests'
}

{ #category : #'tests-1-memory-initialization' }
VMSpurNewSpaceStructureTest >> testNewMemoryEdenEndIsAtTheStartOfOldSpace [

	self assert: memory scavenger eden limit equals: memory oldSpaceStart
]

{ #category : #'tests-1-memory-initialization' }
VMSpurNewSpaceStructureTest >> testNewMemoryEdenIsRestOfNewSpace [
	
	self
		assert: memory scavenger eden size
		equals: newSpaceSize - memory scavenger pastSpace size - memory scavenger futureSpace size
]

{ #category : #'tests-1-memory-initialization' }
VMSpurNewSpaceStructureTest >> testNewMemoryFreeStartIsEdenStart [
	
	self assert: memory freeStart equals: memory scavenger eden start
]

{ #category : #'tests-1-memory-initialization' }
VMSpurNewSpaceStructureTest >> testNewMemoryFutureSpaceEndIsAtTheStartOfEden [

	self assert: memory scavenger futureSpace limit equals: memory scavenger eden start
]

{ #category : #'tests-1-memory-initialization' }
VMSpurNewSpaceStructureTest >> testNewMemoryFutureSpaceIsRoughlyOneSeventhOfNewSpace [
	<boostrapTest> "'rougly' is not as precise with the image, apparently"
	self assert: memory scavenger futureSpace size equals: (newSpaceSize // 7 truncateTo: memory allocationUnit)
]

{ #category : #'tests-1-memory-initialization' }
VMSpurNewSpaceStructureTest >> testNewMemoryFutureSurvivorSpaceIsAtFutureSpaceStart [
	
	"The future survivor start indicates during the execution of the scavenger, where the next free space in future space starts."
	
	self assert: memory scavenger futureSurvivorStart equals: memory scavenger futureSpace start
]

{ #category : #'tests-1-memory-initialization' }
VMSpurNewSpaceStructureTest >> testNewMemoryPastSpaceEndIsAtTheStartOfFutureSpace [

	self assert: memory scavenger pastSpace limit equals: memory scavenger futureSpace start
]

{ #category : #'tests-1-memory-initialization' }
VMSpurNewSpaceStructureTest >> testNewMemoryPastSpaceFreeStartIsAtPastSpaceStart [
	
	" - pastSpaceStart points to where the free space in the past space starts => it **does** move
	  - scavenger pastSpace start points to the actual beginning of the past space => it does not move"
	
	self assert: memory pastSpaceStart equals: memory scavenger pastSpace start
]

{ #category : #'tests-1-memory-initialization' }
VMSpurNewSpaceStructureTest >> testNewMemoryPastSpaceIsAtTheStartOfNewSpace [
	
	self assert: memory scavenger pastSpace start equals: memory newSpaceStart
]

{ #category : #'tests-1-memory-initialization' }
VMSpurNewSpaceStructureTest >> testNewMemoryPastSpaceIsRoughlyOneSeventhOfNewSpace [
	<boostrapTest> "'rougly' is not as precise with the image, apparently"
	self assert: memory scavenger pastSpaceBytes equals: (newSpaceSize // 7 truncateTo: memory allocationUnit)
]
