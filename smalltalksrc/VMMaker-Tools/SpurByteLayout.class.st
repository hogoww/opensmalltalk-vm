Class {
	#name : #SpurByteLayout,
	#superclass : #SpurLayout,
	#category : #'VMMaker-Tools-imageInspector'
}

{ #category : #accessing }
SpurByteLayout >> asLocalByteArray [
	^ self memory memoryManager 
		copyFrom: object address value + self memory wordSize
		to: object address value + self memory wordSize + self byteSize - self padding.
]

{ #category : #accessing }
SpurByteLayout >> at: anInteger [ 
	
	" ToDo: consider inst vars "
	| slotIndex byteIndex |
	slotIndex := (anInteger - 1) // self wordSize.
	byteIndex := (anInteger - 1) %  self wordSize.
	^ (self slotAt: slotIndex + 1) at: byteIndex + 1
]

{ #category : #accessing }
SpurByteLayout >> objectPrintOn: aStream [
	aStream nextPutAll: self object asLocalByteArray asString
]

{ #category : #accessing }
SpurByteLayout >> padding [
	"Don't know why, we need a + 1 here
	0 based? "
	^ self object format - 16 + 1
]

{ #category : #accessing }
SpurByteLayout >> slotAt: anInteger [ 
	
	| bodyAddress |
	self assert: anInteger >= 0 description: 'Index must be greater than 0'.
	self assert: self numberOfSlots >= anInteger description: 'Index Out of Bounds'.

	bodyAddress := self address + self headerSize + (anInteger * self wordSize).
	
	^ self memory memoryManager unsignedByteAt: bodyAddress + self wordSize + (0 - 1) 
	
]
