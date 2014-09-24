
###Dart Console Library for Windows

This library was created to support customers requiring extended native Windows Console support.
XTerm implements both Forms & Commandline modes. Forms mode is especially useful for configuration &
administration tasks, very similar to BIOS setup screens.

------------------------------------
####CHANGES YOU NEED TO DO BEFOR RUNNING
Unfortunately Dart implements a hardcoded scheme for extension dll filenames. Depending on your OS(32/64bit) architecture, you must copy the appropriate bin\xterm_???.dll to xterm.dll 
	
	Example:
	If running 64bit OS
		copy bin/xterm_win64.dll to xterm.dll
	If running 32bit OS
		copy bin/xterm_win32.dll to xterm.dll

------------------------------------
###HOW TO RUN
dart.exe --checked  example\xtermdemo_main.dart
 
------------------------------------
####DEVELOPMENT
Development and testing for both 32/64bit OS versions uses the lastest Dev Channel SDK.  
 
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

