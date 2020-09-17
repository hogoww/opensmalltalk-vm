Class {
	#name : #VMCodeGenerationTest,
	#superclass : #TestCase,
	#category : #VMMakerTests
}

{ #category : #tests }
VMCodeGenerationTest >> testCommentsInBlocks [

	| translation method codeGenerator result |
	method := VMCodeGenerationTestMethods >> #methodWithCommentInBlock.
	translation := method asTranslationMethodOfClass: TMethod.
	codeGenerator := CCodeGeneratorGlobalStructure new.
	codeGenerator addMethod: translation.
	codeGenerator doInlining: true.
		
	result := String streamContents: [ :stream |
		translation parseTree statements first emitCCodeOn: stream level: 0 generator: codeGenerator.
	].
	
	self assert: result equals: 'if (!(something())) {

	/* comment */
}'
]

{ #category : #tests }
VMCodeGenerationTest >> testCommentsInInlinedBlocks [

	| translation method codeGenerator result |
	method := VMCodeGenerationTestMethods >> #methodWithInlinedCommentInBlock.
	translation := method asTranslationMethodOfClass: TMethod.
	codeGenerator := CCodeGeneratorGlobalStructure new.
	codeGenerator addMethod: translation.
	codeGenerator doInlining: true.
		
	result := String streamContents: [ :stream |
		translation parseTree emitCCodeOn: stream level: 0 generator: codeGenerator.
	].
	
	self assert: result equals: 'if (!(something())) {

	/* comment */
}'
]

{ #category : #tests }
VMCodeGenerationTest >> testComplexIfNilAssignment [

	| translation method codeGenerator result |
	method := VMCodeGenerationTestMethods >> #methodWithIfNilAssignmentOfComplexStatements.
	translation := method asTranslationMethodOfClass: TMethod.
	codeGenerator := CCodeGeneratorGlobalStructure new.
	codeGenerator addMethod: translation.
	codeGenerator doInlining: true.
		
	result := String streamContents: [ :stream |
		translation parseTree statements first emitCCodeOn: stream level: 0 generator: codeGenerator.
	].
	
	self assert: result equals: 'if ((something()) == null) {
	temp = 1;
	temp += 1;
	variable = temp * 3;
}
else {
	temp = 2;
	temp += 5;
	variable = temp * 3;
}'
]

{ #category : #tests }
VMCodeGenerationTest >> testEmptyStructTypeDef [

	| typedef |
	typedef := String streamContents: [:str | MockEmptyVMStruct printTypedefOn: str ].
	self
		assert: typedef trimBoth
		equals: 'typedef struct {
 } MockEmptyVMStruct;' trimBoth
]

{ #category : #tests }
VMCodeGenerationTest >> testEmptyStructWithRedefinedStructNameTypeDef [

	| typedef |
	typedef := String streamContents: [:str | MockEmptyVMStructWithRedefinedStructName printTypedefOn: str ].
	self
		assert: typedef trimBoth
		equals: 'typedef struct {
 } RedefinedStruct;

#define MockEmptyVMStructWithRedefinedStructName RedefinedStruct' trimBoth
]

{ #category : #tests }
VMCodeGenerationTest >> testLoopVariableIsTemp [

	| translation method codeGenerator result |
	method := VMCodeGenerationTestMethods >> #methodWithLoop.
	translation := method asTranslationMethodOfClass: TMethod.
	codeGenerator := CCodeGeneratorGlobalStructure new.
	codeGenerator doInlining: true.
	
	result := String streamContents: [ :stream |
		translation emitCCodeOn: stream generator: codeGenerator.
	].

	self assert: result equals: '
	/* VMCodeGenerationTestMethods>>#methodWithLoop */
static sqInt
methodWithLoop(void)
{
    sqInt i;

	for (i = 1; i <= 10; i += 1) {
		foo(i);
	}
	return self;
}
'
]

{ #category : #tests }
VMCodeGenerationTest >> testNilIfNilGeneratesOnlyFirstBranch [

	| translation method codeGenerator result |
	method := VMCodeGenerationTestMethods >> #methodWithNilIfNil.
	translation := method asTranslationMethodOfClass: TMethod.
	codeGenerator := CCodeGeneratorGlobalStructure new.
	codeGenerator generateDeadCode: false.
	codeGenerator addMethod: translation.
	codeGenerator doInlining: true.

	result := String streamContents: [ :stream |
		translation parseTree statements first emitCCodeOn: stream level: 0 generator: codeGenerator.
	].
	
	self assert: result equals: 'return 1'
]

{ #category : #tests }
VMCodeGenerationTest >> testSimpleIfNil [

	| translation method codeGenerator result |
	method := VMCodeGenerationTestMethods >> #methodWithIfNilAssignment.
	translation := method asTranslationMethodOfClass: TMethod.
	codeGenerator := CCodeGeneratorGlobalStructure new.
	codeGenerator generateDeadCode: false.
	codeGenerator addMethod: translation.
	codeGenerator doInlining: true.
	
	result := String streamContents: [ :stream |
		translation parseTree statements first emitCCodeOn: stream level: 0 generator: codeGenerator.
	].
	
	self assert: result equals: 'variable = ((something()) == null
	? 1
	: 2)'
]

{ #category : #tests }
VMCodeGenerationTest >> testSimpleIfNilAssignment [

	| translation method codeGenerator result |
	method := VMCodeGenerationTestMethods >> #methodWithIfNil.
	translation := method asTranslationMethodOfClass: TMethod.
	codeGenerator := CCodeGeneratorGlobalStructure new.
	codeGenerator generateDeadCode: false.
	codeGenerator addMethod: translation.
	codeGenerator doInlining: true.
	
	result := String streamContents: [ :stream |
		translation parseTree statements first emitCCodeOn: stream level: 0 generator: codeGenerator.
	].
	
	self assert: result equals: 'if ((something()) == null) {
}
else {
}'
]
