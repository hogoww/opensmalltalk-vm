Class {
	#name : #SpurCompiledMethodLayout,
	#superclass : #SpurLayout,
	#category : #'VMMaker-Tools-imageInspector'
}

{ #category : #accessing }
SpurCompiledMethodLayout >> allSlots [
	self warning: 'Probably should not implement, but easy fix to not break inspection'.
	^ {  }
]

{ #category : #testing }
SpurCompiledMethodLayout >> isCompiledMethod [

	^ true
]
