"
I represent a frame in a stack which is in a page.

I am representing a frame.
I am able to push myself on the interpreter stack's provided when I'm asked to do so.
I only know my own state.
I have a specific inspector

I am currently used only in the #VMStackBuilder, which configures my instances, and is asking me to push myself on the interpreter.


API
I required an interpreter/memory to be able to initialize myself, so initialization is done using #initializeWithInterpreter:.
Configuring is done by using accessing protocol's methods.
When ready, tell me to push myself with #pushYourself.


 
Internal Representation and Key Implementation Points.

Unfinished comment.

    Instance Variables
	interpreter:		<Interpreter> Stack or Cog, it shouldn't matter. Allows interaction with the current *simulation* interpreter
	memory:		<SpurMemorySomething> Same as interpreter, but for memory *simulation* version

Configuring of the frame.
	args:		<Object>

	context:		<Object>
	instructionPointer:		<Object>
	method:		<Object>
	receiver:		<Object>
	senderContext:		<Object>

	temps:		<Object>
	stack:		<Object>

	This IVs are present solely for inspection purpose.	
	flags: <SmallInteger?> This is calculated by the VM, and should not be set by hand.
	callerFP:		<VMFrambeBuilder?> When the stack builder is pushing several frames, it links them.
			When it links them, it gives the last frame the previous caller Frame, for debug purpose.
"
Class {
	#name : #VMFrameBuilder,
	#superclass : #Object,
	#instVars : [
		'method',
		'context',
		'receiverOop',
		'temps',
		'stack',
		'memory',
		'interpreter',
		'instructionPointer',
		'callerFrame',
		'flags',
		'previousFrameArgsSize',
		'argumentSize'
	],
	#category : #'VMMakerTests-Builders'
}

