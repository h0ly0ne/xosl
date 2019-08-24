#ifndef MBRPassH
#define MBRPassH

#include "PTab.h"

class CMBRPassword {
public:
	char IPL[IPL_SIZE - sizeof(long)];
	unsigned long Password;
	char Reserved[6];
	char PartTable[16 * 4];
	unsigned short MagicNumber;
};

#endif
