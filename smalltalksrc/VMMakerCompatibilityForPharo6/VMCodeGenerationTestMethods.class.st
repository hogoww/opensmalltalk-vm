Class {
	#name : #VMCodeGenerationTestMethods,
	#superclass : #Object,
	#category : #'VMMakerCompatibilityForPharo6-Tests'
}

{ #category : #'generation-targets' }
VMCodeGenerationTestMethods >> methodWithCommentInBlock [

	self something ifNil: [ "comment" 1 ]
]

{ #category : #'generation-targets' }
VMCodeGenerationTestMethods >> methodWithIfNil [

	self something
		ifNil: [ 1 ]
		ifNotNil: [ 2 ]
]

{ #category : #'generation-targets' }
VMCodeGenerationTestMethods >> methodWithIfNilAssignment [

	| variable |
	variable := self something
		ifNil: [ 1 ]
		ifNotNil: [ 2 ]
]

{ #category : #'generation-targets' }
VMCodeGenerationTestMethods >> methodWithIfNilAssignmentOfComplexStatements [

	| variable |
	variable := self something
		ifNil: [ | temp |
			temp := 1.
			temp := temp + 1.
			temp * 3 ]
		ifNotNil: [ | temp |
			temp := 2.
			temp := temp + 5.
			temp * 3 ]
]

{ #category : #'generation-targets' }
VMCodeGenerationTestMethods >> methodWithInlinedCommentInBlock [

	nil isNil ifTrue: [ "comment" 1 ]
]

{ #category : #'generation-targets' }
VMCodeGenerationTestMethods >> methodWithLoop [

	1 to: 10 do: [ :i | self foo: i ]
]

{ #category : #'generation-targets' }
VMCodeGenerationTestMethods >> methodWithNilIfNil [

	^ nil
		ifNil: [ 1 ]
		ifNotNil: [ 2 ]
]
