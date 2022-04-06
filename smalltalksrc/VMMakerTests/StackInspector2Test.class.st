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
	self newOldSpaceObjectWithSlots: 1.
	
	stackInspector updateInspector.
	numberOfBoxesAfter := stackInspector oldSpaceNodes size.
	
	"We also have the freelist from set upm that survived and is not tenured"
	oldOopBox := stackInspector oldSpaceNodes last.
	self assert: oldOopBox paint equals: stackInspector colorProvider defaultSpecialObjectsColor.

	
]

{ #category : #running }
StackInspector2Test >> testAllocatingOneObjectInNewSpaceShowsOneObjectInNewSpace [
	| oop |
	oop := self newZeroSizedObject.
	stackInspector updateInspector.
	
	"We also have the freelist from set up."
	self assert: stackInspector newSpaceNodes size equals: 2.
	self assert: stackInspector newSpaceNodes second model equals: oop.

]

{ #category : #running }
StackInspector2Test >> testAllocatingTenObjectsInNewSpaceShowsOneObjectInNewSpace [
	
	10 timesRepeat: [self newZeroSizedObject].
	stackInspector updateInspector.
	
	"We also have the freelist from set up."
	self assert: stackInspector newSpaceNodes size equals: 11.
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
StackInspector2Test >> testRunningGCKeepOnlyFreeList [
	
	| aliveOopBox |
	self newZeroSizedObject.
	
	memory doScavenge: 1. "Tenure by age"
	stackInspector updateInspector.
	
	"We also have the freelist from set upm that survived and is not tenured"
	self assert: stackInspector newSpaceNodes size equals: 1.
	aliveOopBox := stackInspector newSpaceNodes anyOne.
	self assert: aliveOopBox paint equals: stackInspector colorProvider defaultSpecialObjectsColor.

]

{ #category : #running }
StackInspector2Test >> testRunningGCKeepsAliveObjects [
	
	| aliveOopBox obj forwarder |
	<expectedFailure>
	"We would like to be able to display forwarders, however this requires modifications of the space enumeration"
	
	"Create a forwarder"
	self setUpScheduler.
	obj := self newZeroSizedObject.
	self keepObjectInVMVariable2: obj.
	memory pinObject: obj.
	
	forwarder := obj. 
	
	stackInspector updateInspector.
	
	"We also have the freelist from set upm that survived and is not tenured"
	self assert: stackInspector newSpaceNodes size equals: 2.

]
