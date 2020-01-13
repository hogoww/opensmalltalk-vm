Class {
	#name : #VMCodeGenerationIlliciumTest,
	#superclass : #VMCodeGenerationTest,
	#instVars : [
		'translator'
	],
	#category : #'VMMakerCompatibilityForPharo6-Tests'
}

{ #category : #running }
VMCodeGenerationIlliciumTest >> setUp [
	translator := ASTCSlangTranslator new.
]

{ #category : #running }
VMCodeGenerationIlliciumTest >> testCommentsInBlocks [

	|  method result translatedMethod |
	method := VMCodeGenerationTestMethods lookupSelector: #methodWithCommentInBlock.
	translatedMethod := translator translateMethod: method.
	
	result := translatedMethod body prettyPrint.
	
	self assert: result equals: 'if (!(something())) {

	/* comment */
}'
]
