Class {
	#name : #StackInspector,
	#superclass : #SpPresenter,
	#instVars : [
		'interpreter',
		'stack',
		'frameContainer',
		'newSpace',
		'oldSpace',
		'objectInspector',
		'colorProvider'
	],
	#category : #'VMMakerTests-inspectors'
}

{ #category : #layout }
StackInspector class >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: #stack;
		add: #newSpace;
		add: #oldSpace;
		yourself
]

{ #category : #'instance creation' }
StackInspector class >> openOn: anInterpreter [

	^ self new
		  interpreter: anInterpreter;
		  open
]

{ #category : #display }
StackInspector >> boxForOop: o [
	| box |
	box := RSBox new.
	box when: RSMouseClick do:[ :rso | objectInspector inspectOop: rso shape model ].
	box model: o.
	box popup.
	box paint: (colorProvider colorForOop: o).
	^ box
]

{ #category : #initialization }
StackInspector >> buildMemorySpace: aSpace [

	| canvas iteratorSelector |
	canvas := RSCanvas new.
	iteratorSelector := aSpace = newSpace
		ifTrue: [ #allNewSpaceObjectsDo: ] 
		ifFalse: [ #allOldSpaceObjectsDo: ]. 
	interpreter objectMemory perform: iteratorSelector withArguments:{ 
		[ :o |
			canvas add: (self boxForOop: o)
			]}.

	RSGridLayout new
		gapSize: 1;
		on: canvas nodes.
		
	canvas addInteraction: RSCanvasController new.
	self setUpCanvas: aSpace canvas: canvas. 
	
]

{ #category : #accessing }
StackInspector >> colorProvider [

	^ colorProvider ifNil: [ colorProvider := DefaultColorProvider newFor: self. ]
]

{ #category : #accessing }
StackInspector >> colorProvider: anObject [

	colorProvider := anObject
]

{ #category : #testing }
StackInspector >> coloredModels [
	^ ((self memorySpaces collect: #canvas) flatCollect: #nodes) collect: [ :aNode | aNode paint ]
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
StackInspector >> initializeMissingComponents [
	self colorProvider. "Lazy initialization if no colorProvider is ready"
	objectInspector := SpurSimulatorImage onSpurSimulator: interpreter objectMemory.
	self refreshStack.
	self buildMemorySpace: newSpace.
	self buildMemorySpace: oldSpace.
]

{ #category : #initialization }
StackInspector >> initializePresenters [
	
	stack := self newTable.
	stack addColumn: (SpStringTableColumn evaluated: [ :aFrame | aFrame ]).
	
	newSpace := self instantiate: SpRoassalPresenter.
	oldSpace := self instantiate: SpRoassalPresenter.

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

{ #category : #testing }
StackInspector >> memorySpaces [
	^ { newSpace . oldSpace }
]

{ #category : #accessing }
StackInspector >> newSpace [

	^ newSpace
]

{ #category : #accessing }
StackInspector >> newSpace: anObject [

	newSpace := anObject
]

{ #category : #querying }
StackInspector >> newSpaceNodes [
	^ newSpace canvas nodes
]

{ #category : #accessing }
StackInspector >> objectInspector [

	^ objectInspector
]

{ #category : #accessing }
StackInspector >> objectInspector: anObject [

	objectInspector := anObject
]

{ #category : #accessing }
StackInspector >> oldSpace [

	^ oldSpace
]

{ #category : #accessing }
StackInspector >> oldSpace: anObject [

	oldSpace := anObject
]

{ #category : #accessing }
StackInspector >> oldSpaceNodes [
	^ oldSpace canvas nodes
]

{ #category : #showing }
StackInspector >> open [
	self initializeMissingComponents.

	super open
]

{ #category : #display }
StackInspector >> refreshStack [
	| stackBuilder stackFramesComponent items frameSeparator |
	frameSeparator := '###################################' .
	stackBuilder:= VMStackBuilder from: interpreter.
	stackFramesComponent := stackBuilder frames 
		collect: [ :f | { frameSeparator -> f } , f allFrameParts ].
	
	items := stackFramesComponent flatCollect: [ :stackFrame | stackFrame ]. 
	stack items: items
]

{ #category : #inspecting }
StackInspector >> selectAllFrame: framePart [ 
	framePart value allFrameParts do: [ :fp | self selectFramePart: fp ]
]

{ #category : #initialization }
StackInspector >> selectFramePart: framePart [
	"should be only oops in that array. currently incomplete"
	| canvas |
	(framePart value isKindOf: VMFrameBuilder) ifTrue: [ ^ self selectAllFrame: framePart ].
	(interpreter objectMemory addressCouldBeObj: framePart value) ifFalse:[ ^ self ].
	
	canvas := oldSpace canvas.
	(canvas nodes select: [ :aNode| aNode model = framePart value  ]) do: [ :n| n paint: Color red ].
	canvas signalUpdate.
	canvas := newSpace canvas.
	(canvas nodes select: [ :aNode| aNode model = framePart value  ]) do: [ :n| n paint: Color red ].
	canvas signalUpdate
]

{ #category : #initialization }
StackInspector >> setUpCanvas: aSpace canvas: canvas [

	aSpace currentCanvas
		ifNotNil: [ :aCanvas | 
			| widget |
			widget := aCanvas morph.
			widget canvas: canvas.
			canvas extent: widget extent.
			canvas signalUpdate
			 ].
	aSpace canvas: canvas
	
]

{ #category : #accessing }
StackInspector >> stack [

	^ stack
]

{ #category : #accessing }
StackInspector >> stack: anObject [

	stack := anObject
]

{ #category : #updating }
StackInspector >> updateInspector [

	self buildMemorySpace: newSpace.
	
	newSpace canvas 
		zoomToFit;
		signalUpdate.
	self buildMemorySpace: oldSpace.
	oldSpace canvas
		zoomToFit;
		signalUpdate.
]
