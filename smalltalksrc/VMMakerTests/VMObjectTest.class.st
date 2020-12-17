Class {
	#name : #VMObjectTest,
	#superclass : #VMInterpreterTests,
	#instVars : [
		'vmObject',
		'objectNilObject',
		'integerObject'
	],
	#category : #VMMakerTests
}

{ #category : #running }
VMObjectTest >> setUp [
	super setUp.
	vmObject := VMObject createFrom: (self newOldSpaceObjectWithSlots: 3) memory: memory.
	objectNilObject := VMObject createFrom: memory nilObject memory: memory.
	integerObject := VMObject createFrom: (memory integerObjectOf: 42) memory: memory
]

{ #category : #tests }
VMObjectTest >> testClassOfAnObjectIsNil [
	self assert: vmObject classOop equals: memory nilObject.
]

{ #category : #tests }
VMObjectTest >> testFormatOfRandomObjectIsSomething [
	self assert: vmObject format equals: 2
]

{ #category : #tests }
VMObjectTest >> testHeader [
	vmObject header.
]

{ #category : #tests }
VMObjectTest >> testNilObjectShouldPrintNilObject [
	self assert: objectNilObject printString equals: 'nilObject'
]

{ #category : #tests }
VMObjectTest >> testNumSlotsOfNilIs0 [
	self assert: vmObject numSlots equals: 3
]

{ #category : #tests }
VMObjectTest >> testObjectIsNotYoung [
	"isOld and isYound use different methods, that do not rely on each other.
	So we test both."
	self deny: vmObject isYoung
]

{ #category : #tests }
VMObjectTest >> testObjectIsOld [	
	"isOld and isYound use different methods, that do not rely on each other.
	So we test both."
	self assert: vmObject isOld
]

{ #category : #tests }
VMObjectTest >> testPinnedObjectIsPinned [
	self setUpScheduler.
	
	vmObject pinObject.
	self assert: vmObject isPinned
]

{ #category : #tests }
VMObjectTest >> testRegularObjectIsNotImmediate [
	self deny: vmObject isImmediate
]

{ #category : #tests }
VMObjectTest >> testSlotAtIsNilObject [
	self assert: (vmObject slotAt: 1) equals: objectNilObject.
]

{ #category : #'tests-immediate' }
VMObjectTest >> testSmallIntegerIsImmediate [
	self assert: integerObject isImmediate.
]

{ #category : #'tests-immediate' }
VMObjectTest >> testSmallIntegerShouldPrintItself [
	self assert: integerObject printString equals: 'SmallInteger: 337'.
]
