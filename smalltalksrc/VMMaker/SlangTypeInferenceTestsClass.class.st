Class {
	#name : #SlangTypeInferenceTestsClass,
	#superclass : #InterpreterPrimitives,
	#category : #'VMMaker-Tests'
}

{ #category : #constant }
SlangTypeInferenceTestsClass >> aBigNegativeIntegerConstantNode [
	"SmallInteger maxVal on a 64bit system"
	-1152921504606846975
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> aFalseConstantNode [
	false
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> aFloatConstantNode [
	1.0
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> aNilConstantNode [
	nil
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> aSmallNegativeIntegerConstantNode [
	-30
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> aStringConstantNode [
	'aString'
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> aTrueConstantNode [
	true
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> anIntEqual32ConstantNode [
	" 2 ^ 32 - 1"
	4294967295
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> anIntEqual64ConstantNode [
	" 2 raisedTo: 64 "
	18446744073709551615
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> anIntGreater64ConstantNode [
	"SmallInteger maxVal on a 64bit system"
	1152921504606846975
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> anIntLesser32ConstantNode [
	30
]

{ #category : #'control primitives' }
SlangTypeInferenceTestsClass >> primitiveFindHandlerContext [
	^ self error
]

{ #category : #'control primitives' }
SlangTypeInferenceTestsClass >> primitiveFindNextUnwindContext [
	self error
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnABigNegativeIntegerConstantNode [
"SmallInteger maxVal on a 64bit system"
	^ -1152921504606846975
	
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnABigNegativeIntegerMessageSend [
	^ self returnABigNegativeIntegerConstantNode
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnAFalseConstantNode [
	^ false
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnAFalseMessageSend [
	^ self returnAFalseConstantNode
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnAFloatConstantNode [
	^ 1.0
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnAFloatMessageSend [
	^ self returnAFloatConstantNode
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnANilConstantNode [
	^ nil
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnANilMessageSend [
	^ self returnANilConstantNode
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnASmallNegativeIntegerConstantNode [
	^ -30
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnASmallNegativeIntegerMessageSend [
	^ self returnASmallNegativeIntegerConstantNode
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnAStringConstantNode [
	^ 'aString'
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnAStringMessageSend [
	^ self returnAStringConstantNode
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnATrueConstantNode [
	^ true
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnATrueMessageSend [
	^ self returnATrueConstantNode
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnAnIntEqual32ConstantNode [
	" 2 ^ 32 - 1"
	^ 4294967295
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnAnIntEqual32MessageSend [
	^ self returnAnIntEqual32ConstantNode
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnAnIntEqual64ConstantNode [
	" 2 raisedTo: 64 "
	^ 18446744073709551615
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnAnIntEqual64MessageSend [
	^ self returnAnIntEqual64ConstantNode
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnAnIntGreater64ConstantNode [
	"SmallInteger maxVal on a 64bit system"
	^ 1152921504606846975
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnAnIntGreater64MessageSend [
	^ self returnAnIntGreater64ConstantNode
]

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnAnIntLesser32ConstantNode [
	^ 30
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnAnIntLesser32MessageSend [
	^ self returnAnIntLesser32ConstantNode
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTestsClass >> returnExplicitArgDouble: t [
	<var:#t type:#double>
	^ t
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTestsClass >> returnExplicitArgFloat: t [
	<var:#t type:#float>
	^ t
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTestsClass >> returnExplicitArgInt: t [
	<var:#t type:#int>
	^ t
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTestsClass >> returnExplicitArgLongLong: t [
	<var:#t type:#'long long'>
	^ t
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTestsClass >> returnExplicitArgRandom: t [
	<var:#t type:#completelyRandom>
	^ t
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTestsClass >> returnExplicitArgString: t [
	<var:#t type:#'char *'>
	^ t
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTestsClass >> returnExplicitArgUnsignedInt: t [
	<var:#t type:#'unsigned int'>
	^ t
]

{ #category : #'return-explicit-arg' }
SlangTypeInferenceTestsClass >> returnExplicitArgUnsignedLongLong: t [
	<var:#t type:#'unsigned long long'>
	^ t
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTestsClass >> returnExplicitTempDouble [
	<var:#t type:#double>
	| t |
	^ t
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTestsClass >> returnExplicitTempFloat [
	<var:#t type:#float>
	| t |
	^ t
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTestsClass >> returnExplicitTempInt [
	<var:#t type:#int>
	| t |
	^ t
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTestsClass >> returnExplicitTempLongLong [
	<var:#t type:#'long long'>
	| t | 
	^ t
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTestsClass >> returnExplicitTempRandom [
	<var:#t type:#completelyRandom>
	| t |
	^ t
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTestsClass >> returnExplicitTempString [
	<var:#t type:#'char *'>
	| t |
	^ t
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTestsClass >> returnExplicitTempUnsignedInt [
	<var:#t type:#'unsigned int'>
	| t |
	^ t
]

{ #category : #'return-explicit-temp' }
SlangTypeInferenceTestsClass >> returnExplicitTempUnsignedLongLong [
	<var:#t type:#'unsigned long long'>
	| t |
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempBigNegativeIntegerConstantNode [
	| t |
	"SmallInteger maxVal on a 64bit system"
	t := -1152921504606846975.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempBigNegativeIntegerMessageNode [
	| t |
	t := self returnABigNegativeIntegerConstantNode.
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempFalseConstantNode [
	| t |
	t := false.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempFalseMessageNode [
	| t |
	t := self returnAFalseConstantNode.
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempFloatConstantNode [
	| t |
	t := 1.0.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempFloatMessageNode [
	| t |
	t := self returnAFloatMessageSend.
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempIntEqual32ConstantNode [
	" 2 ^ 32 - 1"
	| t |
	t := 4294967295.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempIntEqual32MessageNode [
	| t |
	t := self returnAnIntEqual32ConstantNode.
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempIntEqual64ConstantNode [
	" 2 raisedTo: 64 "
	| t | 
	t := 18446744073709551615.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempIntEqual64MessageNode [
	| t | 
	t := self returnAnIntEqual64ConstantNode.
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempIntGreater64ConstantNode [
	| t |
	"SmallInteger maxVal on a 64bit system"
	t := 1152921504606846975.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempIntGreater64MessageNode [
	| t |
	t := self returnAnIntGreater64ConstantNode.
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempIntLesser32ConstantNode [
	| t |
	t := 30.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempIntLesser32MessageNode [
	| t |
	t := self returnAnIntLesser32ConstantNode.
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempNilConstantNode [
	| t |
	t := nil.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempNilMessageNode [
	| t |
	t := self returnANilConstantNode.
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempSmallNegativeIntegerConstantNode [
	| t |
	t := -30.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempSmallNegativeIntegerMessageNode [
	| t |
	t := self returnASmallNegativeIntegerConstantNode.
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempStringConstantNode [
	| t |
	t := 'aString'.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempStringMessageNode [
	| t |
	t := self returnAStringConstantNode.
	^ t
]

{ #category : #'return-temp-assigned-const' }
SlangTypeInferenceTestsClass >> returnTempTrueConstantNode [
	| t |
	t := true.
	^ t
]

{ #category : #'return-temp-assigned-message' }
SlangTypeInferenceTestsClass >> returnTempTrueMessageNode [
	| t |
	t := self returnATrueConstantNode.
	^ t
]
