
#include <StrTable.h>

CLoaderStringTable CXoslStringTable::Loader = {
	"Extended Operating System Loader",
	"XOSL version 1.1.7",
	"\xa9 2000 Geurt Vos, 2019 E. Giacomelli",
	"github.com/binary-manu/xosl",
	"Choose OS",
	"Boot error",
	"Boot",
	"Setup",
	"Preference",
	"About",
	"Enter password",
	"Invalid Password",
	"Setup password",
	"Preference password",
	"Password",
	"Booting in ",
	" minutes",
	"Booting in ",
	" seconds",
	"Press Escape to abort timer...",
};

CXoslStringTable *StringTable;
