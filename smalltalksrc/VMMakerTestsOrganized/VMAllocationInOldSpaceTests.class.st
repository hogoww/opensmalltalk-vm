Class {
	#name : #VMAllocationInOldSpaceTests,
	#superclass : #VMMemoryAllocationTests,
	#category : #'VMMakerTestsOrganized-subcategory'
}

{ #category : #'tests-VMSpurObjectAllocation' }
VMAllocationInOldSpaceTests >> testAllocateObjectInOldSpaceMovesFreeStart [

	| oldFreeStart |
	oldFreeStart := memory freeStart.
	memory
		allocateSlots: (memory scavengeThreshold / memory wordSize) floor + (memory wordSize * 2)
		format: memory arrayFormat
		classIndex: memory arrayClassIndexPun.
	
	self assert: memory freeStart = oldFreeStart
]
