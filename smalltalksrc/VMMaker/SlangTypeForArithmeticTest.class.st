Class {
	#name : #SlangTypeForArithmeticTest,
	#superclass : #SlangAbstractTestCase,
	#instVars : [
		'visitor',
		'propertyName'
	],
	#category : #'VMMaker-Tests'
}

{ #category : #tests }
SlangTypeForArithmeticTest >> testAtOnMatrix [
	| tMethod |
	self halt.
	tMethod := ccg methodNamed: #aMethodReturningAnAtOnAMatrix.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #'int *'."at: node"
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'int *'."returnNode"
	self assert: tMethod returnType equals: #'int *'.
]
