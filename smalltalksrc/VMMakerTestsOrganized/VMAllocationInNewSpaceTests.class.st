Class {
	#name : #VMAllocationInNewSpaceTests,
	#superclass : #VMMemoryAllocationTests,
	#category : #'VMMakerTestsOrganized-subcategory'
}

{ #category : #'tests-VMSpurObjectAllocation' }
VMAllocationInNewSpaceTests >> testAllocateObjectInNewSpaceMovesFreeStart [

	| oldFreeStart |
	oldFreeStart := memory freeStart.
	memory allocateSlots: 0 format: memory arrayFormat classIndex: memory arrayClassIndexPun.
	
	self assert: memory freeStart > oldFreeStart
]

{ #category : #'tests-VMSpurNewSpaceStructure' }
VMAllocationInNewSpaceTests >> testInstantiateNewObjectMovesFreeStartAfterObject [
	
	| freeStartBefore |
	freeStartBefore := memory freeStart.
	self newZeroSizedEdenObject.
	
	"New zero sized object has 64bit header + 1 * 64bit empty slot = 16bytes"
	self assert: memory freeStart equals: freeStartBefore + emptyObjectSize
]

{ #category : #'tests-VMSpurNewSpaceStructure' }
VMAllocationInNewSpaceTests >> testInstantiateNewObjectWithSlotMovesFreeStartAfterObject [
	
	| freeStartBefore |
	freeStartBefore := memory freeStart.
	self newObjectWithSlots: 0.
	
	"New zero sized object has 64bit header + 1 * 64bit empty slot = 16bytes"
	self assert: memory freeStart equals: freeStartBefore + emptyObjectSize
]

{ #category : #'tests-VMSpurNewSpaceStructure' }
VMAllocationInNewSpaceTests >> testNewObjectAfterEdenLimitThrowsError [

	"Allocate enough objects to fill the eden."
	self saturateEden.
		
	"Allocating one more object should not be allowed, and should throw an error"
	[ self newZeroSizedEdenObject.
		
		"Fail the test if it does not raise an exception"
		self fail ] on: Error do: [ :error | 
			self assert: error messageText equals: 'no room in eden for allocateNewSpaceSlots:format:classIndex:' ]
]

{ #category : #'tests-VMSpurNewSpaceStructure' }
VMAllocationInNewSpaceTests >> testNewObjectInEdenDoesNotModifyFutureSpace [
	
	| futureSpaceStartBefore |
	futureSpaceStartBefore := memory scavenger futureSurvivorStart.
	self newZeroSizedEdenObject.
	
	self assert: memory scavenger futureSurvivorStart equals: futureSpaceStartBefore
]

{ #category : #'tests-VMSpurNewSpaceStructure' }
VMAllocationInNewSpaceTests >> testNewObjectInEdenDoesNotModifyPastSpace [
	
	| pastSpaceStartBefore |
	pastSpaceStartBefore := memory pastSpaceStart.
	self newZeroSizedEdenObject.
	
	self assert: memory pastSpaceStart equals: pastSpaceStartBefore
]

{ #category : #'tests-VMSpurNewSpaceStructure' }
VMAllocationInNewSpaceTests >> testNewObjectPositionIsBeforeObjectHeader [
	
	| freeStartBefore oop |
	freeStartBefore := memory freeStart.
	
	oop := self newZeroSizedEdenObject.
	
	self assert: oop equals: freeStartBefore
]

{ #category : #'tests-VMSpurNewSpaceStructure' }
VMAllocationInNewSpaceTests >> testNewObjectWithSlotsPositionIsBeforeObjectHeader [
	
	| freeStartBefore oop |
	freeStartBefore := memory freeStart.
	
	oop := self newObjectWithSlots: 0.
	
	self assert: oop equals: freeStartBefore
]

{ #category : #'tests-VMSpurNewSpaceStructure' }
VMAllocationInNewSpaceTests >> testScavengeThresholdIsInsideTheEden [

	self assert:(memory scavengeThreshold
						between: memory scavenger eden start
						and: memory scavenger eden limit)
]
