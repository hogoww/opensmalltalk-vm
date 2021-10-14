Class {
	#name : #VMOldGCRegularObjectTests,
	#superclass : #VMOldGCTests,
	#category : #'VMMakerTestsOrganized-tests'
}

{ #category : #assertion }
VMOldGCRegularObjectTests >> assertHashOf: anOop equals: aHash [ 
	self assert: (memory hashBitsOf: anOop) equals: aHash
]

{ #category : #assertion }
VMOldGCRegularObjectTests >> assertObjectWereReclaimed: aBlock [ 
	| initialSpace firstObjectToBeRemembered sizeOfObject |
	"The planning compactor frees object by sliding, and therefore does not reclaim memory if there is only dead objects in the oldspace."
	
	"We allocate objects during the setup"
	memory fullGC. 
	
	initialSpace := memory totalFreeListBytes.
	
	aBlock value.
	
	firstObjectToBeRemembered := self newOldSpaceObjectWithSlots: 0.
	self keepObjectInVMVariable1: firstObjectToBeRemembered.
	sizeOfObject := memory bytesInObject: firstObjectToBeRemembered.
	
	memory fullGC.
	
	self assert: initialSpace - sizeOfObject equals: memory totalFreeListBytes
]

{ #category : #testing }
VMOldGCRegularObjectTests >> isValidFirstBridge [

	^ memory segmentManager
		isValidSegmentBridge: (memory segmentManager bridgeAt: 0)
]

{ #category : #'tests-OldSpaceSize' }
VMOldGCRegularObjectTests >> testAllocateObjectBiggerThanSizeOfFreeSpace [

	| anObjectOop slotsNumber |
	slotsNumber := memory totalFreeOldSpace / memory wordSize.
	
	anObjectOop := self newObjectWithSlots: slotsNumber.

	self assert: anObjectOop isNil
]

{ #category : #'tests-OldSpaceSize' }
VMOldGCRegularObjectTests >> testAllocateObjectBiggerThanSizeOfFreeSpaceShouldPlanifyGC [

	| anObjectOop slotsNumber |
	slotsNumber := memory totalFreeOldSpace / memory wordSize.
	
	anObjectOop := self newObjectWithSlots: slotsNumber.

	self assert: memory needGCFlag
]

{ #category : #'tests-OldSpaceSize' }
VMOldGCRegularObjectTests >> testAllocateObjectWithFreeSpaceSize [

	| anObjectOop slotsNumber |
	slotsNumber := memory totalFreeOldSpace / memory wordSize.
	
	anObjectOop := self newOldSpaceObjectWithSlots: slotsNumber - 2. "Big object have 2 wordSize of header"

	self assert: anObjectOop isNotNil
]

{ #category : #'tests-OldSpaceSize' }
VMOldGCRegularObjectTests >> testAllocateObjectWithFreeSpaceSizeShouldBeZero [

	| anObjectOop slotsNumber |
	slotsNumber := memory totalFreeOldSpace / memory wordSize.
	
	anObjectOop := self newObjectWithSlots: slotsNumber - 2. "Big object have 2 wordSize of header"
	
	self assert: memory totalFreeOldSpace equals: 0
]

{ #category : #'tests-OldSpaceSize' }
VMOldGCRegularObjectTests >> testAllocateObjectWithFreeSpaceSizeShouldPlanifyGC [

	| anObjectOop slotsNumber |
	slotsNumber := memory totalFreeOldSpace / memory wordSize.
	
	anObjectOop := self newObjectWithSlots: slotsNumber - 2. "Big object have 2 wordSize of header"
	
	self assert: memory needGCFlag
]

{ #category : #'tests-OldSpaceSize' }
VMOldGCRegularObjectTests >> testAllocateUnreferencedCycleShouldBeReclaimed [
	self assertObjectWereReclaimed: [
		| obj1 obj2 |
	
		obj1 := self newOldSpaceObjectWithSlots: 1.
		obj2 := self newOldSpaceObjectWithSlots: 1.
		memory storePointer: 0 ofObject: obj1 withValue: obj2.
		memory storePointer: 0 ofObject: obj2 withValue: obj1.
	]
]

{ #category : #tests }
VMOldGCRegularObjectTests >> testAnOldObjectNotReferencedShouldBeCollected [

	| oldFreeSpaceSize obj2 keptObjectSize |
	
	"The free objects are only reclaimed when there is a object after it. 
	For example if I have a free object and then only free space, the compactor assumes 
	that the heap is compacted, but it does not compact the free list. So the last free chunk is never 
	count on.
	This is a ""feature"" of the compactor. Changing the compactor strategy may change this behavior."
	
	memory fullGC.
	oldFreeSpaceSize := memory totalFreeListBytes.
	
	self newOldSpaceObjectWithSlots: 0.	
	obj2 := self newOldSpaceObjectWithSlots: 0.
	
	self keepObjectInVMVariable1: obj2.
	keptObjectSize := memory bytesInObject: obj2.
	
	memory fullGC.
	
	self assert: memory totalFreeListBytes equals: oldFreeSpaceSize - keptObjectSize.
]

{ #category : #tests }
VMOldGCRegularObjectTests >> testAnOldObjectReferencedFromVMVariableShouldBeKept [
	| anObjectOop |
	memory fullGC.
	
	anObjectOop := self newOldSpaceObjectWithSlots: 0.
	self keepObjectInVMVariable1: anObjectOop.
	
	memory fullGC.
	
	self deny: (memory isFreeObject: anObjectOop)
]

{ #category : #tests }
VMOldGCRegularObjectTests >> testAnOldObjectReferencedFromVMVariableShouldBeMoved [

	| anObjectOop hash |
	1000 timesRepeat: [ self newOldSpaceObjectWithSlots: 0 ].
	
	anObjectOop := self newOldSpaceObjectWithSlots: 0.

	self keepObjectInVMVariable1: anObjectOop.
	hash := memory hashBitsOf: anObjectOop.
		
	memory fullGC.
	"after this point anObjectOop cannot be used anymore as it has been moved by the compacting phase.
	We have to use the hash instead."
	
	self deny: anObjectOop equals: self keptObjectInVMVariable1.
	self assertHashOf: self keptObjectInVMVariable1 equals: hash
]
