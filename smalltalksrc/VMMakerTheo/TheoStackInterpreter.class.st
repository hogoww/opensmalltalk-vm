Class {
	#name : #TheoStackInterpreter,
	#superclass : #StackInterpreterPrimitives,
	#classInstVars : [
		'defaultPrimitiveTable'
	],
	#category : #VMMakerTheo
}

{ #category : #translation }
TheoStackInterpreter class >> ancilliaryClasses [
	"Answer any extra classes to be included in the translation."
	^super ancilliaryClasses, { ThreadInterpreterParameter. CMutexAndCond  }
]

{ #category : #translation }
TheoStackInterpreter class >> declareCVarsIn: aCCodeGenerator [
	| vmClass |
	self class == thisContext methodClass ifFalse: [^self]. "Don't duplicate decls in subclasses"
	vmClass := aCCodeGenerator vmClass. "Generate primitiveTable etc based on vmClass, not just StackInterpreter"
	aCCodeGenerator
		addHeaderFile:'<stddef.h> /* for e.g. alloca */';
		addHeaderFile:'<setjmp.h>';
		addHeaderFile:'<wchar.h> /* for wint_t */';
		addHeaderFile:'"vmCallback.h"';
		addHeaderFile:'"sqMemoryFence.h"';
		addHeaderFile:'"dispdbg.h"';
		addHeaderFile:'<errno.h>';
		addHeaderFile: '<sys/mman.h>'
		.
	LowcodeVM ifTrue: [ aCCodeGenerator addHeaderFile:'"sqLowcodeFFI.h"'].

	vmClass declareInterpreterVersionIn: aCCodeGenerator defaultName: 'Stack'.
	aCCodeGenerator
		var: #interpreterProxy  type: #'struct VirtualMachine*'.
	aCCodeGenerator
		declareVar: #sendTrace type: 'volatile int';
		declareVar: #byteCount type: #usqInt;
		declareVar: #myCurrentThread type: 'pthread_t';
		declareVar: #mutexForFetchBytecode type:'pthread_mutex_t';
		declareVar: #step type: 'pthread_cond_t *';
		declareVar: #isStepable type: 'int';
		declareVar: #squeakModule type: 'ModuleEntry *';
		declareVar: #firstModule type: 'ModuleEntry *'
		.
		"var: #primitiveFunctionPointer type: 'void (*)()'."
		
	"These need to be pointers or unsigned."
	self declareC: #(instructionPointer method newMethod)
		as: #usqInt
		in: aCCodeGenerator.
	"These are all pointers; char * because Slang has no support for C pointer arithmetic."
	self declareC: #(localIP localSP localFP stackPointer framePointer stackLimit breakSelector)
		as: #'char *'
		in: aCCodeGenerator.
	aCCodeGenerator
		var: #breakSelectorLength
		declareC: 'sqInt breakSelectorLength = MinSmallInteger'.
	self declareC: #(stackPage overflowedPage)
		as: #'StackPage *'
		in: aCCodeGenerator.
	aCCodeGenerator removeVariable: 'stackPages'.  "this is an implicit receiver in the translated code."
	"This defines bytecodeSetSelector as 0 if MULTIPLEBYTECODESETS
	 is not defined, for the benefit of the interpreter on slow machines."
	aCCodeGenerator addConstantForBinding: (self bindingOf: #MULTIPLEBYTECODESETS).
	MULTIPLEBYTECODESETS == false ifTrue:
		[aCCodeGenerator
			removeVariable: 'bytecodeSetSelector'].
	BytecodeSetHasExtensions == false ifTrue:
		[aCCodeGenerator
			removeVariable: 'extA';
			removeVariable: 'extB'].
	aCCodeGenerator
		var: #methodCache
		declareC: 'sqIntptr_t methodCache[MethodCacheSize + 1 /* ', (MethodCacheSize + 1) printString, ' */]'.
	NewspeakVM
		ifTrue:
			[aCCodeGenerator
				var: #nsMethodCache
				declareC: 'sqIntptr_t nsMethodCache[NSMethodCacheSize + 1 /* ', (NSMethodCacheSize + 1) printString, ' */]']
		ifFalse:
			[aCCodeGenerator
				removeVariable: #nsMethodCache;
				removeVariable: 'localAbsentReceiver';
				removeVariable: 'localAbsentReceiverOrZero'].
	AtCacheTotalSize isInteger ifTrue:
		[aCCodeGenerator
			var: #atCache
			declareC: 'sqInt atCache[AtCacheTotalSize + 1 /* ', (AtCacheTotalSize + 1) printString, ' */]'].
	aCCodeGenerator
		var: #primitiveTable 
		declareC:'void (*primitiveTable[MaxPrimitiveIndex + 2 /* ', (MaxPrimitiveIndex + 2) printString, ' */])(void)'.
	aCCodeGenerator
		var: #defaultPrimitiveTable
		declareC: 'void (*defaultPrimitiveTable[MaxPrimitiveIndex + 2 /* ', (MaxPrimitiveIndex + 2) printString, ' */])(void) = ', vmClass primitiveTableString.
	vmClass defaultPrimitiveTable do:
		[:symbolOrNot|
		(symbolOrNot isSymbol
		 and: [symbolOrNot ~~ #primitiveFail]) ifTrue:
			[(aCCodeGenerator methodNamed: symbolOrNot) ifNotNil:
				[:tMethod| tMethod returnType: #void]]].
	vmClass objectMemoryClass hasSpurMemoryManagerAPI
		ifTrue:
			[aCCodeGenerator
				var: #primitiveAccessorDepthTable
				type: 'signed char'
				sizeString: 'MaxPrimitiveIndex + 2 /* ', (MaxPrimitiveIndex + 2) printString, ' */'
				array: vmClass primitiveAccessorDepthTable]
		ifFalse:
			[aCCodeGenerator removeVariable: #primitiveAccessorDepthTable].
	aCCodeGenerator
		var: #displayBits type: #'void *'.
	self declareC: #(displayWidth displayHeight displayDepth) as: #int in: aCCodeGenerator.
	aCCodeGenerator
		var: #externalPrimitiveTable
			declareC: 'void (*externalPrimitiveTable[MaxExternalPrimitiveTableSize + 1 /* ', (MaxExternalPrimitiveTableSize + 1) printString, ' */])(void)';
		var: #interruptCheckChain
			declareC: 'void (*interruptCheckChain)(void) = 0';
		var: #showSurfaceFn
			declareC: 'int (*showSurfaceFn)(sqIntptr_t, int, int, int, int)';
		var: #jmpBuf
			declareC: 'jmp_buf jmpBuf[MaxJumpBuf + 1 /* ', (MaxJumpBuf + 1) printString, ' */]';
		var: #suspendedCallbacks
			declareC: 'usqInt suspendedCallbacks[MaxJumpBuf + 1 /* ', (MaxJumpBuf + 1) printString, ' */]';
		var: #suspendedMethods
			declareC: 'usqInt suspendedMethods[MaxJumpBuf + 1 /* ', (MaxJumpBuf + 1) printString, ' */]'.

	self declareCAsUSqLong: #(nextPollUsecs nextWakeupUsecs longRunningPrimitiveGCUsecs
								longRunningPrimitiveStartUsecs longRunningPrimitiveStopUsecs
								"these are high-frequency enough that they're overflowing quite quickly on modern hardware"
								statProcessSwitch statIOProcessEvents statForceInterruptCheck
								statCheckForEvents statStackOverflow statStackPageDivorce
								statIdleUsecs)
		in: aCCodeGenerator.
	aCCodeGenerator var: #nextProfileTick type: #sqLong.
	aCCodeGenerator
		var: #reenterInterpreter
		declareC: 'jmp_buf reenterInterpreter; /* private export */'.
	LowcodeVM
		ifTrue:
			[aCCodeGenerator
				var: #lowcodeCalloutState type: #'sqLowcodeCalloutState*'.
			 self declareC: #(nativeSP nativeStackPointer shadowCallStackPointer)
				as: #'char *'
				in: aCCodeGenerator]
		ifFalse:
			[#(lowcodeCalloutState nativeSP nativeStackPointer shadowCallStackPointer) do:
				[:var| aCCodeGenerator removeVariable: var]]
]

{ #category : #translation }
TheoStackInterpreter class >> defaultPrimitiveTable [
	| cg |
	cg := CCodeGenerator new.
	cg vmClass: self.
	^PrimitiveTable collect:
		[:thing|
		(thing isInteger "quick prims, 0 for fast primitve fail"
		 or: [thing == #primitiveFail])
			ifTrue: [thing]
			ifFalse:
				[(self primitivesClass whichClassIncludesSelector: thing)
					ifNil: [#primitiveFail]
					ifNotNil:
						[:class|
						 (cg shouldIncludeMethodFor: class selector: thing)
							ifTrue: [thing]
							ifFalse: [#primitiveFail]]]]
]

{ #category : #initialization }
TheoStackInterpreter class >> initializePrimitiveTable [
	"This table generates a C function address table used in slowPrimitiveResponse along with dispatchFunctionPointerOn:in:"
	"self initializePrimitiveTable"

	"NOTE: The real limit here is 2047 because of the old method header layout but there is no point in going over the needed size"
	MaxPrimitiveIndex := 575.	
	MaxQuickPrimitiveIndex := 519.
	PrimNumberExternalCall := 117.
	PrimNumberDoPrimitive := 118.
	PrimNumberFFICall := 120.
	PrimNumberDoExternalCall := 218.
	PrimitiveTable := Array new: MaxPrimitiveIndex + 1.
	self primitivesClass table: PrimitiveTable from: 
	#(	"Integer Primitives (0-19)"
		(0 0 "a.k.a. primitiveFail but faster because primitiveFail won't even be called")
		(1 primitiveAdd)
		(2 primitiveSubtract)
		(3 primitiveLessThan)
		(4 primitiveGreaterThan)
		(5 primitiveLessOrEqual)
		(6 primitiveGreaterOrEqual)
		(7 primitiveEqual)
		(8 primitiveNotEqual)
		(9 primitiveMultiply)
		(10 primitiveDivide)
		(11 primitiveMod)
		(12 primitiveDiv)
		(13 primitiveQuo)
		(14 primitiveBitAnd)
		(15 primitiveBitOr)
		(16 primitiveBitXor)
		(17 primitiveBitShift)
		(18 primitiveMakePoint)
		(19 primitiveFail)					"Guard primitive for simulation -- *must* fail"

		"LargeInteger Primitives (20-37)"
		(20 primitiveRemLargeIntegers)
		(21 primitiveAddLargeIntegers)
		(22 primitiveSubtractLargeIntegers)
		(23 primitiveLessThanLargeIntegers)
		(24 primitiveGreaterThanLargeIntegers)
		(25 primitiveLessOrEqualLargeIntegers)
		(26 primitiveGreaterOrEqualLargeIntegers)
		(27 primitiveEqualLargeIntegers)
		(28 primitiveNotEqualLargeIntegers)
		(29 primitiveMultiplyLargeIntegers)
		(30 primitiveDivideLargeIntegers)
		(31 primitiveModLargeIntegers)
		(32 primitiveDivLargeIntegers)
		(33 primitiveQuoLargeIntegers)
		(34 primitiveBitAndLargeIntegers)
		(35 primitiveBitOrLargeIntegers)
		(36 primitiveBitXorLargeIntegers)
		(37 primitiveBitShiftLargeIntegers)

		"Float Primitives (38-59)"
		(38 primitiveFloatAt)
		(39 primitiveFloatAtPut)
		(40 primitiveAsFloat)
		(41 primitiveFloatAdd)
		(42 primitiveFloatSubtract)
		(43 primitiveFloatLessThan)
		(44 primitiveFloatGreaterThan)
		(45 primitiveFloatLessOrEqual)
		(46 primitiveFloatGreaterOrEqual)
		(47 primitiveFloatEqual)
		(48 primitiveFloatNotEqual)
		(49 primitiveFloatMultiply)
		(50 primitiveFloatDivide)
		(51 primitiveTruncated)
		(52 primitiveFractionalPart)
		(53 primitiveExponent)
		(54 primitiveTimesTwoPower)
		(55 primitiveSquareRoot)
		(56 primitiveSine)
		(57 primitiveArctan)
		(58 primitiveLogN)
		(59 primitiveExp)

		"Subscript and Stream Primitives (60-67)"
		(60 primitiveAt)
		(61 primitiveAtPut)
		(62 primitiveSize)
		(63 primitiveStringAt)
		(64 primitiveStringAtPut)
		"The stream primitives no longer pay their way; normal Smalltalk code is faster."
		(65 0 "a.k.a. primitiveFail but faster because primitiveFail won't even be called")"was primitiveNext"
		(66 0 "a.k.a. primitiveFail but faster because primitiveFail won't even be called") "was primitiveNextPut"
		(67 0 "a.k.a. primitiveFail but faster because primitiveFail won't even be called") "was primitiveAtEnd"

		"StorageManagement Primitives (68-79)"
		(68 primitiveObjectAt)
		(69 primitiveObjectAtPut)
		(70 primitiveNew)
		(71 primitiveNewWithArg)
		(72 primitiveArrayBecomeOneWay)	"Blue Book: primitiveBecome"
		(73 primitiveInstVarAt)
		(74 primitiveInstVarAtPut)
		(75 primitiveIdentityHash)
		(76 primitiveStoreStackp)			"Blue Book: primitiveAsObject"
		(77 primitiveSomeInstance)
		(78 primitiveNextInstance)
		(79 primitiveNewMethod)

		"Control Primitives (80-89)"
		(80 primitiveMProtect)					"Blue Book: primitiveBlockCopy"
		(81 primitiveFail)					"Blue Book: primitiveValue"
		(82 primitiveFail)					"Blue Book: primitiveValueWithArgs"
		(83 primitivePerform)
		(84 primitivePerformWithArgs)
		(85 primitiveSignal)
		(86 primitiveWait)
		(87 primitiveResume)
		(88 primitiveSuspend)
		(89 primitiveFlushCache)

		"Input/Output Primitives (90-109)"
		(90 primitiveMousePoint)
		(91 primitiveTestDisplayDepth)			"Blue Book: primitiveCursorLocPut"
		(92 primitiveSetDisplayMode)				"Blue Book: primitiveCursorLink"
		(93 primitiveInputSemaphore)
		(94 primitiveGetNextEvent)				"Blue Book: primitiveSampleInterval"
		(95 primitiveInputWord)
		(96 primitiveFail)	"primitiveCopyBits"
		(97 primitiveSnapshot)
		(98 primitiveStoreImageSegment)
		(99 primitiveLoadImageSegment)
		(100 primitivePerformInSuperclass)		"Blue Book: primitiveSignalAtTick"
		(101 primitiveBeCursor)
		(102 primitiveBeDisplay)
		(103 primitiveScanCharacters)
		(104 primitiveFail)	"primitiveDrawLoop"
		(105 primitiveStringReplace)
		(106 primitiveScreenSize)
		(107 primitiveMouseButtons)
		(108 primitiveKbdNext)
		(109 primitiveKbdPeek)

		"System Primitives (110-119)"
		(110 primitiveIdentical)
		(111 primitiveClass)
		(112 primitiveBytesLeft)
		(113 primitiveQuit)
		(114 primitiveExitToDebugger)
		(115 primitiveChangeClass)					"Blue Book: primitiveOopsLeft"
		(116 primitiveFlushCacheByMethod)
		(117 primitiveExternalCall)
		(118 primitiveDoPrimitiveWithArgs)
		(119 primitiveFlushCacheBySelector)
			"Squeak 2.2 and earlier use 119.  Squeak 2.3 and later use 116.
			Both are supported for backward compatibility."

		"Miscellaneous Primitives (120-127)"
		(120 primitiveCalloutToFFI)
		(121 primitiveImageName)
		(122 primitiveNoop)					"Blue Book: primitiveImageVolume"
		(123 primitiveOpenNewImage)					"was primitiveValueUninterruptably"
		(124 primitiveLowSpaceSemaphore)
		(125 primitiveSignalAtBytesLeft)

		"Squeak Primitives Start Here"

		"Squeak Miscellaneous Primitives (128-149)"
		(126 primitiveDeferDisplayUpdates)
		(127 primitiveShowDisplayRect)
		(128 primitiveArrayBecome)
		(129 primitiveSpecialObjectsOop)
		(130 primitiveFullGC)
		(131 primitiveIncrementalGC)
		(132 primitiveObjectPointsTo)
		(133 primitiveSetInterruptKey)
		(134 primitiveInterruptSemaphore)
		(135 primitiveMillisecondClock)
		(136 primitiveSignalAtMilliseconds)
		(137 primitiveSecondsClock)
		(138 primitiveSomeObject)
		(139 primitiveNextObject)
		(140 primitiveBeep)
		(141 primitiveClipboardText)
		(142 primitiveVMPath)
		(143 primitiveShortAt)
		(144 primitiveShortAtPut)
		(145 primitiveConstantFill)
		"NOTE: When removing the obsolete indexed primitives,
		the following two should go become #primitiveIntegerAt / atPut"
		(146 primitiveAdaptOnSendForChannel)	"primitiveReadJoystick"
		(147 primitiveAdaptOnReceiveForChannel)	"primitiveWarpBits"
		(148 primitiveClone)
		(149 primitiveGetAttribute)

		"Were File Primitives (150-169) - NO LONGER INDEXED"
		"Théo primitives"
		(150 primitiveNextInInterpreter)
		(151 primitiveWaitForItem) "should be grouped with 156 and 157 but don't want to change all the image side for now"
		(152 primitiveGIVElementOfInterpreter)
		(153 primitiveAdaptOnSendForChannel)
		(154 primitiveHaltInterpreter)
		(155 primitiveOwnInterpreterState)
		(156 primitiveTrylock)
		(157 primitiveUnlock)
		
		(158 primitiveCompareWith)
		(159 primitiveHashMultiply)
		(160 primitiveAdoptInstance)
		(161 primitiveSetOrHasIdentityHash)
		(162 primitiveFail)			"reserved for immutablity primitives"
		(163 primitiveGetImmutability)
		(164 primitiveSetImmutability)	
		(165 primitiveIntegerAt)		"hacked in here for now"
		(166 primitiveIntegerAtPut)
		(167 primitiveYield)
		(168 primitiveCopyObject)
		(169 primitiveNotIdentical)

		"SpurMemoryManager primitives"
		(170 primitiveAsCharacter)
		(171 primitiveImmediateAsInteger)
		(172 primitiveFetchNextMourner)
		(173 primitiveSlotAt)		"c.f. (73 primitiveInstVarAt)"
		(174 primitiveSlotAtPut)	"c.f. (74 primitiveInstVarAtPut)"
		(175 primitiveBehaviorHash)
		(176 primitiveMaxIdentityHash)
		(177 primitiveAllInstances)
		(178 primitiveAllObjects)
		(179 primitiveFail) "reserved for primitiveAllInstancesOfAny"
		(180 primitiveGrowMemoryByAtLeast)
		(181 primitiveSizeInBytesOfInstance)
		(182 primitiveSizeInBytes)
		(183 primitiveIsPinned)
		(184 primitivePin)

		"CriticalSection primitives"
		(185 primitiveExitCriticalSection) "similar to signal hence index = signal + 100"
		(186 primitiveEnterCriticalSection) "similar to wait hence index = wait + 100. was primitiveClosureValue"
		(187 primitiveTestAndSetOwnershipOfCriticalSection) "was primitiveClosureValueWithArgs"

		"Perform method directly"
		(188 primitiveExecuteMethodArgsArray)
		(189 primitiveExecuteMethod)

		"Sound Primitives (continued) - NO LONGER INDEXED"
		(190 primitiveActivatePrimitive)
		(191 primitiveDeactivatePrimitive)
		(192 194 primitiveFail)

		"Unwind primitives"
		(195 primitiveFindNextUnwindContext)
		(196 primitiveTerminateTo)
		(197 primitiveFindHandlerContext)
		(198 0 "a.k.a. primitiveMarkUnwindMethod")
		(199 0 "a.k.a. primitiveMarkHandlerMethod")

		"new closure primitives (were Networking primitives)"
		(200 primitiveClosureCopyWithCopiedValues)
		(201 primitiveClosureValue) "value"
		(202 primitiveClosureValue) "value:"
		(203 primitiveClosureValue) "value:value:"
		(204 primitiveClosureValue) "value:value:value:"
		(205 primitiveClosureValue) "value:value:value:value:"
		(206 primitiveClosureValueWithArgs) "valueWithArguments:"

		(207 primitiveFullClosureValue) "value[:value:value:value:] et al"
		(208 primitiveFullClosureValueWithArgs) "valueWithArguments:"
		(209 primitiveFullClosureValueNoContextSwitch) "valueNoContextSwitch[:value:] et al"

		(210 primitiveContextAt)
		(211 primitiveContextAtPut)
		(212 primitiveContextSize)
		(213 primitiveContextXray)
		(214 primitiveVoidVMState)
		(215 primitiveFlushCacheByMethod) "primitiveVoidVMStateForMethod in the CoInterpreter"
		(216 217 primitiveFail)	"reserved for Cog primitives"
		(218 primitiveDoNamedPrimitiveWithArgs)
		(219 primitiveFail)		"reserved for Cog primitives"

		(220 primitiveFail)		"reserved for Cog primitives"

		(221 primitiveClosureValueNoContextSwitch) "valueNoContextSwitch"
		(222 primitiveClosureValueNoContextSwitch) "valueNoContextSwitch:"

		(223 229 primitiveFail)	"reserved for Cog primitives (see 228 & 229 in CoInterpreterMT"

		(230 primitiveRelinquishProcessor)
		(231 primitiveForceDisplayUpdate)
		(232 primitiveFormPrint)
		(233 primitiveSetFullScreen)
		(234 primitiveFail) "primBitmapdecompressfromByteArrayat"
		(235 primitiveFail) "primStringcomparewithcollated"
		(236 primitiveFail) "primSampledSoundconvert8bitSignedFromto16Bit"
		(237 primitiveFail) "primBitmapcompresstoByteArray"
		(238 239 primitiveFail) "serial port primitives"
		(240 primitiveUTCMicrosecondClock)		"was serial port primitive"
		(241 primitiveLocalMicrosecondClock)		"was serial port primitive"
		(242 primitiveSignalAtUTCMicroseconds)
		(243 primitiveUpdateTimezone) "primStringtranslatefromtotable"
		(244 primitiveUtcAndTimezoneOffset)
		(245 primitiveCoarseUTCMicrosecondClock) "primStringindexOfAsciiinStringstartingAt"
		(246 primitiveCoarseLocalMicrosecondClock) "primStringfindSubstringinstartingAtmatchTable"
		(247 primitiveSnapshotEmbedded)
		(248 primitiveArrayBecomeOneWayNoCopyHash) "was primitiveInvokeObjectAsMethod"
		(249 primitiveArrayBecomeOneWayCopyHash)

		"VM Implementor Primitives (250-255)"
		(250 primitiveClearVMProfile)
		(251 primitiveControlVMProfiling "primitiveStartVMProfiling")
		(252 primitiveVMProfileSamplesInto "primitiveStopVMProfiling")
		(253 primitiveFail "N.B. primitiveCollectCogCodeConstituents in CoInterpreter below")
		(254 primitiveVMParameter)
		(255 primitiveFail) "RESERVED FOR THE R/Squeak VM. Was primitiveInstVarsPutFromStack. Never used except in Disney tests."

		"Quick Push Const Methods"
		(256 nil) "primitivePushSelf"
		(257 nil) "primitivePushTrue"
		(258 nil) "primitivePushFalse"
		(259 nil) "primitivePushNil"
		(260 nil) "primitivePushMinusOne"
		(261 nil) "primitivePushZero"
		(262 nil) "primitivePushOne"
		(263 nil) "primitivePushTwo"

		"Quick Push Inst Var Methods"
		(264 519 nil) "primitiveLoadInstVar"

		(520 primitiveFail)
		(521 529 primitiveFail) "Reserved for Spur primitives"
		(530 539 primitiveFail)

		(540 primitiveFail)
		(541 primitiveSmallFloatAdd)
		(542 primitiveSmallFloatSubtract)
		(543 primitiveSmallFloatLessThan)
		(544 primitiveSmallFloatGreaterThan)
		(545 primitiveSmallFloatLessOrEqual)
		(546 primitiveSmallFloatGreaterOrEqual)
		(547 primitiveSmallFloatEqual)
		(548 primitiveSmallFloatNotEqual)
		(549 primitiveSmallFloatMultiply)
		(550 primitiveSmallFloatDivide)
		(551 primitiveSmallFloatTruncated)
		(552 primitiveSmallFloatFractionalPart)
		(553 primitiveSmallFloatExponent)
		(554 primitiveSmallFloatTimesTwoPower)
		(555 primitiveSmallFloatSquareRoot)
		(556 primitiveSmallFloatSine)
		(557 primitiveSmallFloatArctan)
		(558 primitiveSmallFloatLogN)
		(559 primitiveSmallFloatExp)

		(560 569 primitiveFail)

		"External primitive support primitives"
		(570 primitiveFlushExternalPrimitives)
		(571 primitiveUnloadModule)
		(572 primitiveListBuiltinModule)
		(573 primitiveListExternalModule)
		(574 primitiveFail) "reserved for addl. external support prims"

		"Unassigned Primitives"
		(575 primitiveFail))
]

{ #category : #translation }
TheoStackInterpreter class >> preambleCCode [
	^	
'/* Disable Intel compiler inlining of warning which is used for breakpoints */
#pragma auto_inline(off)
sqInt warnpid, erroronwarn;
void
warning(char *s) { /* Print an error message but don''t necessarily exit. */
	if (erroronwarn) error(s);
	if (warnpid)
		printf("\n%s pid %ld\n", s, (long)warnpid);
	else
		printf("\n%s\n", s);
}
void
warningat(char *s, int l) { /* ditto with line number. */
	/* use alloca to call warning so one does not have to remember to set two breakpoints... */
	char *sl = alloca(strlen(s) + 16);
	sprintf(sl, "%s %d", s, l);
	warning(sl);
}
#pragma auto_inline(on)

void
invalidCompactClassError(char *s, struct foo * self) { /* Print a (compact) class index error message and exit. */
#if SPURVM
	printf("\nClass %s does not have the required class index\n", s);
#else
	printf("\nClass %s does not have the required compact class index\n", s);
#endif
	exit(-1);
}

/*
 * Define sigsetjmp and siglongjmp to be the most minimal setjmp/longjmp available on the platform.
 * Note: on windows 64 via mingw-w64, the 2nd argument NULL to _setjmp prevents stack unwinding
 */
#undef sigsetjmp
#undef siglongjmp
#if _MSC_VER
# define sigsetjmp(jb,ssmf) _setjmp(jb)
# define siglongjmp(jb,v) longjmp(jb,v)
#elif _WIN64 && __GNUC__
# define sigsetjmp(jb,ssmf) _setjmp(jb,NULL)
# define siglongjmp(jb,v) longjmp(jb,v)
#elif _WIN32
# define sigsetjmp(jb,ssmf) setjmp(jb)
# define siglongjmp(jb,v) longjmp(jb,v)
#else
# define sigsetjmp(jb,ssmf) _setjmp(jb)
# define siglongjmp(jb,v) _longjmp(jb,v)
#endif

#define odd(v) ((int)(v)&1)
#define even(v) (!odd(v))
'
]

{ #category : #translation }
TheoStackInterpreter class >> requiredMethodNames: options [
	"Answer the list of method names that should be retained for export or other support reasons"
	| requiredList |
	"A number of methods required by VM support code, specific platforms, etc"
	requiredList := #(
		assertValidExecutionPointe:r:s:
		characterForAscii:
		findClassOfMethod:forReceiver: findSelectorOfMethod:
			forceInterruptCheck forceInterruptCheckFromHeartbeat fullDisplayUpdate
		getCurrentBytecode getFullScreenFlag getInterruptKeycode getInterruptPending
			getSavedWindowSize getThisSessionID
		interpret
		loadInitialContext
		primitiveFail primitiveFailFor: primitiveFlushExternalPrimitives printAllStacks printCallStack printContext:
			printExternalHeadFrame printFramesInPage: printFrame: printHeadFrame printMemory printOop:
				printStackPages printStackPageList printStackPagesInUse printStackPageListInUse
		readableFormat: readImageFromFile:HeapSize:StartingAt:
		setFullScreenFlag: setInterruptKeycode: setInterruptPending: setInterruptCheckChain:
			setSavedWindowSize: success:
		
		validInstructionPointer:inMethod:framePointer:
		loadAndExecute: 
		setMyCurrentThread:_:
		readImageFromFile:HeapSize:StartingAtV2:
		initMutexForFetchNextBytecode:andCond:
		mutexLock:andCond:
		)asSet.

	"Nice to actually have all the primitives available"
	requiredList addAll: (self primitiveTable select: [:each| each isSymbol]).

	"InterpreterProxy is the internal analogue of sqVirtualMachine.c, so make sure to keep all those"
	InterpreterProxy organization categories do:
		[:cat |
		((cat ~= 'initialize') and: [cat ~= 'private']) ifTrue:
			[requiredList addAll: (InterpreterProxy organization listAtCategoryNamed: cat)]].

	^requiredList
]

{ #category : #'interpreter shell' }
TheoStackInterpreter >> CFork [
	<returnType: 'pid_t'>
	^ self cCode: 'fork();'
]

{ #category : #channel }
TheoStackInterpreter >> channelSize [
 ^128
]

{ #category : #'interpreter shell' }
TheoStackInterpreter >> fetchNextBytecode [
	"This method fetches the next instruction (bytecode). Each bytecode method is responsible for fetching the next bytecode, preferably as early as possible to allow the memory system time to process the request before the next dispatch."

	isStepable
		ifTrue: [	self
				printLocalSP: localSP
				LocalFP: localSP
				LocalIP: localIP
				CurrentBytecode: currentBytecode.
			self externalizeIPandSP.
			self printCallStack.
			self lockFetchNextBytecode.
 ].
	MULTIPLEBYTECODESETS
		ifTrue: [ currentBytecode := self fetchByte + bytecodeSetSelector ]
		ifFalse: [ currentBytecode := self fetchByte ]
]

{ #category : #'interpreter shell' }
TheoStackInterpreter >> getFirstModule [
	
	<api>
	<returnTypeC: #'ModuleEntry * '>
	
	^firstModule 
]

{ #category : #'interpreter shell' }
TheoStackInterpreter >> getInterpreterProxy [
	
	<api>
	<returnTypeC: #'VirtualMachine * '>
	
	^interpreterProxy
]

{ #category : #'interpreter shell' }
TheoStackInterpreter >> getSqueakModule [
	
	<api>
	<returnTypeC: #'ModuleEntry * '>
	
	^squeakModule
]

{ #category : #thInterCom }
TheoStackInterpreter >> initMutex: aMutex andCond: aCond [
	<var: #aMutex type: 'pthread_mutex_t *'>
	<var: #aCond type: 'pthread_cond_t **'>

	self cCode: '
	if(pthread_mutex_init(aMutex, NULL) != 0){
		printf("Mutex init error: %s\n", strerror(errno));
		exit(1);
	}
	
	* aCond = malloc(sizeof(pthread_cond_t));
	if(pthread_cond_init(* aCond, NULL) != 0){
		printf("Cond init error: %s\n", strerror(errno));
		abort();
	}'
	inSmalltalk: [ self initMutex: aMutex andCond: aCond]
]

{ #category : #thInterCom }
TheoStackInterpreter >> initMutexForFetchNextBytecode: aMutex andCond: aCond [
	<var: #aMutex type: 'pthread_mutex_t *'>
	<var: #aCond type: 'pthread_cond_t **'>

	self cCode: '
	if(pthread_mutex_init(aMutex, NULL) != 0){
		printf("Mutex init error: %s\n", strerror(errno));
		exit(1);
	}
	
	* aCond = malloc(sizeof(pthread_cond_t));
	if(pthread_cond_init(* aCond, NULL) != 0){
		printf("Cond init error: %s\n", strerror(errno));
		abort();
	}
	
	//Init so we can use the first interpreter normally but he can become stepable too
	//if(forStepping != 1){
		GIV(isStepable) = 0;
		//forStepping = 1;
	//}else{
		//GIV(isStepable) = 1;
	//};
	'
	inSmalltalk: [ self initMutexForFetchNextBytecode: aMutex andCond: aCond]
]

{ #category : #'interpreter shell' }
TheoStackInterpreter >> initialiseToDefaultPrimitiveTable [

	0 to: MaxPrimitiveIndex + 1 do:
		[ :index | primitiveTable at: index put: (defaultPrimitiveTable at: index) ]
]

{ #category : #channel }
TheoStackInterpreter >> initializeBootstrapChannel [
"This method should be push in the startup of an image"
	<var: #mutAndCond declareC: 'CMutexAndCond * mutAndCond = malloc(sizeof(CMutexAndCond))'>
	<var: #onlySlot type: 'CMutexAndCond **'>
	| channelOop channelClassOop nilOop anArray index1 index2 lock onlySlot mutAndCond transferredArrayClassOop |
	nilOop := objectMemory nilObject.
	channelOop := objectMemory splObj: SpecialChannel.
	nilOop == channelOop
		ifTrue: [ "We don't have a channel"
			channelClassOop := objectMemory splObj: ClassChannelQueue.
			nilOop = channelClassOop
				ifTrue:
					[ "We don't have the class neither there is nothing we can do" channelOop := nilOop ]
				ifFalse:
					[ "We prepare the transferredArrayClass which is in the classPOll of the class"
					transferredArrayClassOop := self prepareChannelQueueClass: channelClassOop.
					"We check that the class is at the fix index in order for other memory to look at this specific place"
					(objectMemory knownClassAtIndex: ClassChannelQueueCompactIndex)
						= channelClassOop
						ifFalse:
							[ "our class exist but is not in the classTable at the expected index. We remove the entry and enter our class at the fix index."
							objectMemory expungeFromClassTable: channelClassOop.
							objectMemory
								setHashBitsOf: channelClassOop
								to: ClassChannelQueueCompactIndex.
							objectMemory
								storePointer: ClassChannelQueueCompactIndex
								ofObject: objectMemory classTableFirstPage
								withValue: channelClassOop ].
					"We now have the class setup correctly, we create a new channel we initialize it"
					channelOop := objectMemory
						instantiateClass: channelClassOop
						indexableSize: 0.
					"for now it is a subclass of OrderedCollection, we need to initialize an array of size 10 and 2 index"
					anArray := objectMemory
						allocateSlots: 10
						format: 2
						classIndex: objectMemory arrayClassIndexPun.
					objectMemory fillObj: anArray numSlots: 10 with: nilOop.
					index1 := objectMemory integerObjectOf: 1.
					index2 := objectMemory integerObjectOf: 0.
					self initMutex: (self cCode:'&mutAndCond->mutex') andCond: (self cCode:'&mutAndCond->condition') .
					lock := objectMemory
						instantiateClass: objectMemory classByteArray 
						indexableSize: BytesPerWord.
					onlySlot := objectMemory firstIndexableField: lock.
					onlySlot at: 0 put: mutAndCond.
					objectMemory
						storePointer: 0
						ofObject: channelOop
						withValue: anArray.
					objectMemory
						storePointer: 1
						ofObject: channelOop
						withValue: index1.
					objectMemory
						storePointer: 2
						ofObject: channelOop
						withValue: index2.
					objectMemory
						storePointer: 3
						ofObject: channelOop
						withValue: lock.
					objectMemory
						storePointer: 4
						ofObject: channelOop
						withValue: transferredArrayClassOop.
					
					objectMemory splObj: SpecialChannel put: channelOop ] ].

]

{ #category : #'interpreter shell' }
TheoStackInterpreter >> interpret [
	"This is the main interpreter loop. It normally loops forever, fetching and executing bytecodes. When running in the context of a browser plugin VM, however, it must return control to the browser periodically. This should done only when the state of the currently running Squeak thread is safely stored in the object heap. Since this is the case at the moment that a check for interrupts is performed, that is when we return to the browser if it is time to do so. Interrupt checks happen quite frequently."

	<inline: false>
	"If stacklimit is zero then the stack pages have not been initialized."
	stackLimit = 0 ifTrue:
		[^self initStackPagesAndInterpret].
	"record entry time when running as a browser plug-in"
	self browserPluginInitialiseIfNeeded.
	self internalizeIPandSP.
	self initExtensions.
	self fetchNextBytecode.
	[true] whileTrue: [self dispatchOn: currentBytecode in: BytecodeTable].
	localIP := localIP - 1.  "undo the pre-increment of IP before returning"
	self externalizeIPandSP.
	^nil

]

{ #category : #thInterCom }
TheoStackInterpreter >> mutexLock: aMutex andCond: aCond [
	<var: #aMutex type: 'pthread_mutex_t *'>
	<var: #aCond type: 'pthread_cond_t **'>
	
	self
		cCode: '
		if(pthread_mutex_lock(aMutex) != 0){
			printf("Mutex lock error: %s\n", strerror(errno));
			abort();
		}
		if(pthread_cond_wait(* aCond, aMutex) != 0){
			printf("Cond lock error: %s\n", strerror(errno));
			abort();
		}
		pthread_mutex_unlock(aMutex);' inSmalltalk: [ self mutexLock: aMutex andCond: aCond ]
]

{ #category : #channel }
TheoStackInterpreter >> prepareChannelQueueClass: aChannelClassOop [
	|   sizeOfArray arrayProxy classPoolDictionary arrayInPoolDictionary |
	
	"We prepare the array"
	sizeOfArray := objectMemory lastClassIndexTrans - objectMemory firstClassIndexTrans.
	arrayProxy := objectMemory
						allocateSlots: sizeOfArray
						format: 2
						classIndex: objectMemory arrayClassIndexPun.
	objectMemory fillObj: arrayProxy numSlots: sizeOfArray with: (objectMemory integerObjectOf: 0).
					
	"We look where the array should be, it is now harcoded"
	classPoolDictionary := objectMemory fetchPointer: 7 ofObject: aChannelClassOop.
	arrayInPoolDictionary := objectMemory fetchPointer: 1 ofObject: classPoolDictionary.
	
	objectMemory
						storePointer: 1
						ofObject: (objectMemory  fetchPointer: 3 ofObject: arrayInPoolDictionary)
						withValue: arrayProxy.
										
	^ arrayProxy
]

{ #category : #'debug printing' }
TheoStackInterpreter >> printMethodCacheFor: thing [
	<api>
	| n |
	n := 0.
	0 to: MethodCacheSize - 1 by: MethodCacheEntrySize do:
		[:i | | s c m p |
		s := methodCache at: i + MethodCacheSelector.
		c := methodCache at: i + MethodCacheClass.
		m := methodCache at: i + MethodCacheMethod.
		p := methodCache at: i + MethodCachePrimFunction.
		((thing = -1 or: [s = thing or: [c = thing or: [p = thing or: [m = thing]]]])
		 and: [(objectMemory addressCouldBeOop: s)
		 and: [c ~= 0
		 and: [(self addressCouldBeClassObj: c)
			or: [self addressCouldBeClassObj: (objectMemory classForClassTag: c)]]]]) ifTrue:
			[self cCode: [] inSmalltalk: [self transcript ensureCr].
			 self printNum: i; space; printHexnp: i; cr; tab.
			 (objectMemory isBytesNonImm: s)
				ifTrue: [self cCode: 'printf("%" PRIxSQPTR " %.*s\n", s, (int)(numBytesOf(s,0)), (char *)firstIndexableField(s,0))'
						inSmalltalk: [self printHex: s; space; print: (self stringOf: s); cr]]
				ifFalse: [self shortPrintOop: s].
			 self tab.
			 (self addressCouldBeClassObj: c)
				ifTrue: [self shortPrintOop: c]
				ifFalse: [self printNum: c; space; shortPrintOop: (objectMemory classForClassTag: c)].
			self tab; shortPrintOop: m; tab.
			self cCode:
					[p > 1024
						ifTrue: [self printHexnp: p]
						ifFalse: [self printNum: p]]
				inSmalltalk:
					[p isSymbol ifTrue: [self print: p] ifFalse: [self printNum: p]].
			self cr]].
	n > 1 ifTrue:
		[self printNum: n; cr]
]

{ #category : #'interpreter shell' }
TheoStackInterpreter >> setFirstModule: aModuleEntry [
	
	<api>
	<returnTypeC: #'void'>
	<var: #aModuleEntry type: 'ModuleEntry *'>
	
	firstModule := aModuleEntry
]

{ #category : #'interpreter shell' }
TheoStackInterpreter >> setSqueakModule: aModuleEntry [
	
	<api>
	<returnTypeC: #'void'>
	<var: #aModuleEntry type: 'ModuleEntry *'>
	
	squeakModule := aModuleEntry
]
