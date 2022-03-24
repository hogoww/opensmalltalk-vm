Class {
	#name : #StackInspector,
	#superclass : #SpPresenter,
	#instVars : [
		'interpreter',
		'stack',
		'frameContainer',
		'memoryRepresentation'
	],
	#category : #'VMMakerTests-inspectors'
}

{ #category : #layout }
StackInspector class >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: #stack;
		add: #memoryRepresentation;
		yourself
]

{ #category : #'instance creation' }
StackInspector class >> openOn: anInterpreter [

	^ self new
		  interpreter: anInterpreter;
		  open
]

{ #category : #initialization }
StackInspector >> buildMemory [

	| canvas |
	canvas := RSCanvas new.
	interpreter objectMemory 
		allObjectsDo: [ :o | | box |
			box := RSBox new.
			box model: o.
			box popup.
			box paint: (self objectColor: o).
			canvas add: box 
			].
	RSGridLayout new
		gapSize: 1;
		on: canvas nodes.
	canvas when: RSExtentChangedEvent do: [ 
		canvas
			zoomToFit;
			signalUpdate ].
	memoryRepresentation canvas: canvas
]

{ #category : #testing }
StackInspector >> coloredModels [
	^ memoryRepresentation canvas nodes reject: [ :aNode | aNode paint = self defaultMemoryColor ]
]

{ #category : #initialization }
StackInspector >> connectPresenters [

	stack whenSelectionChangedDo: [ :selection |
		selection isEmpty ifFalse: [ self selectFramePart: selection selectedItem ] ].
]

{ #category : #initialization }
StackInspector >> defaultMemoryColor [
	^ Color lightGray
]

{ #category : #accessing }
StackInspector >> frameContainer [

	^ frameContainer
]

{ #category : #accessing }
StackInspector >> frameContainer: anObject [

	frameContainer := anObject
]

{ #category : #display }
StackInspector >> freeOopColor [ 
	^ Color lightGray
]

{ #category : #display }
StackInspector >> initialExtent [ 

	^ 1000@1000
]

{ #category : #initialization }
StackInspector >> initializePresenters [
	
	stack := self newTable.
	stack
		addColumn: (SpStringTableColumn evaluated: [ :aFrame | aFrame ]).
	
	memoryRepresentation := SpRoassalPresenter new.

	"stepButton := self newButton.
	stepButton label: 'Step'.
	
	disassembleAtPCButton := self newButton.
	disassembleAtPCButton label: 'Disassemble at PC'" 

]

{ #category : #accessing }
StackInspector >> interpreter [

	^ interpreter
]

{ #category : #accessing }
StackInspector >> interpreter: anObject [

	interpreter := anObject
]

{ #category : #initialization }
StackInspector >> memoryRepresentation [
	^ memoryRepresentation
]

{ #category : #display }
StackInspector >> objectColor: anOop [
	^ (interpreter objectMemory isFreeOop: anOop)
		ifTrue: [ self freeOopColor ]
		ifFalse: [ self usedOopColor ] 
	
]

{ #category : #showing }
StackInspector >> open [

	"	self refreshRegisters.
	self refreshInstructions.
"

	self refreshStack.
	self buildMemory.

	super open
]

{ #category : #display }
StackInspector >> refreshStack [
	| stackBuilder stackFramesComponent items frameSeparator |
	frameSeparator := '###################################'.
	stackBuilder:= VMStackBuilder from: interpreter.
	stackFramesComponent := stackBuilder frames collect: [ :f | f allFrameParts ].
	items := OrderedCollection new.
	items add: frameSeparator. "Kind of base frame for now"
	stackFramesComponent do: [ :stackFrame | items addAll: stackFrame ] separatedBy: [ items add: frameSeparator ].
	stack items: items
]

{ #category : #initialization }
StackInspector >> selectFramePart: framePart [
	"should be only oops in that array. currently incomplete"
	| canvas memoryRegion |
	(#(method context ) includes: framePart key) ifFalse:[ ^ self ].
	canvas := memoryRepresentation canvas.
	memoryRegion := interpreter objectMemory memoryManager regionForAddress: framePart value. 
	(canvas nodes detect:[ :aNode| aNode model = memoryRegion ]) paint: Color red.
	canvas signalUpdate
]

{ #category : #accessing }
StackInspector >> stack [

	^ stack
]

{ #category : #accessing }
StackInspector >> stack: anObject [

	stack := anObject
]

{ #category : #display }
StackInspector >> usedOopColor [ 
	^ Color green
]