{ #category : #'as yet unclassified' }
VMFrameBuilder class >> slotsNamesToIgnore [
	^ #( memory interpreter callerFrame )
]

{ #category : #inspect }
VMFrameBuilder >> adaptAddressToMemory: anInteger [
	<doNotGenerate>
	anInteger = memory nilObject ifTrue: [ ^ #nilObject ].
	anInteger = memory trueObject ifTrue: [ ^ #trueObject ].
	anInteger = memory falseObject ifTrue: [ ^ #falseObject ].
	^ anInteger
	"^ memory integerObjectOf: anInteger"
]

{ #category : #inspect }
VMFrameBuilder >> adaptAddressToMemoryIfInteger: anAssociation [	
	<doNotGenerate>
	anAssociation value isInteger
		ifTrue: [ anAssociation value: (self adaptAddressToMemory: anAssociation value) ]

]

{ #category : #accessing }
VMFrameBuilder >> argumentSize [
	^ argumentSize
]

{ #category : #accessing }
VMFrameBuilder >> argumentSize: anObject [
	argumentSize := anObject
]

{ #category : #accessing }
VMFrameBuilder >> beSuspendedAt: anInstructionPointer [
	instructionPointer := anInstructionPointer 
]

{ #category : #support }
VMFrameBuilder >> cCode: aBlock [
	<doNotGenerate>
]

{ #category : #support }
VMFrameBuilder >> cCode: something inSmalltalk: aBlock [
	<doNotGenerate>
	^ aBlock value
]

{ #category : #accessing }
VMFrameBuilder >> callerFrame [
	^ callerFrame
]

{ #category : #accessing }
VMFrameBuilder >> callerFrame: aFrame [ 
	callerFrame := aFrame
]

{ #category : #accessing }
VMFrameBuilder >> context [
	^ context
]

{ #category : #accessing }
VMFrameBuilder >> context: anObject [
	context := anObject
]

{ #category : #accessing }
VMFrameBuilder >> flags [
	^ flags
]

{ #category : #accessing }
VMFrameBuilder >> flags: anObject [
	flags := anObject
]

{ #category : #inspect }
VMFrameBuilder >> gtInspectorItemsIn: composite [
	<doNotGenerate>
	<gtInspectorPresentationOrder: 1>

	| values |
	values :={
		#stack -> stack.
		#temps -> temps.
		#receiver -> receiverOop.
		#context -> context.
		#flags ->  flags.
		#method ->  method.
		#'caller''s method ip' -> nil.
		#'callerFP' -> callerFrame.
"		#arguments -> args."
		 }.
	^ composite fastTable
		title: 'frame';
		display: [ values ];
		column: 'names' evaluated: [ :anAssociation | 
			(anAssociation value isCollection and: [ anAssociation value isString not])
			 ifTrue: [ GTObjectPrinter asNonTruncatedTextFrom: anAssociation key -> 
					(anAssociation value asArray 
						collect:[ :each | (self adaptAddressToMemoryIfInteger: nil -> each) value ])]
			ifFalse:[  
				self adaptAddressToMemoryIfInteger: anAssociation.
					].
				GTObjectPrinter asNonTruncatedTextFrom: anAssociation ]
	

]

{ #category : #initialization }
VMFrameBuilder >> initialize [
	<var: #interpreter type: #StackInterpreterPrimitives>
	<var: #memory type: #SpurMemoryManager>
	self cCode: [
		method := memory nilObject.
		context := memory nilObject.
		receiverOop := memory nilObject.
		temps := Array new: 5 of: VMClass.
		1 to: temps size do: [ :i | temps at: i put: memory nilObject ].
		stack := Array new: 5 of: VMClass.
		1 to: stack size do: [ :i | stack at: i put: memory nilObject ].
		
		instructionPointer := memory nilObject.
		previousFrameArgsSize := 0. " set by the StackBuilder"
		argumentSize := 0 ]
]

{ #category : #initialization }
VMFrameBuilder >> initializeWithInterpreter: anInterpreter andMemory: aMemory [
	<doNotGenerate>
	<var: #interpreter type: #StackInterpreterPrimitives>
	<var: #memory type: #SpurMemoryManager>
	self cCode: [] inSmalltalk: [ 
		memory := aMemory.
		interpreter := anInterpreter.].
	method := memory nilObject.
	context := memory nilObject.
	receiverOop := memory nilObject.
	temps := Array new: 5 of: VMClass.
	1 to: temps size do: [ :i | temps at: i put: memory nilObject ].
	stack := Array new: 5 of: VMClass.
	1 to: stack size do: [ :i | stack at: i put: memory nilObject ].
	instructionPointer := memory nilObject.

	previousFrameArgsSize := 0. " set by the StackBuilder"
	argumentSize := 0.
]

{ #category : #accessing }
VMFrameBuilder >> instructionPointer [
	^ instructionPointer
]

{ #category : #accessing }
VMFrameBuilder >> interpreter [
	^ interpreter
]

{ #category : #accessing }
VMFrameBuilder >> interpreter: anObject [
	interpreter := anObject
]

{ #category : #testing }
VMFrameBuilder >> isSuspended [
	^ instructionPointer isNil
]

{ #category : #accessing }
VMFrameBuilder >> memoryAccess [
	^ memory
]

{ #category : #accessing }
VMFrameBuilder >> memoryAccess: anObject [
	memory := anObject
]

{ #category : #accessing }
VMFrameBuilder >> method [
	^ method
]

{ #category : #accessing }
VMFrameBuilder >> method: anObject [
	method := anObject
]

{ #category : #accessing }
VMFrameBuilder >> previousFrameArgsSize [
	^ previousFrameArgsSize
]

{ #category : #accessing }
VMFrameBuilder >> previousFrameArgsSize: anObject [
	previousFrameArgsSize := anObject
]

{ #category : #building }
VMFrameBuilder >> pushCurrentFramesStack [
	"push to the stack all objects in the frame stack"
	stack do: [ :oop | interpreter push: oop ].	
]

{ #category : #building }
VMFrameBuilder >> pushFlags [
	"Flags: this stack frame is single. I.e., it has no context object.
	Otherwise GC fails with an assertion looking for it in the heap"
	flags := (interpreter
			encodeFrameFieldHasContext: context ~= memory nilObject
			isBlock: false
			numArgs: previousFrameArgsSize).
	interpreter push: flags
]

{ #category : #building }
VMFrameBuilder >> pushFrame [
	interpreter push: context.
	interpreter push: receiverOop.
	
	temps do: [ :oop |  interpreter push: oop ].
]

{ #category : #building }
VMFrameBuilder >> pushYourself [
	interpreter push: method.
	self pushFlags.
	self pushFrame.
	self pushCurrentFramesStack.
		
	
	"context ~= memory nilObject
		ifTrue: [ memory
				storePointerUnchecked: 0
				ofObject: context
				withValue: (interpreter withSmallIntegerTags: page baseFP)	""SenderIndex"" ]."
				
	instructionPointer ifNotNil: [ interpreter push: instructionPointer ].
	
	^ interpreter framePointer
]

{ #category : #accessing }
VMFrameBuilder >> receiverOop [
	^ receiverOop
]

{ #category : #accessing }
VMFrameBuilder >> receiverOop: anObject [
	receiverOop := anObject
]

{ #category : #accessing }
VMFrameBuilder >> stack [
	^ stack
]

{ #category : #accessing }
VMFrameBuilder >> stack: anObject [
	stack := anObject
]

{ #category : #accessing }
VMFrameBuilder >> temps [
	^ temps
]

{ #category : #accessing }
VMFrameBuilder >> temps: anObject [
	temps := anObject
]
