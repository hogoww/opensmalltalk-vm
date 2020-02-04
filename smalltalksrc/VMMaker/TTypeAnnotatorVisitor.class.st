Class {
	#name : #TTypeAnnotatorVisitor,
	#superclass : #TWalkerVisitor,
	#instVars : [
		'tMethod',
		'ccg'
	],
	#category : #'VMMaker-Translation to C'
}

{ #category : #accessing }
TTypeAnnotatorVisitor >> ccg [
	^ ccg
]

{ #category : #accessing }
TTypeAnnotatorVisitor >> ccg: aCCodeGenerator [
	ccg := aCCodeGenerator
]

{ #category : #accessing }
TTypeAnnotatorVisitor >> tMethod [
	^ tMethod
]

{ #category : #accessing }
TTypeAnnotatorVisitor >> tMethod: aTMethod [
	tMethod := aTMethod
]

{ #category : #visiting }
TTypeAnnotatorVisitor >> typeThatNode: aNode [
	| type  |

	type := ccg typeFor: aNode in: tMethod.
		
	aNode propertyAt: ASTCTypeAnnotator property put: type 
]

{ #category : #visiting }
TTypeAnnotatorVisitor >> visitTAssignmentNode: aTAssignmentNode [
	super visitTAssignmentNode: aTAssignmentNode.
	aTAssignmentNode typeThatNode: aTAssignmentNode.
	^ aTAssignmentNode
]

{ #category : #visiting }
TTypeAnnotatorVisitor >> visitTMethodNode: aTMethodNode [
]
