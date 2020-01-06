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
	#name : #SlangBasicTypeInferenceTest,
	#superclass : #TestCase,
	#category : #'VMMaker-Tests'
}

{ #category : #constant }
SlangBasicTypeInferenceTest >> testABigNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aBigNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'
]

{ #category : #constant }
SlangBasicTypeInferenceTest >> testAFalseConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aFalseConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int
]

{ #category : #constant }
SlangBasicTypeInferenceTest >> testAFloatConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aFloatConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double
]

{ #category : #constant }
SlangBasicTypeInferenceTest >> testANilConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aNilConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int
]

{ #category : #constant }
SlangBasicTypeInferenceTest >> testASmallNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aSmallNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int
]

{ #category : #constant }
SlangBasicTypeInferenceTest >> testAStringConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aStringConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'
]

{ #category : #constant }
SlangBasicTypeInferenceTest >> testATrueConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #aTrueConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int
]

{ #category : #constant }
SlangBasicTypeInferenceTest >> testAnIntEqual32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #anIntEqual32ConstantNode.
		
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned int'
]

{ #category : #constant }
SlangBasicTypeInferenceTest >> testAnIntEqual64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #anIntEqual64ConstantNode.
		
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned long long'
]

{ #category : #constant }
SlangBasicTypeInferenceTest >> testAnIntGreater64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #anIntGreater64ConstantNode.
		
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'
]

{ #category : #constant }
SlangBasicTypeInferenceTest >> testAnIntLess32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #anIntLesser32ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.

]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnABigNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnABigNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'.
	self assert: tMethod returnType equals: #sqLong
]

{ #category : #'return-message-send' }
SlangBasicTypeInferenceTest >> testReturnABigNegativeIntegerMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnABigNegativeIntegerMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqLong.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqLong.
	self assert: tMethod returnType equals: #sqLong.
]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnAFalseConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAFalseConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-message-send' }
SlangBasicTypeInferenceTest >> testReturnAFalseMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAFalseMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-message-send' }
SlangBasicTypeInferenceTest >> testReturnAFloatMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAFloatMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #double.
	self assert: tMethod returnType equals: #double.
]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnANilConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnANilConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-message-send' }
SlangBasicTypeInferenceTest >> testReturnANilMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnANilMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnASmallNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnASmallNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-message-send' }
SlangBasicTypeInferenceTest >> testReturnASmallNegativeIntegerMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnASmallNegativeIntegerMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnAStringConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAStringConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: tMethod returnType equals: #'char *'
]

{ #category : #'return-message-send' }
SlangBasicTypeInferenceTest >> testReturnAStringMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAStringMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #'char *'.
	self assert: tMethod returnType equals: #'char *'.
]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnATrueConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnATrueConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-message-send' }
SlangBasicTypeInferenceTest >> testReturnATrueMessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnATrueMessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnAnIntEqual32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
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
SlangBasicTypeInferenceTest >> testReturnAnIntEqual32MessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntEqual32MessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	"the method return type is sqint, so it's coherent, see testReturnAnIntEqual32MessageSend"
]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnAnIntEqual64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
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
SlangBasicTypeInferenceTest >> testReturnAnIntEqual64MessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntEqual64MessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	"the method return type is sqint, so it's coherent, see testReturnAnIntEqual64MessageSend"
]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnAnIntGreater64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
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
SlangBasicTypeInferenceTest >> testReturnAnIntGreater64MessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntGreater64MessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	"the method return type is sqint, so it's coherent, see testReturnAnIntGreater64MessageSend"
]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnAnIntLess32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
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
SlangBasicTypeInferenceTest >> testReturnAnIntLesser32MessageSend [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAnIntLesser32MessageSend.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first expression in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	"the method return type is sqint, so it's coherent, see testReturnAnIntLesser64MessageSend"
]

