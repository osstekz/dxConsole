
###Dart Console Library for Windows

This library was created to support customers requiring extended native Windows Console support.
dxConsole implements both Forms & Commandline modes. Forms mode is especially useful for configuration &
administration tasks, very similar to BIOS setup screens.

------------------------------------
####CHANGES YOU NEED TO DO BEFORE RUNNING
Unfortunately, Dart implements a hardcoded filename scheme for native extension dlls. The default installation for bin\dxConsole.dll is the 64bit version.  For Dart.exe(32bit), you must copy the appropriate bin\dxConsole_win32.dll to bin\dxConsole.dll. 
	
	Example:
	If running Dart.exe(32bit)
		copy bin\dxConsole_win32.dll to bin\dxConsole.dll

------------------------------------
###HOW TO RUN
dart.exe --checked  example\dxConsoledemo_main.dart
 
------------------------------------
####DEVELOPMENT
Development and testing for both 32/64bit OS versions uses the lastest Dev Channel SDK.  

Contributions to this are absolutely welcome! Feel free to file issues, send pull requests, etc.
 
------------------------------------
####EXTENDED FEATURES
- ANSI escape sequence console driver
- SendKeys: Character string with optional states(wVirtualKeyCode,wVirtualScanCode,dwControlKeyState)
- Supports UNICODE
- Windowed Boxes with titles
- Implements AnsiPen library
- 256 color palette (4 bits for background, 4 bits for foreground)
- Color palettes
- Printf style output formatting
- Save/Restore screen buffers(characters & formatting)

------------------------------------
####Forms mode Events
- Keyboard: KA_KEYCHAR,KA_KEYCODE
- Mouse: MOUSE_POSX,MOUSE_POSY,MOUSE_FLAGS,MOUSE_BTNSTATE
- WindowBufferResize: WBER_POSX,WBER_POSY

------------------------------------
####Forms mode controls
- XControl
- XInput
- XText
- XWindow
- XTabbedWindow
- XTab
- XDDList
