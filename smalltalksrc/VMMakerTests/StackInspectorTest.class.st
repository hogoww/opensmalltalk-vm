Class {
	#name : #StackInspectorTest,
	#superclass : #StackBuilderTest,
	#instVars : [
		'stackInspector'
	],
	#category : #'VMMakerTests-InterpreterTests'
}

{ #category : #running }
StackInspectorTest >> setUp [
	super setUp.
	stackInspector := StackInspector openOn: interpreter.
]

{ #category : #running }
StackInspectorTest >> tearDown [
	stackInspector owner close.
	super tearDown.
]

{ #category : #running }
StackInspectorTest >> testSelectingFirstMethodColorsOneBox [
	"as long as the stack and temps are failing, this one will fail as well"
	stackInspector stack selectIndex: 2.
	self assert: stackInspector coloredModels size equals: 1
]

{ #category : #running }
StackInspectorTest >> testSelectingFirstMethodThenFirstContextColorsOnlyOneBox [
	"as long as the stack and temps are failing, this one will fail as well"
	stackInspector stack selectIndex: 2.
	self assert: stackInspector coloredModels size equals: 1
]

{ #category : #running }
StackInspectorTest >> testStackInspectorFramesSize [
	self assert: interpreter stack anyOne frameSize equals: 9.
]

{ #category : #running }
StackInspectorTest >> testStackInspectorHasThreesFrames [
	<expectedFailures> 
	"as long as the stack and temps are failing, this one will fail as well"
	self assert: stackInspector stack items size equals: 3 * 9
]
