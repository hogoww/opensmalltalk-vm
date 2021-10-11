Class {
	#name : #VMScavengeWeakTests,
	#superclass : #VMScavengerTests,
	#instVars : [
		'ourWeakClass'
	],
	#category : #'VMMakerTestsOrganized-tests'
}

{ #category : #tests }
VMScavengeWeakTests >> createWeakArrayClass [
	ourWeakClass := self newObjectWithSlots: 3.
	memory
		storePointer: "InstanceSpecificationIndex" 2
		ofObject: ourWeakClass
		withValue: (memory integerObjectOf: 262144 "WeakArray format" ).
	memory ensureBehaviorHash: ourWeakClass.
	
]

{ #category : #tests }
VMScavengeWeakTests >> newWeakObjectOfSize: aSize [
	
	^ self
		newObjectWithSlots: aSize
		format: memory weakArrayFormat
		classIndex: (memory ensureBehaviorHash: ourWeakClass)
]

{ #category : #'test-format' }
VMScavengeWeakTests >> testNewWeakObjectShouldBeInstanceOfWeakClass [

	| weakObjectOop |
	self createWeakArrayClass.
	weakObjectOop := self newWeakObjectOfSize: 1.

	self assert: (memory fetchClassOfNonImm: weakObjectOop) equals: ourWeakClass
]

{ #category : #'test-format' }
VMScavengeWeakTests >> testNewWeakObjectShouldHaveClassIndexOfItsClass [

	| weakObjectOop classIndex |
	self createWeakArrayClass.
	weakObjectOop := self newWeakObjectOfSize: 1.

	classIndex := memory classIndexOf: weakObjectOop.
	
	self assert: classIndex equals: (memory ensureBehaviorHash: ourWeakClass)
]

{ #category : #tests }
VMScavengeWeakTests >> testScavengeOldWeakObjectReferencingNewSurvivorShouldNotFireFinalization [

	| weakObjectOop nonWeakObjectOop nonWeakObjectHash |
	self createWeakArrayClass.
	weakObjectOop := self newWeakObjectOfSize: 1.

	"Force object to not be collected by putting them in special variables"
	memory coInterpreter newMethod: weakObjectOop.
	
	memory tenuringIncrementalGC.
	weakObjectOop := memory remapObj: weakObjectOop.
	ourWeakClass := (memory remapObj: ourWeakClass).
	nonWeakObjectOop := self newZeroSizedEdenObject.
	nonWeakObjectHash := memory hashBitsOf: nonWeakObjectOop.
	memory storePointer: 0 ofObject: weakObjectOop withValue: nonWeakObjectOop.
	
	"Force object to not be collected by putting them in special variables"
	memory coInterpreter profileSemaphore: nonWeakObjectOop.

	memory doScavenge: 1 "TenureByAge".	
	
	self
		assert: memory coInterpreter pendingFinalizationSignals
		equals: 0
]

{ #category : #tests }
VMScavengeWeakTests >> testScavengeOldWeakObjectReferencingNonSurvivorShouldBeNilled [

	| weakObjectOop nonWeakObjectOop nonWeakObjectHash nilHash |
	self createWeakArrayClass.
	weakObjectOop := self newWeakObjectOfSize: 1.

	"Force object to not be collected by putting them in special variables"
	memory coInterpreter newMethod: weakObjectOop.
	memory tenuringIncrementalGC.
	weakObjectOop := memory remapObj: weakObjectOop.

	nonWeakObjectOop := self newZeroSizedEdenObject.
	nonWeakObjectHash := memory hashBitsOf: nonWeakObjectOop.
	memory storePointer: 0 ofObject: weakObjectOop withValue: nonWeakObjectOop.
	
	nilHash := memory hashBitsOf: memory nilObject.
	memory doScavenge: 1 "TenureByAge".	
	
	self
		assert: (memory hashBitsOf: (memory fetchPointer: 0 ofObject: weakObjectOop))
		equals: nilHash
]

{ #category : #tests }
VMScavengeWeakTests >> testScavengeOldWeakObjectReferencingNonSurvivorShouldFireFinalization [

	| weakObjectOop nonWeakObjectOop nonWeakObjectHash |
	self createWeakArrayClass.
	weakObjectOop := self newWeakObjectOfSize: 1.

	"Force object to not be collected by putting them in special variables"
	memory coInterpreter newMethod: weakObjectOop.
	
	memory tenuringIncrementalGC.
	weakObjectOop := memory remapObj: weakObjectOop.
	ourWeakClass := (memory remapObj: ourWeakClass).

	nonWeakObjectOop := self newZeroSizedEdenObject.
	nonWeakObjectHash := memory hashBitsOf: nonWeakObjectOop.
	memory storePointer: 0 ofObject: weakObjectOop withValue: nonWeakObjectOop.
	
	memory doScavenge: 1 "TenureByAge".	
	
	self
		assert: memory coInterpreter pendingFinalizationSignals
		equals: 1
]

{ #category : #tests }
VMScavengeWeakTests >> testScavengeWeakObjectReferencingNonSurvivorShouldBeNilled [

	| weakObjectOop nonWeakObjectOop nilHash |
	self createWeakArrayClass.
	weakObjectOop := self newWeakObjectOfSize: 1.
	nonWeakObjectOop := self newZeroSizedEdenObject.
	memory storePointer: 0 ofObject: weakObjectOop withValue: nonWeakObjectOop.
	
	"Force object to not be collected by putting them in special variables"
	memory coInterpreter newMethod: weakObjectOop.
	nilHash := memory hashBitsOf: memory nilObject.
	memory doScavenge: 1 "TenureByAge".
	weakObjectOop := memory remapObj: weakObjectOop.	
	
	self
		assert: (memory hashBitsOf: (memory fetchPointer: 0 ofObject: weakObjectOop))
		equals: nilHash
]

{ #category : #tests }
VMScavengeWeakTests >> testScavengeWeakObjectReferencingNonSurvivorShouldFireFinalisation [

	| weakObjectOop nonWeakObjectOop |
	self createWeakArrayClass.
	weakObjectOop := self newWeakObjectOfSize: 1.
	nonWeakObjectOop := self newZeroSizedEdenObject.
	memory storePointer: 0 ofObject: weakObjectOop withValue: nonWeakObjectOop.
	
	"Force object to not be collected by putting them in special variables"
	memory coInterpreter newMethod: weakObjectOop.
	memory doScavenge: 1 "TenureByAge".
		
	self
		assert: memory coInterpreter pendingFinalizationSignals
		equals: 1
]

{ #category : #tests }
VMScavengeWeakTests >> testScavengeWeakObjectReferencingSurvivorShouldLeaveWeakObjectAsIs [

	| weakObjectOop nonWeakObjectOop nonWeakObjectHash |
	self createWeakArrayClass.
	weakObjectOop := self newWeakObjectOfSize: 1.
	nonWeakObjectOop := self newZeroSizedEdenObject.
	nonWeakObjectHash := memory hashBitsOf: nonWeakObjectOop.
	memory storePointer: 0 ofObject: weakObjectOop withValue: nonWeakObjectOop.
	
	"Force object to not be collected by putting them in special variables"
	memory coInterpreter newMethod: weakObjectOop.
	memory coInterpreter profileSemaphore: nonWeakObjectOop.

	memory doScavenge: 1 "TenureByAge".
	weakObjectOop := memory remapObj: weakObjectOop.	
	
	self
		assert: (memory hashBitsOf: (memory fetchPointer: 0 ofObject: weakObjectOop))
		equals: nonWeakObjectHash
]

{ #category : #tests }
VMScavengeWeakTests >> testScavengeWeakObjectReferencingSurvivorShouldNotFireFinalization [

	| weakObjectOop nonWeakObjectOop nonWeakObjectHash |
	self createWeakArrayClass.
	weakObjectOop := self newWeakObjectOfSize: 1.
	nonWeakObjectOop := self newZeroSizedEdenObject.
	nonWeakObjectHash := memory hashBitsOf: nonWeakObjectOop.
	memory storePointer: 0 ofObject: weakObjectOop withValue: nonWeakObjectOop.
	
	"Force object to not be collected by putting them in special variables"
	memory coInterpreter newMethod: weakObjectOop.
	memory coInterpreter profileSemaphore: nonWeakObjectOop.

	memory doScavenge: 1 "TenureByAge".
	weakObjectOop := memory remapObj: weakObjectOop.	
	
	self
		assert: memory coInterpreter pendingFinalizationSignals
		equals: 0
]
