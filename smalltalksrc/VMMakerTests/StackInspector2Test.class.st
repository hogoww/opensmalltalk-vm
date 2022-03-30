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
StackInspector2Test >> testAllocatingOneObjectInNewSpaceShowsOneObjectInNewSpace [
	| oop |
	oop := self newZeroSizedObject.
	self assert: stackInspector newSpaceNodes size equals: 1.
	self assert: stackInspector newSpaceNodes anyOne equals: oop
]
