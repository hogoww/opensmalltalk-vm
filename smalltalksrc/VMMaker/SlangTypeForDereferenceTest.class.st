Class {
	#name : #SlangTypeForDereferenceTest,
	#superclass : #TestCase,
	#category : #'VMMaker-Tests'
}

{ #category : #tests }
SlangTypeForDereferenceTest >> testAtOnArray [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeForDereferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aMethodReturningAnAtOnAnArray.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #int."at: node"
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int."returnNode"
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false. "Unexpected type conversion"
]

{ #category : #tests }
SlangTypeForDereferenceTest >> testAtOnMatrix [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeForDereferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aMethodReturningAnAtOnAMatrix.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #'int *'."at: node"
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'int *'."returnNode"
	self assert: tMethod returnType equals: #'int *'.
]

{ #category : #tests }
SlangTypeForDereferenceTest >> testReturnPointerTypeExplicitTempVariable [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeForDereferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aMethodReturningAPointerType.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #'int *'."variable node"
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'int *'."return node"
	self assert: tMethod returnType equals: #'int *'
]

{ #category : #tests }
SlangTypeForDereferenceTest >> testSelfMessageReturningPointerType [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeForDereferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aMethodReturningAPointerType.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #'int *'."message node"
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'int *'."returnNode"
	self assert: tMethod returnType equals: #'int *'
]

{ #category : #tests }
SlangTypeForDereferenceTest >> testTwoAtOnMatrix [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeForDereferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aMethodReturningTwoAtOnAMatrix.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first expression receiver in: tMethod) equals: #'int *'."inner at:"
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #int."outer at:"
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int."return node"
	self assert: tMethod returnType equals: #sqInt.

	self assert: false. "Unexpected type conversion"
]
