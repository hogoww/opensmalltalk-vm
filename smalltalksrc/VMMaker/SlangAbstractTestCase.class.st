Class {
	#name : #SlangAbstractTestCase,
	#superclass : #TestCase,
	#instVars : [
		'ccg'
	],
	#category : #'VMMaker-Tests'
}

{ #category : #running }
SlangAbstractTestCase >> setUp [
	super setUp.
	ccg := CCodeGenerator new.

]
