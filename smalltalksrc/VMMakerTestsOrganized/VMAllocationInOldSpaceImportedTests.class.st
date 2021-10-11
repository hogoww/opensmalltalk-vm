Class {
	#name : #VMAllocationInOldSpaceImportedTests,
	#superclass : #VMAllocationInOldSpaceTests,
	#category : #'VMMakerTestsOrganized-tests'
}

{ #category : #'tests-VMSpurObjectAllocation' }
VMAllocationInOldSpaceImportedTests >> testAllocateObjectInOldSpaceMovesFreeStart [

	| oldFreeStart |
	oldFreeStart := memory freeStart.
	memory
		allocateSlots: (memory scavengeThreshold / memory wordSize) floor + (memory wordSize * 2)
		format: memory arrayFormat
		classIndex: memory arrayClassIndexPun.
	
	self assert: memory freeStart = oldFreeStart
]
