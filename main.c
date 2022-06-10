#include <Devices.h>
#include <Dialogs.h>
#include <Sound.h>
#include <Windows.h>
#include "main.h"

QDGlobals qd;
Boolean running = true;

void DoCommand(long int result);

int main(void) {
	MenuHandle appleMenu;
	EventRecord event;
	MenuHandle fileMenu;
	WindowPtr window;

	// initialise toolbox
	InitGraf(&qd.thePort);
	InitFonts();
	InitWindows();
	InitMenus();
	InitDialogs(nil);
	InitCursor();

	// initialise menus
	appleMenu = GetMenu(mApple);
	AddResMenu(appleMenu, 'DRVR');
	InsertMenu(appleMenu, 0);
	fileMenu = GetMenu(mFile);
	InsertMenu(fileMenu, 0);
	DrawMenuBar();

	// initialise window
	window = GetNewWindow(kWindowID, nil, kMoveToFront);

	if (window == nil) {
		SysBeep(10);
		ExitToShell();
	}

	ShowWindow(window);
	SetPort(window);

	while (running) {
		SystemTask();

		if (GetNextEvent(everyEvent, &event)) {
			switch (event.what) {
				case activateEvt:
					break;

				case mouseDown:
					switch (FindWindow(event.where, &window)) {
						case inDrag:
							DragWindow(window, event.where, &qd.screenBits.bounds);
							break;

						case inGoAway:
							running = false;
							break;

						case inMenuBar:
							DoCommand(MenuSelect(event.where));
							break;

						case inSysWindow:
							SystemClick(&event, window);
							break;
					}
					break;

				case updateEvt:
					break;
			}
		}
	}

	SysBeep(10);

	return 0;
}

void DoCommand(long int result) {
	int menu = result >> 16;
	unsigned char name[255];
	int item = result & 0x0ffff;

	switch (menu) {
		case mApple:
			switch (item) {
				case cAbout:
					SysBeep(10);
					Alert(kAboutBoxAlert, nil);
					break;

				default:
					GetItem(GetMenu(mApple), item, name);
					OpenDeskAcc(name);
					break;
			}
			break;

		case mFile:
			switch (item) {
				case cQuit:
					running = false;
					break;

				default:
					break;
			}
			break;
	}
}

