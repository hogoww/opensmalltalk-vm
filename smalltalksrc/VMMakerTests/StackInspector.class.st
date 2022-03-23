Class {
	#name : #StackInspector,
	#superclass : #SpPresenter,
	#instVars : [
		'interpreter',
		'stack',
		'frameContainer',
		'frameSeparator',
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
	interpreter objectMemory memoryManager memoryMap do: [ :memoryRegion | | box |
		box := RSBox new.
		box model: memoryRegion.
		box popup.
		canvas add: box ].
	RSGridLayout new
		gapSize: 0;
		on: canvas nodes.
	canvas when: RSExtentChangedEvent do: [ 
		canvas
			zoomToFit;
			signalUpdate ].
	memoryRepresentation canvas: canvas
]

{ #category : #initialization }
StackInspector >> connectPresenters [

	stack whenSelectionChangedDo: [ :selection |
		selection isEmpty ifFalse: [ self selectFramePart: selection selectedItem ] ].
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
	| stackBuilder stackFramesComponent items |
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
