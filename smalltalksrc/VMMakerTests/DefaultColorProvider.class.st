Class {
	#name : #DefaultColorProvider,
	#superclass : #ColorProvider,
	#category : #'VMMakerTests-inspectors'
}

{ #category : #coloring }
DefaultColorProvider class >> defaultClassOopColor [
	^ Color blue
]

{ #category : #coloring }
DefaultColorProvider class >> defaultCurrentMethodOopColor [
]

{ #category : #coloring }
DefaultColorProvider class >> defaultForwarderOopColor [
	^ Color blue
]

{ #category : #coloring }
DefaultColorProvider class >> defaultFreeOopColor [ 
	^ Color lightGray
]

{ #category : #coloring }
DefaultColorProvider class >> defaultInitialSelectionColor [ 
	^ Color orange
]

{ #category : #coloring }
DefaultColorProvider class >> defaultPinnedOopColor [
	^ Color purple
]

{ #category : #coloring }
DefaultColorProvider class >> defaultSpecialOopColor [
	^ Color pink
]

{ #category : #coloring }
DefaultColorProvider class >> defaultUsedOopColor [ 
	^ Color green
]

{ #category : #coloring }
DefaultColorProvider >> classOopColor [
	^ self class defaultClassOopColor
]

{ #category : #coloring }
DefaultColorProvider >> currentMethodColor [
	^ self class defaultCurrentMethodOopColor
]

{ #category : #coloring }
DefaultColorProvider >> forwarderOopColor [
	^ self class defaultForwarderOopColor
]

{ #category : #coloring }
DefaultColorProvider >> freeOopColor [ 
	^ self class defaultFreeOopColor
]

{ #category : #coloring }
DefaultColorProvider >> initialSelectionColor [
	^ self class defaultInitialSelectionColor
]

{ #category : #coloring }
DefaultColorProvider >> initialselectionColor [
	^ self class defaultSelectionColor
]

{ #category : #coloring }
DefaultColorProvider >> pinnedOopColor [
	^ self class defaultPinnedOopColor
]

{ #category : #coloring }
DefaultColorProvider >> regularOopColor [
	^ self class defaultUsedOopColor
]

{ #category : #coloring }
DefaultColorProvider >> specialOopColor [
	^ self class defaultSpecialOopColor
]
