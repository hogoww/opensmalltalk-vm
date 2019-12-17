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
	self assert: tMethod returnType equals: #sqInt
	"returning an integer constants is the same as returning nothing"
	"this therefore return a sqInt"
	"see start of the CCodeGenerator >> harmonizeReturnTypesIn: method"
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
	self assert: tMethod returnType equals: #double.
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
	self assert: tMethod returnType equals: #'char *'.
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

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTests >> testReturnTempFloatConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempFloatConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #double.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTests >> testReturnTempIntEqual32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntEqual32ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned int'.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTests >> testReturnTempIntEqual64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntEqual64ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'unsigned long long'.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTests >> testReturnTempIntGreater64ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntGreater64ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'long long'.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTests >> testReturnTempIntLesser32ConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempIntLesser32ConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #int.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTests >> testReturnTempStringConstantNode [
	| ccg tMethod |
	ccg := CCodeGenerator new.
	ccg addClass: SlangTypeInferenceTestsClass.
	ccg inferTypesForImplicitlyTypedVariablesAndMethods.
	tMethod := ccg methodNamed: #returnTempStringConstantNode.
	
	self assert: tMethod isNotNil.
	self assert: (ccg typeFor: tMethod statements first in: tMethod) equals: #'char *'.
	self assert: (ccg typeFor: tMethod statements first variable in: tMethod) equals: #sqInt.
	self assert: tMethod returnType equals: #sqInt.
	
	self error "wait what"
]
