Class {
	#name : #ColorProvider,
	#superclass : #Object,
	#instVars : [
		'stackInspector'
	],
	#category : #'VMMakerTests-inspectors'
}

{ #category : #'instance creation' }
ColorProvider class >> newFor: aStackInspector [

	| instance |
	instance := self new.
	instance stackInspector: aStackInspector.
	^instance
]

{ #category : #coloring }
ColorProvider >> colorForOop: anOop [
	"Forwarders are hidden objects, so we need to check for forwarder before hidden."
	(self memory isUnambiguouslyForwarder: anOop) ifTrue: [ ^ self defaultForwarderColor ].
	(self memory isFreeOop: anOop) ifTrue: [ ^ self freeOopColor ].
	(self memory isHiddenObj: anOop) ifTrue: [ ^ self defaultSpecialObjectsColor ]. "
		[ interpreter objectMemory isHid ] -> [ self usedOopColor ]"
	^ self usedOopColor
]

{ #category : #coloring }
ColorProvider >> defaultClassObjectsColor [
]

{ #category : #coloring }
ColorProvider >> defaultCurrentMethodColor [
]

{ #category : #coloring }
ColorProvider >> defaultForwarderColor [
	^ Color blue
]

{ #category : #coloring }
ColorProvider >> defaultMemoryColor [
	^ Color lightGray
]

{ #category : #coloring }
ColorProvider >> defaultSpecialObjectsColor [
	^ Color pink
]

{ #category : #coloring }
ColorProvider >> freeOopColor [ 
	^ Color lightGray
]

{ #category : #helper }
ColorProvider >> memory [
	^stackInspector interpreter objectMemory
]

{ #category : #setting }
ColorProvider >> stackInspector: aStackInspector [ 
	stackInspector := aStackInspector
]

{ #category : #coloring }
ColorProvider >> usedOopColor [ 
	^ Color green
]
