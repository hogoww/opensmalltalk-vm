Class {
	#name : #VMScavengeEphemeronTests,
	#superclass : #VMScavengerTests,
	#instVars : [
		'ourEphemeronClass'
	],
	#category : #'VMMakerTestsOrganized-tests'
}

{ #category : #helpers }
VMScavengeEphemeronTests >> createEphemeronClass [
	ourEphemeronClass := self newObjectWithSlots: 3.
	memory
		storePointer: "InstanceSpecificationIndex" 2
		ofObject: ourEphemeronClass
		withValue: (memory integerObjectOf: 327683 "Ephemeron format").
	memory ensureBehaviorHash: ourEphemeronClass.
]

{ #category : #helpers }
VMScavengeEphemeronTests >> newEphemeronObject [

"In pharo Ephemerons have 3 slots"
	
	^ self
		newObjectWithSlots: 3
		format: memory ephemeronFormat
		classIndex: (memory ensureBehaviorHash: ourEphemeronClass)
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testDequeueMournerWithOnlyOneEphemeronShouldEmptyMournQueue [
	| ephemeronObjectOop nonEphemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	memory dequeueMourner.
	self assert: memory dequeueMourner equals: nil
	
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testNewEphemeronObjectShouldBeInstanceOfEphemeronClass [

	| ephemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.

	self assert: (memory fetchClassOfNonImm: ephemeronObjectOop) equals: ourEphemeronClass
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeEphemeronInRememberdSetBecomesNormalObjectAfterFinalizationIsFired [
	| ephemeronObjectOop nonEphemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	"Move ephemeron to old space"
	memory tenuringIncrementalGC.
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	
	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.
	
	memory doScavenge: 1.	"TenureByAge"
	self
		assert: (memory formatOf: ephemeronObjectOop)
		equals: memory nonIndexablePointerFormat
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeEphemeronInRememberedSetReferencingDyingObjectShouldBeAddedInTheMournQueue [
	| ephemeronObjectOop nonEphemeronObjectOop  |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	"Move ephemeron to old space"
	memory tenuringIncrementalGC.
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.

	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	self
		assert: memory dequeueMourner
		equals: ephemeronObjectOop
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeEphemeronInRememberedSetReferencingDyingObjectShouldFireFinalization [
	| ephemeronObjectOop nonEphemeronObjectOop  oldFinalization |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	"Move ephemeron to old space"
	memory tenuringIncrementalGC.
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.

	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	oldFinalization := memory coInterpreter pendingFinalizationSignals.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	self
		assert: memory coInterpreter pendingFinalizationSignals
		equals: oldFinalization + 1
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeEphemeronInRememberedSetReferencingDyingObjectShouldScavengeEphemeronKey [
	| ephemeronObjectOop nonEphemeronObjectOop  nonEphemeronObjectHash |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	"Move ephemeron to old space"
	memory tenuringIncrementalGC.
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.

	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	nonEphemeronObjectHash := memory hashBitsOf: nonEphemeronObjectOop.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	self
		assert: (memory hashBitsOf: nonEphemeronObjectOop)
		equals: nonEphemeronObjectHash
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeEphemeronInRememberedSetReferencingSurvivorShouldLeaveEphemeronObjectAsIs [
	| ephemeronObjectOop nonEphemeronObjectOop nonEphemeronObjectHash |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	"Move ephemeron to old space"
	memory tenuringIncrementalGC.
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.

	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	nonEphemeronObjectHash := memory hashBitsOf: nonEphemeronObjectOop.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	self keepObjectInVMVariable2: nonEphemeronObjectOop.
	
	memory doScavenge: 1.	"TenureByAge"
	self
		assert: (memory hashBitsOf: (memory fetchPointer: 0 ofObject: ephemeronObjectOop))
		equals: nonEphemeronObjectHash
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeEphemeronObjectBecomesNormalObjectAfterFinalizationIsFired [
	| ephemeronObjectOop nonEphemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	
	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	self
		assert:
			(memory
				formatOf: ephemeronObjectOop)
		equals: memory nonIndexablePointerFormat
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeEphemeronObjectReferencingDyingObjectShouldBeAddedInTheMournQueue [
	| ephemeronObjectOop nonEphemeronObjectOop  |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	self
		assert: memory dequeueMourner
		equals: ephemeronObjectOop
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeEphemeronObjectReferencingDyingObjectShouldFireFinalization [
	| ephemeronObjectOop nonEphemeronObjectOop  oldFinalization |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	oldFinalization := memory coInterpreter pendingFinalizationSignals.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	self
		assert: memory coInterpreter pendingFinalizationSignals
		equals: oldFinalization + 1
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeEphemeronObjectReferencingDyingObjectShouldScavengeEphemeronKey [
	| ephemeronObjectOop nonEphemeronObjectOop  nonEphemeronObjectHash |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	nonEphemeronObjectHash := memory hashBitsOf: nonEphemeronObjectOop.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	nonEphemeronObjectOop := memory remapObj: nonEphemeronObjectOop.
	self
		assert: (memory hashBitsOf: nonEphemeronObjectOop)
		equals: nonEphemeronObjectHash
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeEphemeronObjectReferencingSurvivorShouldLeaveEphemeronObjectAsIs [
	| ephemeronObjectOop nonEphemeronObjectOop nonEphemeronObjectHash |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	nonEphemeronObjectHash := memory hashBitsOf: nonEphemeronObjectOop.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	self keepObjectInVMVariable2: nonEphemeronObjectOop.
	
	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	self
		assert:
			(memory
				hashBitsOf: (memory fetchPointer: 0 ofObject: ephemeronObjectOop))
		equals: nonEphemeronObjectHash
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeTwoEphemeronObjectsReferencingDifferentDyingObjectsShouldBeAddedInTheMournQueueAfterScavengingInEden [
	| ephemeronObjectOop nonEphemeronObjectOop  anotherEphemeronObjectOop anotherNonEphemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	anotherEphemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	anotherNonEphemeronObjectOop := self newZeroSizedEdenObject.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.
		
	memory
		storePointer: 0
		ofObject: anotherEphemeronObjectOop
		withValue: anotherNonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	self keepObjectInVMVariable2: anotherEphemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	anotherEphemeronObjectOop := memory remapObj: anotherEphemeronObjectOop.
	self
		assert: memory dequeueMourner
		equals: ephemeronObjectOop.

	self
		assert: memory dequeueMourner
		equals: anotherEphemeronObjectOop.
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeTwoEphemeronObjectsReferencingDifferentDyingObjectsShouldBeAddedInTheMournQueueAfterScavengingInPastSpace [
	| ephemeronObjectOop nonEphemeronObjectOop  anotherEphemeronObjectOop anotherNonEphemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	anotherEphemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.
	anotherNonEphemeronObjectOop := self newZeroSizedEdenObject.
	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.
		
	memory
		storePointer: 0
		ofObject: anotherEphemeronObjectOop
		withValue: anotherNonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	self keepObjectInVMVariable2: anotherEphemeronObjectOop.
	self keepObjectInVMVariable3: anotherNonEphemeronObjectOop.

	"Scavence once so all three objects are moved from eden to past space"
	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	anotherEphemeronObjectOop := memory remapObj: anotherEphemeronObjectOop.
	anotherNonEphemeronObjectOop := memory remapObj: anotherNonEphemeronObjectOop.
	
	self forgetObject3.
	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	anotherEphemeronObjectOop := memory remapObj: anotherEphemeronObjectOop.

	self
		assert: memory dequeueMourner
		equals: anotherEphemeronObjectOop.

	self
		assert: memory dequeueMourner
		equals: ephemeronObjectOop.
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeTwoEphemeronObjectsReferencingSameDyingObjectsShouldAddOnlyOneEphemeron [
	| ephemeronObjectOop nonEphemeronObjectOop  anotherEphemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	anotherEphemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.

	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.
		
	memory
		storePointer: 0
		ofObject: anotherEphemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	self keepObjectInVMVariable2: anotherEphemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	anotherEphemeronObjectOop := memory remapObj: anotherEphemeronObjectOop.

	"Consume the first mourner"
	memory dequeueMourner.
	self
		assert: memory dequeueMourner
		equals: nil
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeTwoEphemeronObjectsReferencingSameDyingObjectsShouldAddOnlySecond [
	| ephemeronObjectOop nonEphemeronObjectOop  anotherEphemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	anotherEphemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.

	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.
		
	memory
		storePointer: 0
		ofObject: anotherEphemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	self keepObjectInVMVariable2: anotherEphemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	anotherEphemeronObjectOop := memory remapObj: anotherEphemeronObjectOop.

	self
		assert: memory dequeueMourner
		equals: anotherEphemeronObjectOop.
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeTwoEphemeronObjectsReferencingSameDyingObjectsShouldBeQueuedAfterConsumingMournQueue [
	| ephemeronObjectOop nonEphemeronObjectOop  anotherEphemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	anotherEphemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.

	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.
		
	memory
		storePointer: 0
		ofObject: anotherEphemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	self keepObjectInVMVariable2: anotherEphemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.

	"The second ephemeron changed format, now it keeps the key strongly.
	Nil the ephemeron key to allow the next ephemeron to be finalized too"
	memory storePointer: 0 ofObject: memory dequeueMourner withValue: memory nilObject.
	
	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.

	self
		assert: memory dequeueMourner
		equals: ephemeronObjectOop
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeTwoEphemeronObjectsReferencingSameDyingObjectsShouldLeaveFirstOneAsEphemeron [
	| ephemeronObjectOop nonEphemeronObjectOop  anotherEphemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	anotherEphemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.

	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.
		
	memory
		storePointer: 0
		ofObject: anotherEphemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	self keepObjectInVMVariable2: anotherEphemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	anotherEphemeronObjectOop := memory remapObj: anotherEphemeronObjectOop.

	self assert: (memory isEphemeron: ephemeronObjectOop)
]

{ #category : #'tests-ephemerons-globals' }
VMScavengeEphemeronTests >> testScavengeTwoEphemeronObjectsReferencingSameDyingObjectsShouldScavengeKeyOfSecond [
	| ephemeronObjectOop nonEphemeronObjectOop  anotherEphemeronObjectOop |
	self createEphemeronClass.
	ephemeronObjectOop := self newEphemeronObject.
	anotherEphemeronObjectOop := self newEphemeronObject.
	nonEphemeronObjectOop := self newZeroSizedEdenObject.

	memory
		storePointer: 0
		ofObject: ephemeronObjectOop
		withValue: nonEphemeronObjectOop.
		
	memory
		storePointer: 0
		ofObject: anotherEphemeronObjectOop
		withValue: nonEphemeronObjectOop.

	"Force object to not be collected by putting them in special variables"
	self keepObjectInVMVariable1: ephemeronObjectOop.
	self keepObjectInVMVariable2: anotherEphemeronObjectOop.

	memory doScavenge: 1.	"TenureByAge"
	ephemeronObjectOop := memory remapObj: ephemeronObjectOop.
	anotherEphemeronObjectOop := memory remapObj: anotherEphemeronObjectOop.

	self
		assert: (memory
			fetchPointer: 0
			ofObject: ephemeronObjectOop)
		equals: (memory remapObj: nonEphemeronObjectOop)
]
