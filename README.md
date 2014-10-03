
###Dart Console Library for Windows

This library was created to support customers requiring extended native Windows Console support.
dxConsole implements both Forms & Commandline modes. Forms mode is especially useful for configuration &
administration tasks, very similar to BIOS setup screens.

------------------------------------
####CHANGES YOU NEED TO DO BEFORE RUNNING

I packaged the 64bit version as the default.
Just add the Github reference below to your pubspec.yaml:
  dxConsole:
    git: https://github.com/osstekz/dxConsole

_Only for Dart.exe(32bit) projects:_
Due to Dart implementing a hardcoded filename scheme for importing native extension dlls (poor design?), the following manual install is required.
   
  1. Download zip file and extract to a <local drive/path>.
  2. Copy the appropriate bin\dxConsole_win32.dll to bin\dxConsole.dll.
  3. Add a path reference to <local drive/path> in your pubspec.yaml. Example:<br \>
  		dxConsole:<br \>
    		path: <local drive/path>/dxConsole
	
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
