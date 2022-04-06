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
ColorProvider >> classObjectsColor [
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> colorForOop: anOop [
	"Forwarders are hidden objects, so we need to check for forwarder before hidden."
	(self memory isUnambiguouslyForwarder: anOop) ifTrue: [ ^ self forwarderColor ].
	(self memory isFreeOop: anOop) ifTrue: [ ^ self freeOopColor ].
	(self memory isHiddenObj: anOop) ifTrue: [ ^ self specialObjectsColor ]. "
		[ interpreter objectMemory isHid ] -> [ self usedOopColor ]"
	^ self usedOopColor
]

{ #category : #coloring }
ColorProvider >> currentMethodColor [
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> forwarderColor [
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> freeOopColor [ 
	^ self subclassResponsibility
]

{ #category : #helper }
ColorProvider >> memory [
	^stackInspector interpreter objectMemory
]

{ #category : #coloring }
ColorProvider >> specialObjectsColor [
	^ self subclassResponsibility
]

{ #category : #setting }
ColorProvider >> stackInspector: aStackInspector [ 
	stackInspector := aStackInspector
]

{ #category : #coloring }
ColorProvider >> usedOopColor [
	^ self subclassResponsibility
]