{ #category : #'return-explicit-arg' }
SlangBasicTypeInferenceTest >> testReturnExplicitArgDouble [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgDouble:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: tMethod returnType equals: #double
]

{ #category : #'return-explicit-arg' }
SlangBasicTypeInferenceTest >> testReturnExplicitArgFloat [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgFloat:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #float.
	self assert: tMethod returnType equals: #float
]

{ #category : #'return-explicit-arg' }
SlangBasicTypeInferenceTest >> testReturnExplicitArgInt [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgInt:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-explicit-arg' }
SlangBasicTypeInferenceTest >> testReturnExplicitArgLongLong [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgLongLong:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'.
	self assert: tMethod returnType equals: #sqLong
]

{ #category : #'return-explicit-arg' }
SlangBasicTypeInferenceTest >> testReturnExplicitArgRandom [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgRandom:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #completelyRandom.
	self assert: tMethod returnType equals: #completelyRandom
]

{ #category : #'return-explicit-arg' }
SlangBasicTypeInferenceTest >> testReturnExplicitArgString [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgString:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: tMethod returnType equals: #'char *'
]

{ #category : #'return-explicit-arg' }
SlangBasicTypeInferenceTest >> testReturnExplicitArgUnsignedInt [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgUnsignedInt:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned int'.
	self assert: tMethod returnType equals: #usqInt
]

{ #category : #'return-explicit-arg' }
SlangBasicTypeInferenceTest >> testReturnExplicitArgUnsignedLongLong [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitArgUnsignedLongLong:.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned long long'.
	self assert: tMethod returnType equals: #usqLong
]

{ #category : #'return-explicit-temp' }
SlangBasicTypeInferenceTest >> testReturnExplicitTempDouble [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempDouble.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: tMethod returnType equals: #double
]

{ #category : #'return-explicit-temp' }
SlangBasicTypeInferenceTest >> testReturnExplicitTempFloat [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempFloat.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #float.
	self assert: tMethod returnType equals: #float
]

{ #category : #'return-explicit-temp' }
SlangBasicTypeInferenceTest >> testReturnExplicitTempInt [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempInt.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: tMethod returnType equals: #sqInt
]

{ #category : #'return-explicit-temp' }
SlangBasicTypeInferenceTest >> testReturnExplicitTempLongLong [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempLongLong.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'.
	self assert: tMethod returnType equals: #sqLong
]

{ #category : #'return-explicit-temp' }
SlangBasicTypeInferenceTest >> testReturnExplicitTempRandom [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempRandom.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #completelyRandom.
	self assert: tMethod returnType equals: #completelyRandom
]

{ #category : #'return-explicit-temp' }
SlangBasicTypeInferenceTest >> testReturnExplicitTempString [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempString.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: tMethod returnType equals: #'char *'
]

{ #category : #'return-explicit-temp' }
SlangBasicTypeInferenceTest >> testReturnExplicitTempUnsignedInt [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempUnsignedInt.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned int'.
	self assert: tMethod returnType equals: #usqInt
]

{ #category : #'return-explicit-temp' }
SlangBasicTypeInferenceTest >> testReturnExplicitTempUnsignedLongLong [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnExplicitTempUnsignedLongLong.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned long long'.
	self assert: tMethod returnType equals: #usqLong
]

{ #category : #'return-constant' }
SlangBasicTypeInferenceTest >> testReturnFloatConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnAFloatConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: tMethod returnType equals: #double
	
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempBigNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempBigNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #'long long'. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "unexpected type conversion, shouldn't it be a sqLong?"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempBigNegativeIntegerMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempBigNegativeIntegerMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqLong.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqLong.
	self assert: tMethod returnType equals: #sqLong.
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempFalseConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempFalseConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #int. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "unexpected type conversion"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempFalseMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempFalseMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempFloatConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempFloatConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #double. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "type lost"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempFloatMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempFloatMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "wait what"
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempIntEqual32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntEqual32ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned int'. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #'unsigned int'. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "unexpected type conversion"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempIntEqual32MessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntEqual32MessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempIntEqual64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntEqual64ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned long long'. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #'unsigned long long'. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "unexpected type conversion, shouldn't it at least be an sqLong? or better, an uSqLong"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempIntEqual64MessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntEqual64MessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempIntGreater64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntGreater64ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #'long long'. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "unexpected type conversion, shouldn't it be at least an sqLong?"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempIntGreater64MessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntGreater64MessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempIntLesser32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntLesser32ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #int. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "unexpected type conversion"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempIntLesser32MessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntLesser32MessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempNilConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempNilConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #int. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "unexpected type conversion"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempNilMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempNilMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempSmallNegativeIntegerConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempSmallNegativeIntegerConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #int. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "unexpected type conversion"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempSmallNegativeIntegerMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempSmallNegativeIntegerMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempStringConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempStringConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #'char *'. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "type lost"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempStringMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempStringMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #'char *'.
	self assert: tMethod returnType equals: #'char *'.
]

{ #category : #'return-temp-assigned-const' }
SlangBasicTypeInferenceTest >> testReturnTempTrueConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempTrueConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int. " assignementNode "
	self assert: (ccg typeFor: tMethod statements first value in: tMethod) equals: #int. " value, constantNode "
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt. " variable, temporaryNode "
	self assert: tMethod returnType equals: #sqInt.
	
	self assert: false "Unexpected conversion"
]

{ #category : #'return-temp-assigned-message' }
SlangBasicTypeInferenceTest >> testReturnTempTrueMessageNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangBasicTypeInferenceTestClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempTrueMessageNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #sqInt.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
]
