Class {
	#name : #CCodeGeneratorTheoGlobalStructure,
	#superclass : #CCodeGeneratorGlobalStructure,
	#category : #VMMakerTheo
}

{ #category : #'as yet unclassified' }
CCodeGeneratorTheoGlobalStructure >> CFunctionAsSelector [

 ^  #(#memcpy:_:_: 
		#sizeof:
		#getenv:
		#free:
		#strlen:
		#log
		#mod:f:
		#sin
		#atan
		#ld:exp:
		#sqrt
		#exp
		#me:ms:et:
		#f:open:
		#putchar:
		#fflush
		#strncmp:_:_: 
		#printf:
		#malloc:
		#strcpy:_:
		#strcat:_:
		#strncpy:_:_:
		#memmove:_:_:
		#c:alloc:
		#re:alloc:
		#strcmp:
		#long:jmp:
		#getchar
		#setjmp:
		#alloca:
		#f:printf:
		#fr:exp:
		#time:
		)
]

{ #category : #'C code generator' }
CCodeGeneratorTheoGlobalStructure >> emitCCodeAsFunctionCallOn: aStream level: level method: aMethod [
	"Translate this message send into a C function call"

	aMethod selector == #break
		ifTrue: [ aStream nextPutAll: '/* send of break elided */'.
			^ aMethod ].
	"self haltIf: [ (self cFunctionNameFor: aMethod selector) includesSubstring:  'ioSetMax' ]."
	"Special case for pluggable modules. Replace messages to interpreterProxy
	 by interpreterProxy->message(..) if the message is not builtin"
	(self shouldGenerateAsInterpreterProxySend: aMethod)
		ifTrue: [ (self noteUsedPluginFunction: aMethod selector)
				ifTrue: [ aStream nextPutAll: 'interpreterProxy->' ] ].
	aStream
		nextPutAll: (self cFunctionNameFor: aMethod selector);
		nextPut: $(.

	"Only include the receiver as the first argument in certain cases.
	 The receiver is always included if it is an expression.
	 If it is a variable:
		 If the vmClass says it is an implicit variable, don't include it.
		 If the variable is 'self' and the method being called is not in
		 the method set (i.e. it is some external code), don't include it."
	(aMethod shouldExcludeReceiverAsFirstArgument: self)
		ifFalse: [ (aMethod receiver structTargetKindIn: self) == #struct
				ifTrue: [ aStream nextPut: $& ].
			aMethod receiver emitCCodeOn: aStream level: level generator: self.
			(aMethod args isNotEmpty or: [self nonUnarySelector includes: aMethod selector])
				ifTrue: [ aStream nextPutAll: ', ' ]  ].
	aMethod args
		do:
			[ :arg | arg emitCCodeAsArgumentOn: aStream level: level generator: self ]
		separatedBy: [ aStream
				nextPut: $,;
				space ].
	(self selectorsToExclude includes: aMethod selector)
		ifFalse: [ aMethod args
				ifNotEmpty: [ aStream
						nextPut: $,;
						space ].
			(TVariableNode new setName: #self)
				emitCCodeAsArgumentOn: aStream
				level: level
				generator: self ].
	aStream nextPut: $).
	"self haltIf: [ aStream contents includesSubstring: 'fetchFloatAtinto']."
]

{ #category : #'C code generator' }
CCodeGeneratorTheoGlobalStructure >> emitCFunctionPrototypeForMethod: aMethod isPrototype: isPrototype onStream: aStream [
	| args declarations |
	args := aMethod args copy.
	declarations := aMethod declarations copy.
	(self selectorExcludedForFunctionPrototype includes: aMethod selector)
		ifFalse: [ args add: #self.
			declarations at: #self put: 'struct foo * self' ].
	args
		do: [ :arg | 
			aStream
				nextPutAll: (declarations at: arg ifAbsent: [ #sqInt , ' ' , arg ]) ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $)
]

{ #category : #'C code generator' }
CCodeGeneratorTheoGlobalStructure >> emitCFunctionPrototypes: methodList on: aStream [ 
	"Store prototype declarations for all non-inlined methods on the given stream.
	 Add a define for a NoDbgRegParms attribute for static functions used for debugging.
	 gcc and other compilers will use non-standard calling conventions for static functions
	 when optimizing.  The optimization can render the functions unusable in gdb.  The sqConfig.h
	 file for the platform should define PlatformNoDbgRegParms suitably for the platform's
	 compiler, if the compiler can be persuaded not to generate such functions.
	 Add a define for a NeverInline attribute that tells the compiler never to inline functions
	 with the attribute.  We mark functions we want to observe in a profiler as NeverInline.
	 The sqConfig.h file for the platform should define NeverInline suitably for the platform's
	 compiler, if the compiler can be persuaded not to inline certain functions."
	aStream cr; nextPutAll: '/*** Function Prototypes ***/'; cr.
	vmClass ifNotNil:
		[NoRegParmsInAssertVMs ifTrue:
			[aStream nextPutAll: '\\#if !PRODUCTION && defined(PlatformNoDbgRegParms)\# define NoDbgRegParms PlatformNoDbgRegParms\#endif' withCRs.
			 aStream nextPutAll: '\\#if !defined(NoDbgRegParms)\# define NoDbgRegParms /*empty*/\#endif\\' withCRs].
		 aStream nextPutAll: '\\#if !defined(NeverInline)\# define NeverInline /*empty*/\#endif\\' withCRs.
		aStream nextPutAll: 'struct foo;';cr;
		nextPutAll: 'typedef struct ModuleEntry ModuleEntry;';cr;cr.].
	(methodList select: [:m| m isRealMethod and: [self shouldGenerateMethod: m]]) do:
		[:m |
		vmClass ifNotNil:
			[(NoRegParmsInAssertVMs and: [m export not and: [m isStatic and: [m args notEmpty]]]) ifTrue:
				[m addFunctionAttribute: 'NoDbgRegParms'].
			 m inline == #never ifTrue:
				[m addFunctionAttribute: 'NeverInline']].
		m emitCFunctionPrototype: aStream generator: self].
	aStream cr
]

{ #category : #'C code generator' }
CCodeGeneratorTheoGlobalStructure >> emitCMacros: methodList on: aStream [ 
	"Store the global variable declarations on the given stream.  Answer any constants used in the macros."
	| usedConstants |
	macros isEmpty ifTrue: [^#()].
	aStream cr; nextPutAll: '/*** Macros ***/'; cr.
	usedConstants := Set new.
	(methodList reject: [:m| m isRealMethod]) do:
		[:m |
		m definedAsMacro ifTrue:
			[ | macroDefinition |
			macroDefinition := (macros at: m selector) trimBoth.
			(macroDefinition beginsWith: '()')
				ifTrue: [ macroDefinition := '(self)', (macroDefinition allButFirst: 2) ]
				ifFalse:[ macroDefinition := String streamContents: [:s| 
						s << (macroDefinition first: (macroDefinition indexOf: $)) - 1).
						s << ', self'.
						s << (macroDefinition last: (macroDefinition size - (macroDefinition indexOf: $)) + 1)).
						]].
			(macroDefinition endsWith: '()')	
				ifTrue:[macroDefinition := (macroDefinition allButLast: 1), 'self)'].
			aStream
				nextPutAll: '#define ';
				nextPutAll:(self cFunctionNameFor: m selector);
				nextPutAll: macroDefinition; cr.
			 m compiledMethod literalsDo:
				[:lit|
				(lit isVariableBinding and: [(macros at: m selector) includesSubstring: lit key]) ifTrue:
					[usedConstants add: lit key]]]].
	aStream cr.
	^usedConstants
]

{ #category : #'C code generator' }
CCodeGeneratorTheoGlobalStructure >> emitCVariablesOn: aStream [
	"Store the global variable declarations on the given stream.
	 Break logic into vars for structure and vars for non-structure."
	| structure nonstruct |

	structure := WriteStream on: (String new: 32768).
	nonstruct := WriteStream on: (String new: 32768).

	aStream nextPutAll: '/*** Variables ***/'; cr.
	structure
		nextPutAll: '#if SQ_USE_GLOBAL_STRUCT'; cr;
		nextPutAll: '# define _iss /* define in-struct static as void */'; cr;
		nextPutAll: 'static struct foo {'; cr;
		nextPutAll: '#else'; cr;
		nextPutAll: '# define _iss static'; cr;
		nextPutAll: '#endif'; cr.
	self buildSortedVariablesCollection do:
		[ :var | | decl varString inStruct target |
		target := (inStruct := self placeInStructure: (varString := var asString)) 
					ifTrue: [structure]
					ifFalse: [nonstruct].
		decl := variableDeclarations at: varString ifAbsent: ['sqInt ' , varString].
		decl first == $# "support cgen var: #bytecodeSetSelector declareC: '#define bytecodeSetSelector 0' hack"
			ifTrue:
				[target nextPutAll: decl; cr]
			ifFalse:
				[self isGeneratingPluginCode
					ifTrue:
						[varString = 'interpreterProxy'
							ifTrue: "quite special..."
								[
								self preDeclareInterpreterProxyOn: target]
							ifFalse: [target nextPutAll: 'static ']]
					ifFalse:
						[(vmClass mustBeGlobal: varString) ifFalse:
							[target nextPutAll: (inStruct ifTrue: ['_iss '] ifFalse: ['static '])]].
				target nextPutAll: decl; nextPut: $;; cr]].
	structure
		nextPutAll: '_iss void (*primitiveFunctionPointer)();';cr;
		nextPutAll: '#undef _iss'; cr;
		nextPutAll: '#if SQ_USE_GLOBAL_STRUCT'; cr;
		nextPutAll: ' } fum;'; cr;
		nextPutAll: ' #if SQ_USE_GLOBAL_STRUCT_REG';cr;
		nextPutAll: '# define DECL_MAYBE_SQ_GLOBAL_STRUCT /* using a global reg pointer */'; cr;
		nextPutAll: '# define DECL_MAYBE_VOLATILE_SQ_GLOBAL_STRUCT /* using a global reg pointer */'; cr;
		nextPutAll:'#else';cr;
		nextPutAll: '# define DECL_MAYBE_SQ_GLOBAL_STRUCT register struct foo * foo = &fum;'; cr;
		nextPutAll: '# define DECL_MAYBE_VOLATILE_SQ_GLOBAL_STRUCT volatile register struct foo * foo = &fum;'; cr;
		nextPutAll: '#endif';cr;
		nextPutAll: 'int numberOfImage;'; cr;
		nextPutAll: 'struct foo * all_threads_global;'; cr;
		nextPutAll: 'pthread_t * thread_id;'; cr;
		nextPutAll: '# define GIV(interpreterInstVar)  self->interpreterInstVar'; cr;
		nextPutAll: '#else'; cr;
		nextPutAll: '# define DECL_MAYBE_SQ_GLOBAL_STRUCT /* oh, no mr bill! */'; cr;
		nextPutAll: '# define DECL_MAYBE_VOLATILE_SQ_GLOBAL_STRUCT /* oh no, mr bill! */'; cr;
		nextPutAll: '# define GIV(interpreterInstVar) interpreterInstVar'; cr;
		nextPutAll: '#endif'; cr.

	"if the machine needs the fum structure defining locally, do it now; global register users don't need that, but DO need some batshit insane C macro fudging in order to convert the define of USE_GLOBAL_STRUCT_REG into a simple string to use in the asm clause below. Sigh."
	structure
		nextPutAll: '#if SQ_USE_GLOBAL_STRUCT'; cr;
		nextPutAll: '#if SQ_USE_GLOBAL_STRUCT_REG';cr;
		nextPutAll: '#define fooxstr(s) foostr(s)'; cr;
		nextPutAll: '#define foostr(s)  #s'; cr;
		nextPutAll: 'register struct foo * foo asm(fooxstr(USE_GLOBAL_STRUCT_REG));'; cr;
		nextPutAll: '#else'; cr;
		nextPutAll: 'static struct foo * foo = &fum;'; cr;
		nextPutAll: '#endif'; cr;
		nextPutAll: '#endif'; cr.

	aStream
		nextPutAll: structure contents;
		nextPutAll: nonstruct contents;
		cr
]

{ #category : #'C code generator' }
CCodeGeneratorTheoGlobalStructure >> generatePerform: msgNode on: aStream indent: level [
	"Generate the C code for this message onto the given stream."

	self emitCExpression: msgNode args first on: aStream.
	aStream nextPut: $(.
	(msgNode args copyFrom: 2 to: msgNode args size)
		do: [ :arg | self emitCExpression: arg on: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	msgNode args first value = #isScavengeSurvivor:
		ifTrue: [ msgNode args size > 1
				ifTrue: [ aStream nextPutAll: ', ' ].
			aStream nextPutAll: 'self' ].
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
CCodeGeneratorTheoGlobalStructure >> nonUnarySelector [

 ^  #(#highBit
		#isFree
		)
]

{ #category : #'C code generator' }
CCodeGeneratorTheoGlobalStructure >> placeInStructure: var [
	"See if we should put this array into a structure.
	The variables listed are hardcoded as C in the interpreter thus they don't get resolved via TVariableNode logic.
	Also let's ignore variables that have special definitions that require initialization, and the function def which has problems."

	| check |
	check := variableDeclarations at: var ifAbsent: [''].
	(var includesSubstring: 'primitiveFunctionPointer') ifTrue: [^false].
	(var includesSubstring: 'primitiveTable') ifTrue: [^true].
	(var includesSubstring: 'externalPrimitiveTable') ifTrue: [^true]. "externalPrimitiveTable"
	(check includes: $=) ifTrue: [^false].
	(check includes: $() ifTrue: [^false].
	(check includesSubstring: 'static') ifTrue: [^false].
	(check includesSubstring: 'volatile') ifTrue: [^false].

	^(vmClass mustBeGlobal: var) not
]

{ #category : #'as yet unclassified' }
CCodeGeneratorTheoGlobalStructure >> selectorExcludedForCommodities [

 ^  #(
		#error: 
		#warning: 
		#show:Sur:fa:ce:Fn: "special case function pointer"
		#odd 
		#assert:
		#asserta:
		#assert:l:
		#assert:al:
		#assert:fl:
		#eassert:
		#pointerForOop: "sqMemoryAccess"
		#oopForPointer:
		#longAtPointer:put:
		#byteAtPointer:
		#longAt:
		#byteAt:
		#longAt:put:
		#longAtPointer:
		#fetchFloatAt:into:
		#long64At:
		#shortAt:
		#shortAt:put:
		#long64At:put:
		#byteAt:put:
		#intAt:
		#intAt:put:
		#long32At:
		#long32At:put:
		#storeFloatAt:from:
		#ioExitWithErrorCode: "utils.c"
		#imageName:PutLength:
		#imageName:GetLength:
		#vmPath:GetLength:
		#imageNamePut:Length:
		#imageNameGet:Length:
		#vmPathGet:Length:
		#clipboardRead:Into:At: "nullDisplay.c"
		#clipboardWrite:From:At:
		#ioDisablePowerManager:
		#crashInThisOrAnotherThread:
		#ioBeDisplay:width:height:depth:
		#ioNoteDisplayChanged:width:height:depth:
		#ioGetNextEvent:
		#ioSetInputSemaphore: 
		#ioSetFullScreen:
		#ioSetWindowWidth:Height:
		#ioSetWindowLabel:OfSize:
		#ioHasDisplayDepth:
		#ioSetLogDirectory:OfSize:
		#ioShow:D:i:s:p:l:a:y:
		#ioNewProfileSamplesInto:
		#ioNewProfile:Status:
		#doSignalExternalSemaphores: "sqExternalSemaphore"
		#signalSemaphoreWithIndex:
		#ioSetMaxExtSemTableSize:
		#ioHeartbeatFrequency: "***heartbeat.c"
		#ioSetHeartbeatMilliseconds:
		#ioHeartbeatFrequency:
		"#ioRelinquishProcessorForMicroseconds:"
		#ioGetClockLogSize:Usecs:Idx:Msecs:Idx:
		#sqAllocateMemorySegmentOfSize:Above:AllocatedSizeInto: "memoryUnix.c"
		#sqDeallocateMemorySegmentAt:OfSize:
		#allocateMemory:Minimum:ImageFile:HeaderSize:
		#unableToReadImageError
		#insufficientMemoryAvailableError
		#browserPluginReturnIfNeeded
		#mprotect:_:_:
		) , self selectorExcludedForFunctionPrototype 
]

{ #category : #'as yet unclassified' }
CCodeGeneratorTheoGlobalStructure >> selectorExcludedForFunctionPrototype [

 ^ 	#(#readableFormat:
	#sigset:jmp:
	#newGIV
	#setNumberOfImage:
	#getNumberOfImage
	#initAllGlobalsStruct
	#growAllGlobalsStruct:
	#loadAndExecute:
	#setMyCurrentThread:_:
	#mutexLock:andCond:
	)	"#( sqVirtualMachine.c
		#fetchInteger:ofObject:
		#floatValueOf:
		#storeInteger:ofObject:withValue:
		#addIdleUsecs:
		#checkedIntegerValueOf:
		#sigset:jmp:
		#fetchFloat:ofObject:
		#pop:
		#pushInteger:
		
		#readableFormat:
		#forceInterruptCheckFromHeartbeat
		#ioUTCMicroseconds
		#forceInterruptCheck)"
]

{ #category : #'as yet unclassified' }
CCodeGeneratorTheoGlobalStructure >> selectorsToExclude [

 ^ self CFunctionAsSelector, self selectorExcludedForCommodities 
]
