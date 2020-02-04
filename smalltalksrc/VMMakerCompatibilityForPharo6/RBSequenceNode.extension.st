Extension { #name : #RBSequenceNode }

{ #category : #'*VMMakerCompatibilityForPharo6' }
RBSequenceNode >> addSelfReturnForVM [
	| node |
	self lastIsReturn
		ifTrue: [ ^ self statements last ].
	node := RBReturnNode value: (RBSelfNode new).
	^ self addNode: node
]

{ #category : #'*VMMakerCompatibilityForPharo6-C translation' }
RBSequenceNode >> asTranslatorNodeIn: aTMethod [ 
	"Answer a TParseNode subclass equivalent of me"
	| statementList |
	statementList := OrderedCollection new.
	statements do:
		[:s | | newS |
		 newS := s asTranslatorNodeIn: aTMethod.
		 "inline the statement list returned when a CascadeNode is translated and/or when ifNotNil: is transformed"
		 newS isStmtList
			ifTrue:  [statementList addAll: newS statements]
			ifFalse: [statementList add: newS]].
	^ self returns: (TStmtListNode new
		setArguments: (parent isMethod 
		"Because arguments of a method are in TMethod, not in the StatementList"
							ifTrue: [#()]
							ifFalse: [parent arguments asArray collect: [:arg | arg name ]])
		statements: statementList;
		comment: self commentOrNil)
]
