Class {
	#name : #DefaultColorProvider,
	#superclass : #ColorProvider,
	#category : #'VMMakerTests-inspectors'
}

{ #category : #coloring }
DefaultColorProvider class >> defaultClassObjectsColor [
]

{ #category : #coloring }
DefaultColorProvider class >> defaultCurrentMethodColor [
]

{ #category : #coloring }
DefaultColorProvider class >> defaultForwarderColor [
	^ Color blue
]

{ #category : #coloring }
DefaultColorProvider class >> defaultFreeOopColor [ 
	^ Color lightGray
]

{ #category : #coloring }
DefaultColorProvider class >> defaultSpecialObjectsColor [
	^ Color pink
]

{ #category : #coloring }
DefaultColorProvider class >> defaultUsedOopColor [ 
	^ Color green
]

{ #category : #coloring }
DefaultColorProvider >> classObjectsColor [
	^ self class defaultClassObjectsColor
]

{ #category : #coloring }
DefaultColorProvider >> currentMethodColor [
	^ self class defaultCurrentMethodColor
]

{ #category : #coloring }
DefaultColorProvider >> forwarderColor [
	^ self class defaultForwarderColor
]

{ #category : #coloring }
DefaultColorProvider >> freeOopColor [ 
	^ self class defaultFreeOopColor
]

{ #category : #coloring }
DefaultColorProvider >> specialObjectsColor [
	^ self class defaultSpecialObjectsColor
]

{ #category : #coloring }
DefaultColorProvider >> usedOopColor [
	^ self class defaultUsedOopColor
]
