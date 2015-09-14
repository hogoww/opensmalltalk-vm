/*
% g++ -I.. -I../cpu -I../instrument/stubs -Wno-invalid-offsetof @ -o #
 */

#include <stddef.h>

#define COG 1

#include <bochs.h>

#define NEED_CPU_REG_SHORTCUTS

#include <cpu.h>

static char buf[10];

char *
lower(char *s)
{
	int i;
	for (i = 0; i < strlen(s); i++)
		buf[i] = tolower(s[i]);
	buf[i] = 0;
	return buf;
}

int
main()
{
#define stoffsetof(type,field) (offsetof(type,field)+1)
#define print(r,n) \
printf("!BochsX64Alien methodsFor: 'accessing' stamp: 'eem %d/%d/%d %d:%02d'!\r"\
	"%s\r\t^self unsignedLongLongAt: %ld! !\r", m,d,y,h,i, lower(#r), \
	stoffsetof(BX_CPU_C,gen_reg[n].dword.erx));\
printf("!BochsX64Alien methodsFor: 'accessing' stamp: 'eem %d/%d/%d %d:%02d'!\r"\
	"%s: anUnsignedInteger\r\t^self unsignedLongLongAt: %ld put: anUnsignedInteger! !\r", m,d,y,h,i, lower(#r), \
	stoffsetof(BX_CPU_C,gen_reg[n].dword.erx))

	time_t nowsecs = time(0);
	struct tm now = *localtime(&nowsecs);
	int m = now.tm_mon + 1; /* strange but true */
	int d = now.tm_mday;
	int y = now.tm_year + 1900;
	int h = now.tm_hour;
	int i = now.tm_min;

	printf("\"Hello world!!\"!\r");
	printf("!BochsX64Alien class methodsFor: 'instance creation' stamp: 'eem %d/%d/%d %d:%02d'!\r"
	"dataSize\r\t^%ld! !\r", m,d,y,h,i, sizeof(BX_CPU_C));

	printf("!BochsX64Alien methodsFor: 'accessing' stamp: 'eem %d/%d/%d %d:%02d'!\r"
			"rflags\r\t^self unsignedLongLongAt: %ld! !\r", m,d,y,h,i,
			stoffsetof(BX_CPU_C,eflags));

	print(RAX,BX_64BIT_REG_RAX);
	print(RBX,BX_64BIT_REG_RBX);
	print(RCX,BX_64BIT_REG_RCX);
	print(RDX,BX_64BIT_REG_RDX);
	print(RSP,BX_64BIT_REG_RSP);
	print(RBP,BX_64BIT_REG_RBP);
	print(RSI,BX_64BIT_REG_RSI);
	print(RDI,BX_64BIT_REG_RDI);
	print(R8,BX_64BIT_REG_R8);
	print(R9,BX_64BIT_REG_R9);
	print(R10,BX_64BIT_REG_R10);
	print(R11,BX_64BIT_REG_R11);
	print(R12,BX_64BIT_REG_R12);
	print(R13,BX_64BIT_REG_R13);
	print(R14,BX_64BIT_REG_R14);
	print(R15,BX_64BIT_REG_R15);
	print(RIP,BX_64BIT_REG_RIP);

	return 0;
}