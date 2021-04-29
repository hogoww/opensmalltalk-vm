Class {
	#name : #VMSpurTreeAllocationWithBigNodesTest,
	#superclass : #VMSpurInitializedOldSpaceTest,
	#instVars : [
		'sizesInBreadthFirstOrder',
		'chunkAddresses'
	],
	#category : #'VMMakerTests-MemoryTests'
}

{ #category : #vmaccessing }
VMSpurTreeAllocationWithBigNodesTest >> addressOfChunkOf: aSize [

	^ chunkAddresses at: aSize
]

{ #category : #running }
VMSpurTreeAllocationWithBigNodesTest >> setUp [
	<var: #interpreter type: #VMClass>
	<var: #memory type: #VMClass>
	"This is an alternate setUp using an image to correctly initialize memory/interpreter.
	Currently not used by default, as some tests still fails, but is usable.
	For example, we could test that all test are working on both a specific setup, and image load one.
	Or we could design tests using the image setUp, which should have everything ready to use, and do the specific on after, to refine the requirements of a setUp for a test."

	self inSmalltalk: [
		
		interpreter := self newInterpreter 
			pluginList: { } ; yourself.
		stackBuilder := VMStackBuilder new
			interpreter: interpreter; 
			memory: memory;
			yourself.
				
		methodBuilder := VMMethodBuilder new
			interpreter: interpreter; 
			memory: memory;
			yourself.
		].
		
	"You currently have to setup the path by hand, I do not rememeber/know how to get the directory from a repository, to do a correct relative path
	Sorry :3"
	self loadPharoImage: 'tempConversion-64.image'.
	interpreter initStackPages.
	interpreter loadInitialContext.
	
	objectHeaderSize := 8 "bytes. Always.".
	emptyObjectSize := objectHeaderSize + 8 "minimum required single empty slot, to use for forwarders".
	
	newSpaceSize := memory oldSpaceStart - memory newSpaceStart.
	self setUpTree.
]

{ #category : #running }
VMSpurTreeAllocationWithBigNodesTest >> setUpTree [

	" Allocate a tree that has a large child large enough so a remainder could still be larger than the root
	          2048
	          /    \
	      1024     6144
	"
	| parent childNumber sizes |
	
	chunkAddresses := Dictionary new.
	sizes := #(1024 2048 6144).
	sizes do: [ :size |
		chunkAddresses at: size put: (memory allocateOldSpaceChunkOfBytes: size)
	].
	"Allocate the rest of the memory so it does not bother our test."
	memory allocateOldSpaceChunkOfBytes: memory totalFreeListBytes.

	sizesInBreadthFirstOrder := #( 2048 1024 6144 ).
	
	sizesInBreadthFirstOrder do: [ :e |
		memory freeChunkWithBytes: e at: (chunkAddresses at: e) ].
	
	
	parent := self freeTreeRootOop.
	childNumber := 1.
	self assert: (memory bytesInObject: parent) equals: (sizesInBreadthFirstOrder at: childNumber).
	self assert: (memory bytesInObject: (self smallerNodeOf: parent)) equals: (sizesInBreadthFirstOrder at: childNumber * 2).
	self assert: (memory bytesInObject: (self largerNodeOf: parent)) equals: (sizesInBreadthFirstOrder at: childNumber * 2 + 1).
]

{ #category : #vmaccessing }
VMSpurTreeAllocationWithBigNodesTest >> sizeOfChildInBreadthFirstOrder: anInteger [ 

	^ sizesInBreadthFirstOrder at: anInteger
]

{ #category : #tests }
VMSpurTreeAllocationWithBigNodesTest >> test01LargeLeftoverSmallerThanRootShouldBeInsertedInSmaller [

	memory allocateOldSpaceChunkOfBytes: 16.
	
	 "Allocating 16 should choose the smaller 1024 node and leave a remainder of 1008 as smaller"
	self assert: (memory bytesInObject: (self smallerNodeOf: self freeTreeRootOop)) equals: 1008
]

{ #category : #tests }
VMSpurTreeAllocationWithBigNodesTest >> test02LargeLeftoverSmallerThanLargerShouldBeInsertedInLarger [

	memory allocateOldSpaceChunkOfBytes: (self sizeOfChildInBreadthFirstOrder: 1) + 16.
	
	"Allocating root + 16 should choose the larger 6144 node and leave a remainder of 4080 as larger"
	self assert: (memory bytesInObject: (self largerNodeOf: self freeTreeRootOop)) equals: 4080
]

{ #category : #tests }
VMSpurTreeAllocationWithBigNodesTest >> test03LargeLeftoverSmallerThanRootShouldBeInsertedInSmaller [

	memory allocateOldSpaceChunkOfBytes: (self sizeOfChildInBreadthFirstOrder: 1) * 2 + 16.

	"Allocating root * 2 + 16 should choose the larger 6144 node and leave a remainder of 2032 as smaller"
	self assert: (memory bytesInObject: (self largerNodeOf: (self smallerNodeOf: self freeTreeRootOop))) equals: 2032
]
