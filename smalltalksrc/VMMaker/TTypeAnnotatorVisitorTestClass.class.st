Class {
	#name : #TTypeAnnotatorVisitorTestClass,
	#superclass : #InterpreterPlugin,
	#instVars : [
		'propertyName',
		'visitor'
	],
	#category : #'VMMaker-Translation to C'
}

{ #category : #'as yet unclassified' }
TTypeAnnotatorVisitorTestClass >> aMethodReturningALiteral [
	^ 30
]

{ #category : #'as yet unclassified' }
TTypeAnnotatorVisitorTestClass >> aMethodThatReturnsALiteral [
	^ 30
]
