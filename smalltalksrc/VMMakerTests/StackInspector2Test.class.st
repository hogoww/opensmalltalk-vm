Class {
	#name : #StackInspector2Test,
	#superclass : #VMInterpreterTests,
	#instVars : [
		'stackInspector'
	],
	#category : #'VMMakerTests-InterpreterTests'
}

{ #category : #running }
StackInspector2Test >> setUp [
	super setUp.

	stackInspector := StackInspector openOn: interpreter.
]

{ #category : #running }
StackInspector2Test >> tearDown [
	stackInspector owner close.
	super tearDown.
]

{ #category : #running }
StackInspector2Test >> testAllocatingObjectInOldSpaceAddsABox [
	
	| numberOfBoxes numberOfBoxesAfter |
	numberOfBoxes := stackInspector oldSpaceNodes size.
	self newOldSpaceObjectWithSlots: 1.
	
	stackInspector updateInspector.
	numberOfBoxesAfter := stackInspector oldSpaceNodes size.
	
	self assert: numberOfBoxesAfter equals: numberOfBoxes + 1
]

{ #category : #running }
StackInspector2Test >> testAllocatingObjectInOldSpaceAddsABoxWithTheRightColor [
	
	| numberOfBoxes numberOfBoxesAfter oldOopBox |
	numberOfBoxes := stackInspector oldSpaceNodes size.
	self newOldSpaceObjectWithSlots: 1 classIndex: 90.
	
	stackInspector updateInspector.
	numberOfBoxesAfter := stackInspector oldSpaceNodes size.
	
	oldOopBox := stackInspector oldSpaceNodes last.
	self assert: oldOopBox paint equals: stackInspector colorProvider regularOopColor.
]

{ #category : #running }
StackInspector2Test >> testAllocatingOneObjectInNewSpaceShowsOneObjectInNewSpace [
	| oop |
	oop := self newZeroSizedObject.
	stackInspector updateInspector.
	
	self assert: stackInspector newSpaceNodes size equals: 1.
	self assert: stackInspector newSpaceNodes first model equals: oop.

]

{ #category : #running }
StackInspector2Test >> testAllocatingTenObjectsInNewSpaceShowsOneObjectInNewSpace [
	
	10 timesRepeat: [self newZeroSizedObject].
	stackInspector updateInspector.
	
	self assert: stackInspector newSpaceNodes size equals: 10.
]

{ #category : #running }
StackInspector2Test >> testForwarderIsColoredProperly [
	
	| obj |	
	"Create a forwarder"
	obj := self newZeroSizedObject.
	memory pinObject: obj.
	
	stackInspector updateInspector.
	
	self assert: stackInspector newSpaceNodes size equals: 1.
	self assert: stackInspector newSpaceNodes anyOne color equals: stackInspector colorProvider forwarderOopColor.
]

{ #category : #running }
StackInspector2Test >> testForwarderIsDisplayed [
	
	| obj |	
	"Create a forwarder"
	obj := self newZeroSizedObject.
	memory pinObject: obj.
	
	stackInspector updateInspector.
	
	self assert: stackInspector newSpaceNodes size equals: 1.
	self assert: (memory isUnambiguouslyForwarder: stackInspector newSpaceNodes anyOne model).
]

{ #category : #running }
StackInspector2Test >> testPinnedObjectHastheRightColor [
	
	| obj |	
	"Create a forwarder"
	obj := self newZeroSizedObject.
	memory pinObject: obj.
	
	stackInspector updateInspector.

	self assert: stackInspector oldSpaceNodes last color equals: stackInspector colorProvider pinnedOopColor.
]

{ #category : #running }
StackInspector2Test >> testPinnedObjectIsDisplayed [
	
	| obj |	
	"Create a forwarder"
	obj := self newZeroSizedObject.
	memory pinObject: obj.
	
	stackInspector updateInspector.
	
	self assert: stackInspector oldSpaceNodes last model equals: (memory followForwarded: obj).
]

{ #category : #running }
StackInspector2Test >> testRunningGCEmptiesNewSpace [
	self newZeroSizedObject.
	
	memory doScavenge: 1. "Tenure by age"
	stackInspector updateInspector.
	
	self assert: stackInspector newSpaceNodes size equals: 0.
]

{ #category : #running }
StackInspector2Test >> testSelectioningInitialNodeSelectAllThreeNodes [
	| oop firstLayer secondLayer image |
	image := SpurSimulatorImage onSpurSimulator: memory.
	oop := SpurObject on: (self newObjectWithSlots: 1) image: image.
	firstLayer := SpurObject on: (self newObjectWithSlots: 1) image: image.
	secondLayer := SpurObject on: (self newObjectWithSlots: 0) image: image.
	oop slotAt: 1 put: firstLayer.
	firstLayer slotAt: 1 put: secondLayer.
	
	stackInspector updateInspector.
	stackInspector newSpaceNodes first click.
	
	"We also have the freelist from set upm that survived and is not tenured"
	self assert: stackInspector newSpaceNodes first paint equals: stackInspector colorProvider initialSelectionColor.
	self assert: stackInspector newSpaceNodes second paint equals: stackInspector colorProvider initialSelectionColor lighter lighter lighter.
	self assert: stackInspector newSpaceNodes third paint equals: stackInspector colorProvider initialSelectionColor lighter lighter lighter lighter lighter lighter.
]

{ #category : #running }
StackInspector2Test >> testSelectioningNodeWithNoSlotsSelectOnlyItself [
	
	self newZeroSizedObject.
	
	stackInspector updateInspector.
	stackInspector newSpaceNodes anyOne click.
	
	"We also have the freelist from set upm that survived and is not tenured"
	self assert: stackInspector newSpaceNodes anyOne paint equals: stackInspector colorProvider initialSelectionColor.
]
