Class {
	#name : #VMImageInspectorTest,
	#superclass : #VMInterpreterTests,
	#instVars : [
		'image'
	],
	#category : #'VMMakerTests-MemoryTests'
}

{ #category : #running }
VMImageInspectorTest >> setUp [
	super setUp.
	image := SpurFileImage onSpurSimulator: memory.
]

{ #category : #tests }
VMImageInspectorTest >> testFirstObjectIsNil [

	self assert: (SpurObject on: image headerSize image: image)
		equals: image nilObject
]
