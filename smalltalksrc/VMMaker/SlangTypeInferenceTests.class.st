"
Basic tests for the type inference used in CCodeGenerator.
Support methods are in SlangTypeInferenceTestClass.
There is only one possible type by node, no ambiguities.

1 Constant
	test constantNode in a method.
	tests are tailor made for the current TConstantNode >> #typeOrNilFrom:in:.

2 Return-constant
	test return a constant node in a method.
	uses the previous categorie's values.

3 Return-temp-assigned-constant
	assign a temporary node with a constant
	then returns the temporary variable in the next statement.
	
4 Return-temp-assigned-message
	assign a temporary node with a message
	then returns the temporary variable in the next statement.
	
5 Return-explicit-temp
	returns a temporary typed by a pragma #var:type:.

6 Return-explicit-arg
	returns an argument typed by a pragma #var:type:.
"
Class {
	#name : #SlangTypeInferenceTests,
	#superclass : #TestCase,
	#category : #'VMMaker-Tests'
}

{ #category : #translation }
SlangTypeInferenceTests class >> declareCVarsIn: ccg [
]

{ #category : #translation }
SlangTypeInferenceTests class >> prepareToBeAddedToCodeGenerator: aCCodeGenerator [ 
	"Hook for translation.  e.g. allows a subclass to override its
	 superclass's methods by deleting them before it adds its own."
]

{ #category : #translation }
SlangTypeInferenceTests class >> requiredMethodNames: something [
	^ #()
]

{ #category : #constant }
SlangTypeInferenceTests >> testABigNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aBigNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'
]

{ #category : #constant }
SlangTypeInferenceTests >> testAFalseConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aFalseConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int
]

{ #category : #constant }
SlangTypeInferenceTests >> testAFloatConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aFloatConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double
]

{ #category : #constant }
SlangTypeInferenceTests >> testANilConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aNilConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int
]

{ #category : #constant }
SlangTypeInferenceTests >> testASmallNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aSmallNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int
]

{ #category : #constant }
SlangTypeInferenceTests >> testAStringConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aStringConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'
]

{ #category : #constant }
SlangTypeInferenceTests >> testATrueConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aTrueConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int
]

{ #category : #constant }
SlangTypeInferenceTests >> testAnIntEqual32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #anIntEqual32ConstantNode.
		
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned int'
]

{ #category : #constant }
SlangTypeInferenceTests >> testAnIntEqual64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #anIntEqual64ConstantNode.
		
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned long long'
]

{ #category : #constant }
SlangTypeInferenceTests >> testAnIntGreater64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #anIntGreater64ConstantNode.
		
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'
]

{ #category : #constant }
SlangTypeInferenceTests >> testAnIntLess32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #anIntLesser32ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.

]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnABigNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnABigNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'.
	self assert: tMethod returnType equals: #sqLong
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnABigNegativeIntegerMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnABigNegativeIntegerMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqLong.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqLong.
	self assert: tMethod returnType equals: #sqLong.
]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnAFalseConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAFalseConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnAFalseMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAFalseMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnAFloatMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAFloatMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #double.
	self assert: tMethod returnType equals: #double.
]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnANilConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnANilConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnANilMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnANilMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnASmallNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnASmallNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnASmallNegativeIntegerMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnASmallNegativeIntegerMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnAStringConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAStringConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: tMethod returnType equals: #'char *'
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnAStringMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAStringMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #'char *'.
	self assert: tMethod returnType equals: #'char *'.
]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnATrueConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnATrueConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnATrueMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnATrueMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnAnIntEqual32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntEqual32ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned int'.
	self assert: tMethod returnType equals: #sqInt
	"returning an integer constants is the same as returning nothing"
	"this therefore return a sqInt"
	"see start of the CCodeGenerator >> harmonizeReturnTypesIn: method"
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnAnIntEqual32MessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntEqual32MessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	"the method return type is sqint, so it's coherent, see testReturnAnIntEqual32MessageSend"
]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnAnIntEqual64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntEqual64ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned long long'.
	self assert: tMethod returnType equals: #sqInt
	"returning an integer constants is the same as returning nothing"
	"this therefore return a sqInt"
	"see start of the CCodeGenerator >> harmonizeReturnTypesIn: method"
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnAnIntEqual64MessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntEqual64MessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	"the method return type is sqint, so it's coherent, see testReturnAnIntEqual64MessageSend"
]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnAnIntGreater64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntGreater64ConstantNode.
		
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'.
	self assert: tMethod returnType equals: #sqInt
	"returning an integer constants is the same as returning nothing"
	"this therefore return a sqInt"
	"see start of the CCodeGenerator >> harmonizeReturnTypesIn: method"
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnAnIntGreater64MessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntGreater64MessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	"the method return type is sqint, so it's coherent, see testReturnAnIntGreater64MessageSend"
]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnAnIntLess32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntLesser32ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
	"returning constants is the same as returning nothing"
	"this therefore return a sqInt"
	"see start of the CCodeGenerator >> harmonizeReturnTypesIn: method"
]

