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
ColorProvider >> classOopColor [
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> colorForOop: anOop [
	"Forwarders are hidden objects, so we need to check for forwarder before hidden."
	(self memory isUnambiguouslyForwarder: anOop) ifTrue: [ ^ self forwarderOopColor ].
	(self memory isPinned: anOop) ifTrue: [ ^ self pinnedOopColor ].
	(self memory isFreeOop: anOop) ifTrue: [ ^ self freeOopColor ].
	(self memory isHiddenObj: anOop) ifTrue: [ ^ self specialOopColor ]. "
		[ interpreter objectMemory isHid ] -> [ self usedOopColor ]"
	
	(self memory isContext: anOop) ifTrue: [ ^ self contextOopColor ].
	(self memory isInClassTable: anOop) ifTrue: [ ^ self classOopColor ].
	(self memory isOopCompiledMethod: anOop) ifTrue: [ ^ self compiledMethodOopColor ].
	^ self regularOopColor
]

{ #category : #coloring }
ColorProvider >> compiledMethodOopColor [ 
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> contextOopColor [
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> currentMethodColor [
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> forwarderOopColor [
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> freeOopColor [ 
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> initialSelectionColor [
	^ self subclassResponsibility
]

{ #category : #helper }
ColorProvider >> memory [
	^stackInspector interpreter objectMemory
]

{ #category : #coloring }
ColorProvider >> pinnedOopColor [
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> regularOopColor [
	^ self subclassResponsibility
]

{ #category : #coloring }
ColorProvider >> specialOopColor [
	^ self subclassResponsibility
]

{ #category : #accessing }
ColorProvider >> stackInspector: aStackInspector [ 
	stackInspector := aStackInspector
]
