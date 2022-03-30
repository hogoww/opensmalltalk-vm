Extension { #name : #StackInterpreter }

{ #category : #'*VMMaker-Tools' }
StackInterpreter >> stack [

	framePointer = nil
		ifTrue: [ ^ #() ].
	
	^ (VMStackFrame virtualMachine: self fp: framePointer) stack
]