{ #category : #'return-message-send' }
SlangTypeInferenceTests >> testReturnAnIntLesser32MessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntLesser32MessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	"the method return type is sqint, so it's coherent, see testReturnAnIntLesser64MessageSend"
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTests >> testReturnExplicitArgDouble [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgDouble:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: tMethod returnType equals: #double
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTests >> testReturnExplicitArgFloat [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgFloat:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #float.
	self assert: tMethod returnType equals: #float
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTests >> testReturnExplicitArgInt [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgInt:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTests >> testReturnExplicitArgLongLong [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgLongLong:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'.
	self assert: tMethod returnType equals: #sqLong
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTests >> testReturnExplicitArgRandom [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgRandom:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #completelyRandom.
	self assert: tMethod returnType equals: #completelyRandom
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTests >> testReturnExplicitArgString [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgString:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: tMethod returnType equals: #'char *'
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTests >> testReturnExplicitArgUnsignedInt [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgUnsignedInt:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned int'.
	self assert: tMethod returnType equals: #usqInt
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTests >> testReturnExplicitArgUnsignedLongLong [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgUnsignedLongLong:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned long long'.
	self assert: tMethod returnType equals: #usqLong
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTests >> testReturnExplicitTempDouble [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempDouble.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: tMethod returnType equals: #double
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTests >> testReturnExplicitTempFloat [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempFloat.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #float.
	self assert: tMethod returnType equals: #float
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTests >> testReturnExplicitTempInt [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempInt.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTests >> testReturnExplicitTempLongLong [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempLongLong.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'.
	self assert: tMethod returnType equals: #sqLong
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTests >> testReturnExplicitTempRandom [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempRandom.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #completelyRandom.
	self assert: tMethod returnType equals: #completelyRandom
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTests >> testReturnExplicitTempString [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempString.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: tMethod returnType equals: #'char *'
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTests >> testReturnExplicitTempUnsignedInt [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempUnsignedInt.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned int'.
	self assert: tMethod returnType equals: #usqInt
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTests >> testReturnExplicitTempUnsignedLongLong [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempUnsignedLongLong.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned long long'.
	self assert: tMethod returnType equals: #usqLong
]

{ #category : #'return-constant' }
SlangTypeInferenceTests >> testReturnFloatConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAFloatConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: tMethod returnType equals: #double
	
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempBigNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempBigNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #'long long'. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempBigNegativeIntegerMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempBigNegativeIntegerMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqLong.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqLong.
	self assert: tMethod returnType equals: #sqLong.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempFalseConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempFalseConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #int. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempFalseMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempFalseMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempFloatConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempFloatConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #double. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempFloatMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempFloatMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempIntEqual32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntEqual32ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned int'. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #'unsigned int'. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempIntEqual32MessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntEqual32MessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempIntEqual64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntEqual64ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned long long'. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #'unsigned long long'. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempIntEqual64MessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntEqual64MessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempIntGreater64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntGreater64ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #'long long'. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempIntGreater64MessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntGreater64MessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempIntLesser32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntLesser32ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #int. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempIntLesser32MessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntLesser32MessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempNilConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempNilConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #int. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempNilMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempNilMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempSmallNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempSmallNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #int. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempSmallNegativeIntegerMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempSmallNegativeIntegerMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempStringConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempStringConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #'char *'. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempStringMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempStringMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #'char *'.
	self assert: tMethod returnType equals: #'char *'.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTests >> testReturnTempTrueConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempTrueConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #int. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self error. "wait what"
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTests >> testReturnTempTrueMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempTrueMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]
