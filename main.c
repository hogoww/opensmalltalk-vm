 #include "theFullInterpreter.h"
#include <stdio.h>

#define codeBytes 0
#define primitiveLogSize 0
#define scavengerDenominator 7


  /* 
     newSpaceStart: startAddress newSpaceBytes: totalBytes survivorBytes: requestedSurvivorBytes
	| actualEdenBytes survivorBytes |
	survivorBytes := requestedSurvivorBytes truncateTo: manager allocationUnit.
	actualEdenBytes := totalBytes - survivorBytes - survivorBytes truncateTo: manager allocationUnit.
	self assert: totalBytes - actualEdenBytes - survivorBytes - survivorBytes < manager allocationUnit.

	"for tenuring we require older objects below younger objects.  since allocation
	 grows up this means that the survivor spaces must precede eden."

	pastSpace start: startAddress; limit: startAddress + survivorBytes.
	futureSpace start: pastSpace limit; limit: pastSpace limit + survivorBytes.
	eden start: futureSpace limit; limit: startAddress + totalBytes.

	self assert: self futureSpace limit <= (startAddress + totalBytes).
	self assert: self eden start \\ manager allocationUnit
				+ (self eden limit \\ manager allocationUnit) = 0.
	self assert: self pastSpace start \\ manager allocationUnit
				+ (self pastSpace limit \\ manager allocationUnit) = 0.
	self assert: self futureSpace start \\ manager allocationUnit
				+ (self futureSpace limit \\ manager allocationUnit) = 0.
heapSizeAtPreviousGCheapSizeAtPreviousGC
	self initFutureSpaceStart.
	manager initSpaceForAllocationCheck: (self addressOf: eden) limit: eden limit.

	tenuringProportion := 0.9
   */

void initScavenger(int startAddress, int totalBytes, int requestedSurvivorBytes){
    sqInt actualEdenBytes;
    sqInt survivorBytes;

	survivorBytes = (requestedSurvivorBytes & ((~(allocationUnit()) - 1)));
	actualEdenBytes = (((totalBytes - survivorBytes) - survivorBytes) & ((~(allocationUnit()) - 1)));
	(GIV(pastSpace) . start) = startAddress;
	(GIV(pastSpace) . limit) = (startAddress + survivorBytes);
	(GIV(futureSpace) . start) = (pastSpace . limit);
	(GIV(futureSpace) . limit) = ((pastSpace . limit) + survivorBytes);
	(GIV(eden) . start) = (GIV(futureSpace) . limit);
	(GIV(eden) . limit) = (startAddress + totalBytes);
	GIV(futureSurvivorStart) = GIV(futureSpace) . start;
	//	initSpaceForAllocationChecklimit((&GIV(eden)), GIV(eden) . limit);
	GIV(tenuringProportion) = 0.9;
}

void
collapseSegmentsPostSwizzleBootstrap(void)
{   DECL_MAYBE_SQ_GLOBAL_STRUCT
    SpurSegmentInfo * cascade0;

	GIV(canSwizzle) = 0;
	GIV(numSegments) = 1;
	cascade0 = (&(GIV(segments)[0]));
	(cascade0->segStart = oldSpaceStart());
	(cascade0->segSize = (GIV(totalHeapSizeIncludingBridges) = (endOfMemory()) - (oldSpaceStart())));
	assert(GIV(endOfMemory) = segLimit(&GIV(segments)[0]));
	initSegmentBridgeWithBytesat(16,GIV(endOfMemory) - 16);
	assert(isSegmentBridge(bridgeAt(0)));
	assert((numSlotsOfAny(bridgeAt(0))) == 0);
}


void initializePostBootstrap(){
  GIV(freeOldSpaceStart) = GIV(freeStart);
  GIV(freeStart) = GIV(eden).start;
  GIV(pastSpaceStart) = GIV(pastSpace).start;
  GIV(scavengeThreshold) = GIV(eden).limit - (int)(GIV(edenBytes) / 64);
}

int main(){
  int oldSpaceSize = 999 * 1024;
  int newSpaceSize = 1 * 1024;
  int stackSpaceSize = 9 * 4096;
  int methodCacheSize = 4096 * 8;
  int rumpCStackSize = 0;
  int initialAddress = 268435468;

  int objectHeaderSize = 8;
  int emptyObjectSize = objectHeaderSize + 8;

  int memorySize = oldSpaceSize + newSpaceSize + codeBytes + stackSpaceSize + methodCacheSize + primitiveLogSize + rumpCStackSize;
  //set of attribute initialAddress, does not exists in c
  GIV(memory) = sqAllocateMemory(memorySize,memorySize);
  GIV(newSpaceStart) = initialAddress + codeBytes + stackSpaceSize + methodCacheSize + primitiveLogSize + rumpCStackSize;
  GIV(endOfMemory) = GIV(freeOldSpaceStart) = initialAddress + oldSpaceSize + newSpaceSize + codeBytes + stackSpaceSize + methodCacheSize + primitiveLogSize + rumpCStackSize;
  GIV(freeStart) = newSpaceSize + GIV(newSpaceStart);
  GIV(oldSpaceStart) = GIV(newSpaceLimit) = newSpaceSize + GIV(newSpaceStart);
  GIV(scavengeThreshold) = memorySize * 4;

  initScavenger(GIV(newSpaceStart),newSpaceSize,(int) (newSpaceSize / scavengerDenominator));
  initializePostBootstrap();
  /* begin setHeapSizeAtPreviousGC */
  GIV(heapSizeAtPreviousGC) = (GIV(totalHeapSizeIncludingBridges) - (GIV(numSegments) * (2 * BaseHeaderSize))) - GIV(totalFreeOldSpace);
  /* begin resetAllocationAccountingAfterGC */
  GIV(oldSpaceUsePriorToScavenge) = (GIV(totalHeapSizeIncludingBridges) - (GIV(numSegments) * (2 * BaseHeaderSize))) - GIV(totalFreeOldSpace);
  collapseSegmentsPostSwizzleBootstrap();
  needGCFlag = 1;
}
  
