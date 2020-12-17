Class {
	#name : #VMObject,
	#superclass : #Object,
	#instVars : [
		'memory',
		'address'
	],
	#category : #'VMMaker-Tools'
}

{ #category : #'as yet unclassified' }
VMObject class >> createFrom: anOop memory: aMemory [
	
	^ self new 
		address: anOop;
		memory: aMemory;
		yourself
]

{ #category : #accessing }
VMObject >> = anotherObject [
	(anotherObject isKindOf: SmallInteger) ifTrue: [ ^ anotherObject = address ].
	
	^ anotherObject address = address
]

{ #category : #accessing }
VMObject >> address [

	^ address
]

{ #category : #accessing }
VMObject >> address: anObject [

	address := anObject
]

{ #category : #printing }
VMObject >> className [ 

	^ 'todo'
]

{ #category : #printing }
VMObject >> classOop [
	^ memory fetchClassOf: address
]

{ #category : #accessing }
VMObject >> format [
	^ memory formatOf: address
]

{ #category : #printing }
VMObject >> header [
	^ memory baseHeader: address
]

{ #category : #printing }
VMObject >> isImmediate [
	^ memory isImmediate: address
]

{ #category : #testing }
VMObject >> isOld [
	^ memory isOldObject: address
]

{ #category : #testing }
VMObject >> isPinned [
	^ memory isPinned: address
]

{ #category : #testing }
VMObject >> isYoung [
	^ memory isYoung: address
]

{ #category : #accessing }
VMObject >> memory [

	^ memory
]

{ #category : #accessing }
VMObject >> memory: anObject [

	memory := anObject
]

{ #category : #accessing }
VMObject >> numSlots [
	^ memory numSlotsOf: address
]

{ #category : #pinning }
VMObject >> pinObject [
	^ memory pinObject: address
]

{ #category : #printing }
VMObject >> printAsCharacter [
	^ self shouldBeImplemented
]

{ #category : #printing }
VMObject >> printAsImmediate [
	self isCharacter ifTrue: [ ^ self printAsCharacter ].
	"default case is a smallInteger"
	^ self printAsInteger
]

{ #category : #printing }
VMObject >> printAsInteger [
	^ 'SmallInteger: ', address printString
]

{ #category : #printing }
VMObject >> printString [
	| knownObject |
	knownObject := VMFrameBuilder new memory: memory; adaptAddressToMemory: address.
	knownObject isString ifTrue: [ ^ knownObject ].

	self isImmediate ifTrue:[ ^ self printAsImmediate ].
	
	^ String streamContents: [ :s |
		s <<  'object of address: ';
			<< knownObject printString;
			<< ' of class ';
			<< (VMObject createFrom: self classOop memory: memory) className;
			<< ' with ';
			<< self numSlots printString;
			<< ' slots'
		]
	
]

{ #category : #printing }
VMObject >> slotAt: anIndex [
	self numSlots >= anIndex ifFalse: [ self error: 'Not accessing a slot' ].
	^ VMObject createFrom: (memory fetchPointer: anIndex ofObject: address) memory: memory 
]
