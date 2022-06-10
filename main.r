#ifndef SystemSevenOrLater
	#define SystemSevenOrLater 1
#endif

#include "Menus.r"
#include "SysTypes.r"
#include "Types.r"
#include "main.h"

resource 'WIND' (kWindowID, preload, purgeable) {
	{60, 40, 290, 160},
	noGrowDocProc, visible, goAway, 0x0, "Test", noAutoCenter
	
};

type 'MCMD' {
	integer = $$CountOf(Commands);
	array Commands {
		integer;
	};
};

resource 'MBAR' (kMenuBar, preload) {
	{ mApple, mFile };
};

resource 'MENU' (mApple, "Apple", preload) {
	mApple, textMenuProc,
	AllItems & ~MenuItem2,
	enabled, apple,
	{
		ABOUTITEM, noicon, nokey, nomark, plain;
		"-",       noicon, nokey, nomark, plain;
	}
};

resource 'MCMD' (mApple, purgeable) {
	{
		cAbout;
		cNull;
		cDeskAccessory;
	}
};

resource 'MENU' (mFile, FILEMENU, preload) {
	mFile, textMenuProc,
	MenuItem1,
	// AllItems & ~MenuItem2 & ~MenuItem4 & ~MenuItem5,
	enabled, FILEMENU,
	{
		FILEQUITITEM, noicon, FILEQUITKEY, nomark, plain;
	}
};

resource 'MCMD' (mFile, purgeable) {
	{
		cQuit;
	}
};

resource 'ALRT' (kAboutBoxAlert, purgeable) {
	{40, 40, 156, 309},
	kAboutBoxDITL,
	{
		OK, visible, silent,
		OK, visible, silent,
		OK, visible, silent,
		OK, visible, silent,
	},
	alertPositionMainScreen
};

resource 'DITL' (kAboutBoxDITL, purgeable) {
	{
		{86, 201, 106, 259},
		Button {
			enabled,
			"OK"
		},
		{10, 78, 74, 259},
		StaticText {
			disabled,
			"Test App"
		}
	}
};

