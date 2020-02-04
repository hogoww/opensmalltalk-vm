"
An ASTCTypeAnnotationAST2Test is a test class for testing the behavior of ASTCTypeAnnotationAST2
"
Class {
	#name : #TTypeAnnotatorVisitorTest,
	#superclass : #SlangAbstractTestCase,
	#instVars : [
		'propertyName',
		'visitor'
	],
	#category : #'VMMaker-Translation to C'
}

{ #category : #test }
TTypeAnnotatorVisitorTest >> inferMethodSelector: aSelector from: aClass [
	| aMethodAST |
	aMethodAST := (ccg methodNamed: aSelector) copy.

	self assert: aMethodAST isNotNil.
	aMethodAST acceptVisitor: visitor.
	
	^aMethodAST
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> setUp [
	super setUp.
	ccg addClass: TTypeAnnotatorVisitorTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	
	visitor := TTypeAnnotatorVisitor new 
		ccg: ccg;
		yourself.
	propertyName := ASTCTypeAnnotator property.
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitArgumentNode [
	| ast counter |
	counter := 0.
	ast := self inferMethodSelector: #aMethodWithAnArgument:  from: PINodeTypeVisitorTest usingBlock:[ PINodeTypeVisitorTest new aMethodWithAnArgument:  3 ].
	ast nodesDo: [ :aNode | 
		aNode isArgument
			ifTrue: [ 
				counter := counter + 1.
				self assert: (aNode hasProperty: propertyName).
			]. ].
	self assert: counter equals:2.
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitAssignmentNode [
	| counter ast |
	counter := 0.
	ast := self inferMethodSelector: #aMethodWithAnAssignement from: PINodeTypeVisitorTest.
	ast nodesDo: [ :aNode | 
		aNode isAssignment
			ifTrue: [ 
				counter := counter + 1.
				self assert: (aNode hasProperty: propertyName).
			]. ].
	self assert: counter equals:1.
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitGlobalNodeClassVariable [
	| ast counter |
	"failing because it's getting undefined Object as well as Smallinteger as a possible type. This is normal, because the class variable initialization isn't set in the call graph of the variable
	Maybe use typedSlots would be more explicit"
	counter := 0.
	ast := self
		inferMethodSelector: #aMethodWithAClassVariable
		from: PINodeTypeVisitorTest.
	ast
		nodesDo: [ :aNode | 
			(aNode isVariable and: [ aNode isGlobal ])
				ifTrue: [ counter := counter + 1.
					self assert: (aNode hasProperty: propertyName) ] ].
	self assert: counter equals: 1
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitGlobalNodeGlobal [
	| ast counter |
	counter := 0.
	ast := self inferMethodSelector: #aMethodWithAGlobalVariable from: PINodeTypeVisitorTest.
	ast nodesDo: [ :aNode | 
		(aNode isVariable and:[aNode isGlobal])
			ifTrue: [ 
				counter := counter + 1.
				self assert: (aNode hasProperty: propertyName).
			].].
	self assert: counter equals:1.
	
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitGlobalNodeSharedPoolVariable [
	| ast counter |
	<expectedFailure>
	self flag:#todo."waiting to have a better understanding"
	self assert:false.
	
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitInstanceVariableNode [
	| ast counter |
	counter := 0.
	ast := self
		inferMethodSelector: #aMethodWithAnInstanceVariable
		from: PINodeTypeVisitorTest.
	ast
		nodesDo: [ :aNode | 
			(aNode isVariable and: [ aNode isInstance ])
				ifTrue: [ counter := counter + 1.
					self assert: (aNode hasProperty: propertyName) ] ].
	self assert: counter equals: 1
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitLiteralNode [
	| ast counter |
	counter := 0.
	ast := self
		inferMethodSelector: #aMethodWithALiteralNode
		from: PINodeTypeVisitorTest.
	ast
		nodesDo: [ :aNode | 
			(aNode isLiteralNode and: [ aNode isValue ])
				ifTrue: [ counter := counter + 1.
					self assert: (aNode hasProperty: propertyName) ] ].
	self assert: counter equals: 1
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitMessageNode [
	| ast counter |
	counter := 0.
	ast := self inferMethodSelector: #aMethodThatReturnAMessageThatReturnsAnInt from: PINodeTypeVisitorTest.
	ast
		nodesDo: [ :aNode | 
			aNode isMessage
				ifTrue: [ counter := counter + 1.
					self assert: (aNode hasProperty: propertyName) ] ].
	self assert: counter equals: 1
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitMethodNode [
	| ast counter |
	counter := 0.
	ast := self inferMethodSelector: #aMethodThatReturnsALiteral from: PINodeTypeVisitorTest.
	ast
		nodesDo: [ :aNode | 
			aNode isMethod
				ifTrue: [ counter := counter + 1.
					self assert: (aNode hasProperty: propertyName) ] ].
	self assert: counter equals: 1
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitSelfNode [
	| ast counter |
	counter := 0.
	ast := self
		inferMethodSelector: #aMethodWithSelf
		from: PINodeTypeVisitorTest.
	ast
		nodesDo: [ :aNode | 
			aNode isSelf
				ifTrue: [ counter := counter + 1.
					self assert: (aNode hasProperty: propertyName) ] ].
	self assert: counter equals: 1
]

{ #category : #test }
TTypeAnnotatorVisitorTest >> testVisitTemporaryNode [
	| ast counter |
	counter := 0.
	ast := self
		inferMethodSelector: #aMethodWithATemporaryVariable
		from: PINodeTypeVisitorTest.
	ast
		nodesDo: [ :aNode | 
			aNode isTemp
				ifTrue: [ counter := counter + 1.
					self assert: (aNode hasProperty: propertyName) ] ].
	self assert: counter equals: 2
]
