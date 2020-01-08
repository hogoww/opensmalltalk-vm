Extension { #name : #RBVariableNode }

{ #category : #'*VMMakerCompatibilityForPharo6-C translation' }
RBVariableNode >> asTranslatorNodeIn: aTMethod [
	"Answer a TParseNode subclass equivalent of me"
	name = 'true' ifTrue: [^ self returns: (TConstantNode new setValue: true)].
	name = 'false' ifTrue: [^ self returns: (TConstantNode new setValue: false)].
	^ self returns: (TVariableNode new setName: name)
]

{ #category : #'*VMMakerCompatibilityForPharo6-testing' }
RBVariableNode >> isVariableNode [
	^true
]

{ #category : #'*VMMakerCompatibilityForPharo6-accessing' }
RBVariableNode >> key [
	^name
]
