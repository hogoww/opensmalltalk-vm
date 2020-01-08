Class {
	#name : #TWalkerVisitor,
	#superclass : #TVisitor,
	#category : #'VMMaker-Translation to C'
}

{ #category : #visiting }
TWalkerVisitor >> visitTAssignmentNode: aTAssignmentNode [
	aTAssignmentNode variable acceptVisitor: self.
	aTAssignmentNode value acceptVisitor: self
]

{ #category : #visiting }
TWalkerVisitor >> visitTMethodNode: aTMethodNode [
	aTMethodNode halt.
]

{ #category : #visiting }
TWalkerVisitor >> visitTReturnNode: aTReturnNode [
	aTReturnNode expression acceptVisitor: self
]

{ #category : #visiting }
TWalkerVisitor >> visitTSendNode: aTSendNode [
	aTSendNode receiver acceptVisitor: self.
	aTSendNode arguments do: [:anArg| anArg acceptVisitor: self ]
]

{ #category : #visiting }
TWalkerVisitor >> visitTStmtListNode: aTStmtListNode [
	aTStmtListNode args do: [:anArg| anArg acceptVisitor: self ].
	aTStmtListNode statements do: [:aStatement| aStatement acceptVisitor: self ]
]
