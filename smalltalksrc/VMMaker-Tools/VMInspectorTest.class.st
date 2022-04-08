Class {
	#name : #VMInspectorTest,
	#superclass : #VMInterpreterTests,
	#instVars : [
		'imageName',
		'image'
	],
	#pools : [
		'VMBasicConstants',
		'VMBytecodeConstants',
		'VMObjectIndices'
	],
	#category : #'VMMaker-Tools-Tests'
}

{ #category : #tests }
VMInspectorTest >> setSmallIntegerClassIntoClassTable [

	| class |
	class := self
		newClassInOldSpaceWithSlots: 0
		instSpec: memory forwardedFormat.
	image simulator setHashBitsOf: class to: memory smallIntegerTag.
	image simulator
		storePointer: memory smallIntegerTag
		ofObject: memory classTableFirstPage
		withValue: class.
	^class
	
]

{ #category : #running }
VMInspectorTest >> setUp [
	
	super setUp.
	image := SpurSimulatorImage onSpurSimulator: memory.
]

{ #category : #'test-testing' }
VMInspectorTest >> testClassOfObjectIsNilObjectByDefault [
	| objectOop object |
	objectOop := self newObjectWithSlots: 1.
	
	object := (image objectForOop: objectOop).
	self assert: object classSpurObject address equals: image simulator nilObject
]

{ #category : #tests }
VMInspectorTest >> testEqualsOtherObject [
	| object1 object2 |
	object1 := image objectForOop: (image simulator integerObjectOf: 42).
	object2 := image objectForOop: (image simulator integerObjectOf: 42).
	
	self assert: object1 equals: object2
]

{ #category : #'tests-graphObject' }
VMInspectorTest >> testGraphObjectOfEmptyObjectIsJustTheObject [
	| oop |
	oop := SpurObject on: self newZeroSizedObject image: image.
	self assert: oop objectGraph size equals: 1.
	self assert: oop objectGraph first anyOne equals: oop
]

{ #category : #'tests-graphObject' }
VMInspectorTest >> testGraphObjectOfOneSlotObjectHasBothTheInitialObjectAndItsSlot [
	| oop |
	oop := SpurObject on: (self newObjectWithSlots: 1) image: image.
	oop slotAt: 1 put: self newZeroSizedObject.
	self assert: oop objectGraph size equals: 2."depth = 2"
	self assert: oop objectGraph second size equals: 1.
	self assert: oop objectGraph second first equals: (oop slotAt: 1)
]

{ #category : #'tests-graphObject' }
VMInspectorTest >> testGraphObjectOfTwoSlotObjectHasBothTheInitialObjectAndItsSlots [
	| oop |
	oop := SpurObject on: (self newObjectWithSlots: 2) image: image.
	oop slotAt: 1 put: self newZeroSizedObject.
	oop slotAt: 2 put: self newZeroSizedObject.
	self assert: oop objectGraph size equals: 2."depth = 2"
	self assert: oop objectGraph second size equals: 2.
	self assert: oop objectGraph second second equals: (oop slotAt: 2)
]

{ #category : #'tests-graphObject' }
VMInspectorTest >> testGraphObjectOfTwoSlotsPointingToEachOtherDoesNotCreateAnExtraLevelOfDepth [
	| oop firstSlot secondSlot |
	oop := SpurObject on: (self newObjectWithSlots: 2) image: image.
	firstSlot := SpurObject on: (self newObjectWithSlots: 1) image: image.
	secondSlot := SpurObject on: (self newObjectWithSlots: 1) image: image.
	oop slotAt: 1 put: firstSlot.
	oop slotAt: 2 put: secondSlot.
	firstSlot slotAt: 1 put: secondSlot.
	secondSlot slotAt: 1 put: firstSlot. 
	self assert: oop objectGraph size equals: 2.
]

{ #category : #'tests-graphObject' }
VMInspectorTest >> testGraphObjectOfTwoSlotsWithOnePointingToTheOtherDoesNotCreateAnExtraLevelOfDepth [
	| oop firstSlot secondSlot |
	oop := SpurObject on: (self newObjectWithSlots: 2) image: image.
	firstSlot := SpurObject on: (self newObjectWithSlots: 1) image: image.
	secondSlot := SpurObject on: (self newObjectWithSlots: 0) image: image.
	oop slotAt: 1 put: firstSlot.
	oop slotAt: 2 put: secondSlot.
	firstSlot slotAt: 1 put: secondSlot.
	self assert: oop objectGraph size equals: 2.
]

{ #category : #'tests-graphObject' }
VMInspectorTest >> testGraphObjectWithObjectPointingToItselfDoesNotAddExtraLayer [
	| oop |
	oop := SpurObject on: (self newObjectWithSlots: 1) image: image.
	oop slotAt: 1 put: oop address value.
	self assert: oop objectGraph size equals: 1.
]

{ #category : #'tests-graphObject' }
VMInspectorTest >> testGraphObjectWithThreeLayerHasThreeDepthLevels [
	| oop firstLayer secondLayer |
	oop := SpurObject on: (self newObjectWithSlots: 1) image: image.
	firstLayer := SpurObject on: (self newObjectWithSlots: 1) image: image.
	secondLayer := SpurObject on: (self newZeroSizedObject) image: image.
	oop slotAt: 1 put: firstLayer.
	firstLayer slotAt: 1 put: secondLayer.
	self assert: oop objectGraph size equals: 3."depth = 3"
	self assert: oop objectGraph third first equals: secondLayer
]

{ #category : #'test-testing' }
VMInspectorTest >> testImmutability [
	| object objectOop |
	objectOop := (self newObjectWithSlots: 1).
	object := image objectForOop: objectOop.
	image simulator setIsImmutableOf: objectOop to: true.
	
	self assert: object isImmutable
]

{ #category : #'test-testing' }
VMInspectorTest >> testImmutabilityISFalseByDefault [
	| object |
	object := image objectForOop: (self newObjectWithSlots: 1).
	
	self assert: object isImmutable not
]

{ #category : #tests }
VMInspectorTest >> testInspectOopInspectRightObject [
	| objectOop window |
	objectOop := self newObjectWithSlots: 1.
	window := image inspectOop: objectOop.
	[self assert: window title equals: 'Inspector on ', objectOop printString]
	ensure: [ window close ]
]

{ #category : #tests }
VMInspectorTest >> testIntegerKnowsItsClass [
	| class object |
	class := self setSmallIntegerClassIntoClassTable.
	object := SpurObject on: (image simulator integerObjectOf: 42) image: image.
	self assert: class equals: object classOop
]

{ #category : #'test-testing' }
VMInspectorTest >> testIsForwarder [
	| oop obj |
	
	obj := self newZeroSizedObject.
	oop := SpurObject on: obj image: image.
	self deny: oop isForwarder.
	
	memory pinObject: obj.
	self assert: oop isForwarder.
]

{ #category : #'test-testing' }
VMInspectorTest >> testIsImmediateObject [
	| object |
	object := image objectForOop: (image simulator integerObjectOf: 42).
	
	self assert: object isImmediate
]

{ #category : #'test-testing' }
VMInspectorTest >> testIsNotImmediateObject [
	| object |
	object := image objectForOop: (self newObjectWithSlots: 1).
	
	self assert: object isImmediate not
]

{ #category : #'test-testing' }
VMInspectorTest >> testIsOld [
	| oop |
	oop := SpurObject on: (self newOldSpaceObjectWithSlots: 1) image: image.

	self assert: oop isOld.
]

{ #category : #'test-testing' }
VMInspectorTest >> testIsPinnedOop [
	| oop obj |
	
	obj := self newZeroSizedObject.
	memory pinObject: obj.
	
	oop := SpurObject on: (memory followForwarded: obj) image: image.
	
	self assert: oop isPinnedOop.
]

{ #category : #'test-testing' }
VMInspectorTest >> testIsYoung [
	| oop |
	oop := SpurObject on: (self newObjectWithSlots: 1) image: image.

	self assert: oop isYoung.
]

{ #category : #tests }
VMInspectorTest >> testNilHasNoInstanceVariable [

	self assert: image nilObject instanceVariables isEmpty.
]

{ #category : #tests }
VMInspectorTest >> testNotEqualsNil [
	| object1 object2 |
	object1 := image objectForOop: (image simulator integerObjectOf: 42).
	object2 := image objectForOop: (image simulator nilObject).
	
	self deny: object1 equals: object2
]

{ #category : #tests }
VMInspectorTest >> testObjectEqualOop [
	| object1 object2 |
	object1 := image objectForOop: (image simulator integerObjectOf: 42).
	object2 := image simulator integerObjectOf: 42.
	
	self assert: object1 equals: object2
]

{ #category : #tests }
VMInspectorTest >> testObjectWithInstanceVariableCycleWeCanNavigate [

	| objectOop1 object1 objectOop2 object2 |
	objectOop1 := self newObjectWithSlots: 1.
	objectOop2 := self newObjectWithSlots: 1.
	
	object1 := (image objectForOop: objectOop1).
	object2 := (image objectForOop: objectOop2).
	
	object1 slotAt: 1 put: object2.
	object2 slotAt: 1 put: object1.

	self assert: (object1 slotAt: 1) address equals: object2.
	self assert: (object2 slotAt: 1) address equals: object1.
]

{ #category : #tests }
VMInspectorTest >> testObjectWithInstanceVariableHasInstanceVariable [

	| objectOop |
	objectOop := self newObjectWithSlots: 2.
	self assert: (image objectForOop: objectOop) instanceVariables isNotEmpty.
]

{ #category : #'tests-printing' }
VMInspectorTest >> testObjectWithNilClass [
	| oop object |
	oop := self newObjectWithSlots: 1.
	object := SpurObject on: oop image: image.

	self assert: object printString equals: oop printString
]

{ #category : #tests }
VMInspectorTest >> testPinObjectKeepsTheObjectAndNotTheForwarder [
	| oop |
	oop := SpurObject on: self newZeroSizedObject image: image.
	
	oop pinObject.
	self deny: oop isForwarder.
	self assert: oop isPinnedOop
]

{ #category : #'tests-printing' }
VMInspectorTest >> testPrintFalse [

	self assert: 'falseObject' equals: image falseObject printString
]

{ #category : #'tests-printing' }
VMInspectorTest >> testPrintNil [

	self assert: 'nilObject' equals: image nilObject printString
]

{ #category : #'tests-printing' }
VMInspectorTest >> testPrintTrue [

	self assert: 'trueObject' equals: image trueObject printString
]

{ #category : #tests }
VMInspectorTest >> testSlotAtPut [

	| objectOop1 object1 objectOop2 object2 |
	objectOop1 := self newObjectWithSlots: 1.
	objectOop2 := self newObjectWithSlots: 1.
	
	object1 := (image objectForOop: objectOop1).
	object2 := (image objectForOop: objectOop2).
	
	object1 slotAt: 1 put: object2.
	object2 slotAt: 1 put: object1.

	self assert: (object1 slotAt: 1) address equals: object2.
]
