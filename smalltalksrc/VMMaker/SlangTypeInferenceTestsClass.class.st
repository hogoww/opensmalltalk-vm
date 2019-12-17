Class {
	#name : #SlangTypeInferenceTestsClass,
	#superclass : #InterpreterPlugin,
	#category : #'VMMaker-Tests'
}

{ #category : #constant }
SlangTypeInferenceTestsClass >> aFloatConstantNode [
	^ 1.0
]

{ #category : #constant }
SlangTypeInferenceTestsClass >> aStringConstantNode [
	^ 'aString'
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

{ #category : #'return-constant' }
SlangTypeInferenceTestsClass >> returnAFloatConstantNode [
	^ 1.0
]

{ #category : #'return-message-send' }
SlangTypeInferenceTestsClass >> returnAFloatMessageSend [
	^ self returnAFloatConstantNode
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
	"SmallInteger maxVal on a 64bit system"
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
	" 2 raisedTo: 64 "
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
	"SmallInteger maxVal on a 64bit system"
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
	" 2 raisedTo: 64 "
	| t |
	^ t
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTestsClass >> returnTempFloatConstantNode [
	| t |
	t := 1.0.
	^ t
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTestsClass >> returnTempIntEqual32ConstantNode [
	" 2 ^ 32 - 1"
	| t |
	t := 4294967295.
	^ t
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTestsClass >> returnTempIntEqual64ConstantNode [
	" 2 raisedTo: 64 "
	| t | 
	t := 18446744073709551615.
	^ t
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTestsClass >> returnTempIntGreater64ConstantNode [
	"SmallInteger maxVal on a 64bit system"
	| t | 
	t := 1152921504606846975.
	^ t
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTestsClass >> returnTempIntLesser32ConstantNode [
	| t |
	t := 30.
	^ t
]

{ #category : #'return-temp-assigned' }
SlangTypeInferenceTestsClass >> returnTempStringConstantNode [
	| t |
	t := 'aString'.
	^ t
]
