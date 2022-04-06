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
	
	"We also have the freelist from set upm that survived and is not tenured"
	self assert: numberOfBoxesAfter equals: numberOfBoxes + 1.
]

{ #category : #running }
StackInspector2Test >> testAllocatingObjectInOldSpaceAddsABoxWithTheRightColor [
	
	| numberOfBoxes numberOfBoxesAfter oldOopBox |
	numberOfBoxes := stackInspector oldSpaceNodes size.
	self newOldSpaceObjectWithSlots: 1 classIndex: 90.
	
	stackInspector updateInspector.
	numberOfBoxesAfter := stackInspector oldSpaceNodes size.
	
	oldOopBox := stackInspector oldSpaceNodes last.
	self assert: oldOopBox paint equals: stackInspector colorProvider usedOopColor.
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
StackInspector2Test >> testInspectVMObject [
	| oop window |
	oop := self newZeroSizedObject.
	window := memory inspectOop: oop.
	self assert: window isOpen.
	window close
]

{ #category : #running }
StackInspector2Test >> testRunningGCEmptiesNewSpace [
	self newZeroSizedObject.
	
	memory doScavenge: 1. "Tenure by age"
	stackInspector updateInspector.
	
	self assert: stackInspector newSpaceNodes size equals: 0.
]

{ #category : #running }
StackInspector2Test >> testRunningGCKeepsAliveObjects [
	
	| obj |	
	"Create a forwarder"
	obj := self newZeroSizedObject.
	memory pinObject: obj.
	
	stackInspector updateInspector.
	
	self assert: stackInspector newSpaceNodes size equals: 1.
	self assert: (memory isUnambiguouslyForwarder: stackInspector newSpaceNodes anyOne model)

]
