Extension { #name : #RBProgramNode }

{ #category : #'*VMMakerCompatibilityForPharo6-C translation' }
RBProgramNode >> asTranslatorNodeIn: aTMethod [
	"Answer a TParseNode subclass equivalent of me"
	"Also puts my TNode equivalent as a property of the initial node in #tnodeEquivalent"
	self subclassResponsibility
]

{ #category : #'*VMMakerCompatibilityForPharo6-C translation' }
RBProgramNode >> commentOrNil [
	
	| comments |
	comments := self propertyAt: #comments ifAbsent: [ ^ nil ].
	^ comments collect: #contents
]

{ #category : #'*VMMakerCompatibilityForPharo6-testing' }
RBProgramNode >> isBlockNode [
	^false
]

{ #category : #'*VMMakerCompatibilityForPharo6-testing' }
RBProgramNode >> isConstantNumber [  "Overridden in RBLiteralValueNode"
	^false
]

{ #category : #'*VMMakerCompatibilityForPharo6-testing' }
RBProgramNode >> isNodeNil [
	^false
]

{ #category : #'*VMMakerCompatibilityForPharo6-testing' }
RBProgramNode >> isVariableNode [
	^false
]

{ #category : #'*VMMakerCompatibilityForPharo6-C translation' }
RBProgramNode >> missingCommentNeededForCTranslation [
	"So far the RBProgramNode hierarchy omits/elides comments :-("
	^nil
]

{ #category : #'*VMMakerCompatibilityForPharo6-C translation' }
RBProgramNode >> returns: aNode [
	"hackish to annotate the node with its TNode equivalent, while keeping the initial code readable "
	self propertyAt: #tnodeEquivalent put: aNode.
	^ aNode
]
