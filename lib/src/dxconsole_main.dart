part of dxConsole;

final DXConsole xpen = new DXConsole();

typedef bool CALLBACKTABEVENT(XTab xtab, Uint8List event);

//Virtual Keys
const int iVK_RETURN = 0x0D,
		iVK_SHIFT = 0x10,
		iVK_CONTROL = 0x11;

const int iCOLOR256_BLACK = 0,
		iCOLOR256_BLUE = 1,
		iCOLOR256_GREEN = 2,
		iCOLOR256_CYAN = 3,
		iCOLOR256_RED = 4,
		iCOLOR256_PURPLE = 5,
		iCOLOR256_YELLOW = 6,
		iCOLOR256_SYSTEM = 7, //This is the standard format of a command window.
		//It is called SYSTEM because WHITE is reserved
		//to be the opposite of black on black.
		iCOLOR256_GREY = 8,
		iCOLOR256_BRIGHTBLUE = 9,
		iCOLOR256_BRIGHTGREEN = 10,
		iCOLOR256_BRIGHTCYAN = 11,
		iCOLOR256_BRIGHTRED = 12,
		iCOLOR256_BRIGHTPURPLE = 13,
		iCOLOR256_BRIGHTYELLOW = 14,
		iCOLOR256_BRIGHTWHITE = 15,
		// Foreground colors
		iCOLOR256_ONBLUE = 16,
		iCOLOR256_ONGREEN = 32,
		iCOLOR256_ONCYAN = 48,
		iCOLOR256_ONRED = 64,
		iCOLOR256_ONPURPLE = 80,
		iCOLOR256_ONYELLOW = 96,
		iCOLOR256_ONSYSTEM = 112,
		iCOLOR256_ONGREY = 128,
		iCOLOR256_ONBRIGHTBLUE = 144,
		iCOLOR256_ONBRIGHTGREEN = 160,
		iCOLOR256_ONBRIGHTCYAN = 176,
		iCOLOR256_ONBRIGHTRED = 192,
		iCOLOR256_ONBRIGHTPURPLE = 208,
		iCOLOR256_ONBRIGHTYELLOW = 224,
		iCOLOR256_ONBRIGHTWHITE = 240,
		// Background colors
		iCOLOR256_iCOLOR256_WHITE = 255;

//default colors
const int iDEFAULTCOLOR256_FG = iCOLOR256_BRIGHTGREEN,
		iDEFAULTCOLOR256_BG = iCOLOR256_ONBLUE,
		iDEFAULTCOLOR256_TEXT = iCOLOR256_BRIGHTWHITE;

const int iMAXBYTEVALUE = 0xFF, //255
		iUNINITIALIZED_VALUE = -1;

//Dock position
const int iDOCKPOSITION_NONE = 0x00,
		iDOCKPOSITION_TOP = 0x01,
		iDOCKPOSITION_LEFT = 0x02,
		iDOCKPOSITION_BOTTOM = 0x03,
		iDOCKPOSITION_RIGHT = 0x04;

//XControlEvent Type
const int iXCONTROLEVENTTYPE_MINVALUE = 0x01,
		iXCONTROLEVENTTYPE_PAINT = 0x01,
		iXCONTROLEVENTTYPE_FOCUS = 0x02,
		iXCONTROLEVENTTYPE_RESIZE = 0x03,
		iXCONTROLEVENTTYPE_CREATE = 0x04,
		iXCONTROLEVENTTYPE_DATA = 0x05,
		iXCONTROLEVENTTYPE_MAXVALUE = 0x05;
//const String sXWINTABSVIEWNAME = "tabs";

class SysInfo {
	static int SYSINFOGRP_SYS = 0;
	static int SYSINFOGRP_SYS_VERSION = 0;
	static int SYSINFOGRP_SYS_PAGESIZE = 1;
	static int SYSINFOGRP_SYS_SIZEOFINT = 2;
	static int SYSINFOGRP_SYS_ISLITTLEINDIAN = 3;

	static int SYSINFOGRP_WBER = 1;
	static int SYSINFOGRP_WBER_WIDTH = 0;
	static int SYSINFOGRP_WBER_HEIGHT = 1;

	List _sysinfo(int iGrp) native "DXCGetSysInfo";
	List getGroup(int iGrp) => _sysinfo(iGrp);
}

class DXConsole extends AnsiPen {
	//ANSI Control Sequence Introducer, signals the terminal for new settings.
	//PERF: Avoid overhead in string interpolation ${ANSI_ESC}, use const String \x1B instead
	//Show the cursor.
	static const String ANSICMD_CURSOR_SHOW = "\x1B[?25h";
	//Hide the cursor.
	static const String ANSICMD_CURSOR_HIDE = "\x1B[?25l";

	static const String ANSICMD_BELL = "\x1B]\x07";//ESC]BEL
	static const String ANSICMD_ERASE0J_FROM_CURSOR_TO_DISPLAYEND = "\x1B[0J";
	static const String ANSICMD_ERASE1J_FROM_START_TO_CURSOR = "\x1B[1J";
	static const String ANSICMD_ERASE2J_CLEARSCREEN_HOME_CURSOR = "\x1B[2J";
	static const String ANSICMD5n_DEVICE_STATUS_REPORT = "\x1B[5n";
	static const String ANSICMD6n_DEVICE_STATUS_CURSOR_POS = "\x1B[6n";
	static const String ANSICMD_WINDOW_TITLE_t = "\x1B[21t";
	static const String ANSICMD_SAVE_CURSOR_POS_s = "\x1B[s";
	static const String ANSICMD_RETURN_SAVED_CURSOR_POS_u = "\x1B[u";
//Reset all colors and options for current SGRs to terminal defaults.
	static const String ANSICMD_DEFAULT = "\x1B[0m";
//Defaults the terminal's foreground color without altering the background.
	static const String ANSICMD_RESETFOREGROUND = "\x1B[39m";
//Defaults the terminal's background color without altering the foreground.
	static const String ANSICMD_RESETBACKGROUND = "\x1B[49m";

//	static const String _CMD_ERASE_J = "J";
//	static const int _ERASE0J_FROM_CURSOR_TO_DISPLAYEND = 0;
//	static const int _ERASE1J_FROM_START_TO_CURSOR = 1;
//	static const int _ERASE2J_CLEARSCREEN_HOME_CURSOR = 2;

	static const String _CMD_CLEAR_K = "K";

	static const int _ERASE0K_CLEAR_TO_ENDOFLINE = 0;
	/// ESC[0K Clear to end of line
	static const int _ERASE1K_CLEAR_FROM_STARTOFLINE_TO_CURSOR = 1;
	static const int _ERASE2K_CLEAR_WHOLELINE = 2;

/// ESC[#X Erase # characters.
	String getANSICMD_ERASE_CHARS_X(int iChars) => "\x1B[${iChars}X";

	/// ESC[#L Insert # blank lines.
	String getANSICMD_INSERT_BLANKLINES_L(int iChars) => "\x1B[${iChars}L";

	/// ESC[#@ Insert # blank characters.
	String getANSICMD_INSERT_BLANKLINES_AMPERSAND(int iChars) => "\x1B[${iChars}@";

	/// ESC[#M Delete # lines.
	String getANSICMD_DELETE_LINES_M(int iChars) => "\x1B[${iChars}M";

	/// ESC[#P Delete # characters.
	String getANSICMD_DELETE_CHARS_P(int iChars) => "\x1B[${iChars}P";

	/// ESC[#A Moves cursor up # lines
	String getANSICMD_MOVE_CURSORUP_LINES_A(int iChars) => "\x1B[${iChars}A";

	/// ESC[#B Moves cursor down # lines
	String getANSICMD_MOVE_CURSORDOWN_LINES_B(int iChars) => "\x1B[${iChars}B";

	/// ESC[#C Moves cursor forward # spaces
	String getANSICMD_MOVE_CURSORFORWARD_SPACES_C(int iChars) => "\x1B[${iChars}C";

	/// ESC[#D Moves cursor back # spaces
	String getANSICMD_MOVE_CURSORBACKWARD_SPACES_D(int iChars) => "\x1B[${iChars}D";

	/// ESC[#E Moves cursor down # lines, column 1.
	String getANSICMD_MOVE_CURSORDOWN_LINES_COL1_E(int iChars) => "\x1B[${iChars}E";

	/// ESC[#F Moves cursor up # lines, column 1.
	String getANSICMD_MOVE_CURSORUP_LINES_COL1_F(int iChars) => "\x1B[${iChars}F";

	/// ESC[#G Moves cursor column # in current row.
	String getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(int iChars) => "\x1B[${iChars}G";

	/// ESC[#d Moves cursor row #, current column.
	String getANSICMD_MOVE_CURSOR_CURRENTCOL_ROW_d(int iChars) => "\x1B[${iChars}d";

	/// ESC[#;#H Moves cursor to line #, column #
	String getANSICMD_MOVE_CURSOR_ROW_COL_H(int iRow, int iCol) => "\x1B[${iRow};${iCol}H";

	//  Global Native Methods
	static bool writeTextDecoded(String sTerminalText) native "DXCWriteDecoded";
	static bool _writeText(String sText, Uint8List parms) native "DXCWriteString";
	static bool writeText(String sText, int iRow, int iCol, int iColor256) {
		Uint8List _u8lParms3 = new Uint8List(3);
		assert(iRow >= 0 && iRow <= iMAXBYTEVALUE);
		assert(iCol >= 0 && iCol <= iMAXBYTEVALUE);
		assert(iColor256 >= 0 && iColor256 <= iMAXBYTEVALUE);
		_u8lParms3[0] = iRow;
		_u8lParms3[1] = iCol;
		_u8lParms3[2] = iColor256;
		return _writeText(sText, _u8lParms3);
	}
	static bool writeFromFile(String sFilename) native "DXCWriteFromFile";
	static bool clearRect(Uint8List u8lParms) native "DXCWindowClearRect";
	static bool sendKeys(String sKBChars, [int wVirtualKeyCode = iVK_RETURN, int wVirtualScanCode = 0, int dwControlKeyState = 0]) native "DXCSendKeys";

	//static bool ConsoleCmds(List<XCommand> listCmds) native "ConsoleCmds";
	//static bool runTest() native "RunTest";
	//static bool testCustomErrors() native "TestCustomErrors";

	/**
     * Redirect AnsiPen's output via our writeraw
     */
	@override
	String write(String msg) {
		String _str = super.write(msg);
		writeTextDecoded(_str);
		return _str;
	}
}

class XControlEvent {
	final int iEType;
	final Completer completer = new Completer();

	XControlEvent(this.iEType) {
		assert(iEType >= iXCONTROLEVENTTYPE_MINVALUE && iEType <= iXCONTROLEVENTTYPE_MAXVALUE);
	}
}
class XControlEventResize extends XControlEvent {
	final int iPosX, iPosY, iHeight, iWidth;
	final bool bTopLevelWindow;

	XControlEventResize(this.iPosX, this.iPosY, this.iHeight, this.iWidth, [bool this.bTopLevelWindow = true]) : super(iXCONTROLEVENTTYPE_RESIZE);
}
class XControlEventFocus extends XControlEvent {
	bool bGotFocus;
	bool bRepaint;
	XControlEventFocus([bool this.bGotFocus = true, bool this.bRepaint = true]) : super(iXCONTROLEVENTTYPE_FOCUS);
}
class XControlEventCreate extends XControlEvent {
	final bool bPaint;

	XControlEventCreate([bool this.bPaint = true]) : super(iXCONTROLEVENTTYPE_CREATE);
}
class XControlEventData extends XControlEvent {
	final dynamic data;
	XControlEventData(dynamic this.data) : super(iXCONTROLEVENTTYPE_DATA);
}

///XControl attribute indexes
//class XControlAttr<int> extends Enum<int> {
//	const XControlAttr(int val, String name) : super(val, name);
//	static const XControlAttr iATTRBITFLAGS = const XControlAttr(0, "iATTRBITFLAGS");
//	static const XControlAttr iATTRPOSX = const XControlAttr(1, "iATTRPOSX");
//	static const XControlAttr iATTRPOSY = const XControlAttr(2, "iATTRPOSY");
//	static const XControlAttr iATTRHEIGHT = const XControlAttr(3, "iATTRHEIGHT");
//	static const XControlAttr iATTRWIDTH = const XControlAttr(4, "iATTRWIDTH");
//	static const XControlAttr iATTRBORDERCOLOR = const XControlAttr(5, "iATTRBORDERCOLOR");
//	static const XControlAttr iATTRTEXTCOLOR = const XControlAttr(6, "iATTRTEXTCOLOR");
//	static const XControlAttr iATTRBORDERFILLCHAR = const XControlAttr(7, "iATTRBORDERFILLCHAR");
//	static const XControlAttr iATTRCOLORPALLETE = const XControlAttr(8, "iATTRCOLORPALLETE");
//	static const XControlAttr iATTRCONTROLTYPE = const XControlAttr(9, "iATTRCONTROLTYPE");
//	static const XControlAttr iATTRMAXSIZE = const XControlAttr(10, "iATTRMAXSIZE");
//}

abstract class XControl {
//PERF:Declare static/final int, Enum value lookups are inefficient
//DONOT change, it is used by native extension
	//Window/control attribute bitflags
	//BITVAL1 = BorderType
	//BITPOS2 = BorderType
	//BITPOS3 = Has focus
	//BITPOS4 = Disabled
	//BITPOS5 = Visible
	//BITPOS6 = Field type Number
	//BITPOS7 = Field type Float
	static int iPROPMASKBORDER = 0x03,//bit1-2
			iPROPMASKHASFOCUS = 0x04,//bit3
			iPROPMASKENABLED = 0x08,//bit4
			iPROPMASKVISIBLE = 0x10,//bit5
			iPROPMASKFIELDTYPENUMBER = 0x20,//bit6
			iPROPMASKFIELDTYPEDOUBLE = 0x40 //bit7
	;

//DONOT change, it is used by native extension
	static int iATTRBITFLAGS = 0,
			iATTRPOSX = 1,
			iATTRPOSY = 2,
			iATTRHEIGHT = 3,
			iATTRWIDTH = 4,
			iATTRBORDERCOLOR = 5,
			iATTRTEXTCOLOR = 6,
			iATTRBORDERFILLCHAR = 7,
			iATTRCOLORPALLETE = 8,
			iATTRCONTROLTYPE = 9,
			iATTRMAXSIZE = 10;

//PERF:Declare static/final int, Enum value lookups are inefficient
//DONOT change, it is used by native extension
	static int iATTRCONTROLTYPE_FIELD = 1,
			iATTRCONTROLTYPE_TAB = 2,
			iATTRCONTROLTYPE_STATUSBAR = 3,
			iATTRCONTROLTYPE_WINDOW = 4,
			iATTRCONTROLTYPE_TEXT = 5,
			iATTRCONTROLTYPE_SCROLL = 6,
			iATTRCONTROLTYPE_DROPDOWNLIST = 7,
//ALWAYS HIGHEST VALUE
			iATTRCONTROLTYPEMAXSIZE = 7;

//DONOT change, it is used by native extension
	static int //Border type values
	iPROPBITSBORDERTYPENONE = 0,
			iPROPBITSBORDERTYPEBOX1 = 1,
			iPROPBITSBORDERTYPEBOX2 = 2,
			iPROPBITSBORDERTYPECUSTOM = 3,
			//Field type values
			iPROPBITSFIELDTYPESTRING = 0,
			iPROPBITSFIELDTYPENUMBER = 1,
			iPROPBITSFIELDTYPEFLOAT = 2;

	//Native extension methods
	bool _nxFnPaint(int hPeer, [dynamic args]) native "DXCWindowPaint";
	bool _nxFnDataChanged(int hPeer, dynamic _data) native "DXCEvtDataChanged";
	bool _nxFnFocusChanged(int hPeer, bool bGotFocus, bool bRepaint) native "DXCEvtFocusChanged";

	//DONOT change _nxPeer, it is used by native extension
	int _nxPeer = 0;

	//window attributes
	//DONOT change _nxu8lAttrs, it is used by native extension
	final Uint8List _nxu8lAttrs = new Uint8List(iATTRMAXSIZE);

	XControl(int iControlType, [int iPosX = 0, int iPosY = 0, int iHeight = 25, int iWidth = 80]) {
		assert(iControlType > 0 && iControlType <= iMAXBYTEVALUE);
		_nxu8lAttrs[iATTRCONTROLTYPE] = iControlType;
		//init property flags
		_nxu8lAttrs[iATTRBITFLAGS] = iPROPMASKENABLED | iPROPMASKVISIBLE;
		//init attributes
		_nxu8lAttrs[iATTRBORDERCOLOR] = iDEFAULTCOLOR256_FG | iDEFAULTCOLOR256_BG;
		_nxu8lAttrs[iATTRTEXTCOLOR] = iDEFAULTCOLOR256_TEXT | iDEFAULTCOLOR256_BG;
		setSize(iPosX, iPosY, iHeight, iWidth);
	}

	XControl.fromAttrs(Uint8List attributes) {
		assert(attributes.length == iATTRMAXSIZE);
		_nxu8lAttrs.setAll(0, attributes);
	}

	void setSize(int iPosX, int iPosY, int iHeight, int iWidth) {
		assert(iPosX >= 0);
		assert(iPosY >= 0);
		assert(iHeight > 0);
		assert(iWidth > 0);
		//clamp max values
		if (iPosX > iMAXBYTEVALUE) iPosX = iMAXBYTEVALUE;
		if (iPosY > iMAXBYTEVALUE) iPosY = iMAXBYTEVALUE;
		if (iHeight > iMAXBYTEVALUE) iHeight = iMAXBYTEVALUE;
		if (iWidth > iMAXBYTEVALUE) iWidth = iMAXBYTEVALUE;
		_nxu8lAttrs[iATTRPOSX] = iPosX;
		_nxu8lAttrs[iATTRPOSY] = iPosY;
		_nxu8lAttrs[iATTRHEIGHT] = iHeight;
		_nxu8lAttrs[iATTRWIDTH] = iWidth;
	}
	bool setProperty(int iPropMask, bool bOn) {
		bool bResult = false;
		if (iPropMask >= 0 && iPropMask < iMAXBYTEVALUE) {
			if (bOn) {
				_nxu8lAttrs[iATTRBITFLAGS] |= iPropMask;
			} else {
				_nxu8lAttrs[iATTRBITFLAGS] &= ~iPropMask;
			}
			bResult = true;
		}
		return bResult;
	}

	//EVENT HANDLERS
	bool _onCreate(XControlEventCreate evt) => false;
	//bool _onDataChange(XControlEventData evt) => false;
	bool _onFocusChange(XControlEventFocus evt) {
		assert(_nxPeer > 0);
		if (bDEBUGMODEDXCONSOLE) {
			//TODO:Verify iPROPMASKENABLED
			//ensure can get focus
			//if (evt.bGotFocus) assert(_nxu8lAttrs[iATTRBITFLAGS] & iPROPMASKENABLED == iPROPMASKENABLED);
		}
		return _nxFnFocusChanged(_nxPeer, evt.bGotFocus, evt.bRepaint);
	}
	bool _onPaint();
	//update XWindow(peer) attributes
	bool _onResize(XControlEventResize evt) {
		if (evt.bTopLevelWindow) {
			assert(evt.iPosX >= 0 && evt.iPosY >= 0 && evt.iHeight > 0 && evt.iWidth > 0);
			//update XWindow::this position/size attributes
			_nxu8lAttrs[XControl.iATTRPOSX] = evt.iPosX;
			_nxu8lAttrs[XControl.iATTRPOSY] = evt.iPosY;
			//save new dimensions
			_nxu8lAttrs[XControl.iATTRHEIGHT] = evt.iHeight;
			_nxu8lAttrs[XControl.iATTRWIDTH] = evt.iWidth;
		} else {
			//apply delta X/Y to XWindow::this position/size attributes
			_nxu8lAttrs[XControl.iATTRPOSX] += evt.iPosX;
			_nxu8lAttrs[XControl.iATTRPOSY] += evt.iPosY;
		}

		return false;
	}

	bool paint() => _onPaint();

/// Defines foreground & background colors
/// validation rules:
///    color values: 0..	255
/// 		[iFgColor] != [iBgColor]
/// 		[iPallete]: 0..15
	bool colors(int iTextColor, [int iBorderColor = iDEFAULTCOLOR256_FG | iDEFAULTCOLOR256_BG, int iPallete = 0]) {
		bool bResult = true;
		//validation rules
		if (iTextColor < 0 || iTextColor > iMAXBYTEVALUE) {
			iTextColor = iDEFAULTCOLOR256_FG | iDEFAULTCOLOR256_BG;
			bResult = false;
		}
		if (iBorderColor < 0 || iBorderColor > iMAXBYTEVALUE) {
			iBorderColor = iDEFAULTCOLOR256_FG | iDEFAULTCOLOR256_BG;
			bResult = false;
		}
		//TODO:WhatIf we want hidden text???
//		if (iFgColor == iBgColor) {
//			iFgColor = ANSIFGCOLOR;
//			iBgColor = ANSIBGCOLOR;
//			bResult = false;
//		}
		if (iPallete < 0 || iPallete > 15) {
			iPallete = 0;
			bResult = false;
		}
		_nxu8lAttrs[XControl.iATTRTEXTCOLOR] = iTextColor;
		_nxu8lAttrs[XControl.iATTRBORDERCOLOR] = iBorderColor;
		_nxu8lAttrs[XControl.iATTRCOLORPALLETE] = iPallete;
		return bResult;
	}
//	void dump(String sName) {
//		HexDump _hd = new HexDump();
//		stderr.writeln("DUMPATTRS $sName total=${XControl.iATTRMAXSIZE}");
//		for (int i = 0; i < XControl.iATTRMAXSIZE; i++) {
//			stderr.writeln("...$i=${_nxu8lAttrs[i]} ${_hd.binary(_nxu8lAttrs[i])}");
//		}
//	}
}

class XScrollView extends XControl {
	//iHeight defaults to 1 line
	//TODO:Make iPosX/iPosY relative to parent window not screen
	XScrollView(int iPosX, int iPosY, int iWidth, [int iHeight = 1, int iDockPosition = iDOCKPOSITION_NONE]) : super(XControl.iATTRCONTROLTYPE_SCROLL, iPosX, iPosY, iHeight, iWidth) {
		//if (bDEBUGMODE) dump("XScroll");
		//TODO:Currently supports iDOCKPOSITION_BOTTOM & iDOCKPOSITION_NONE
		_nxFnCreate(iDockPosition == iDOCKPOSITION_BOTTOM);
	}

	//Native extension methods
	bool _nxFnCreate(bool bDockBottom) native "DXCCntlScrollCreate";
	bool _nxFnPrint(int hPeer, String sMsg, [int iColor]) native "DXCCntlScrollPrint";

	@override
	bool _onPaint() {
		assert(_nxPeer > 0);
		//Peer does not store value, passed here as argument
		return _nxFnPaint(_nxPeer);
	}
	bool resize(int iPosX, int iPosY, int iWidth, int iHeight, [int iDockPosition = iDOCKPOSITION_NONE]) {
		assert(_nxPeer > 0);
		setSize(iPosX, iPosY, iHeight, iWidth);
		//_nxFnCreate resizes rectangle dimensions of existing _nxPeer if exists else its created
		return _nxFnCreate(iDockPosition == iDOCKPOSITION_BOTTOM) != false;
	}

	///[iColor] Overrides default XControl.iATTRTEXTCOLOR color value
	bool print(String _msg, [int iColor, bool bNewline = true]) {
		assert(_nxPeer > 0);
		if (bNewline) _msg += "\n";
		///Peer does not store the _msg value, passed the _msg here as an argument
		return _nxFnPrint(_nxPeer, _msg, iColor);
	}
}

class XListBox extends XControl {
	//Native extension methods
	//int _menuSelectOption(List<String> listOpts, String sTitle) native "DXCCntlListBox";

	XListBox(int iPosX, int iPosY, int iWidth, int iHeight) : super(XControl.iATTRCONTROLTYPE_DROPDOWNLIST, iPosX, iPosY, iHeight, iWidth);
	@override
	bool _onPaint() {
		assert(_nxPeer > 0);
		//Peer does not store value, passed here as argument
		return _nxFnPaint(_nxPeer);
	}
}
class XText extends XControl {
	//TODO: XText needs text-wrap and newline('\n') support.
	/// label text
	//DONOT change fieldname:nxsText, it is used by native extension
	String nxsText = "";

	//iHeight defaults to 1 line
	//TODO:Make iPosX/iPosY relative to parent window not screen
	XText(int iPosX, int iPosY, int iWidth, [int iHeight = 1]) : super(XControl.iATTRCONTROLTYPE_TEXT, iPosX, iPosY, iHeight, iWidth);

	//@override
	bool _onPaint() {
		assert(_nxPeer > 0);
		assert(nxsText != null);
		//Peer does not store value, passed here as argument
		return _nxFnPaint(_nxPeer, nxsText);
	}
}

abstract class XInput extends XControl {
	/// label text (Optional)
	String nxsLabel; //DONOT change fieldname:nxsLabel, it is used by native extension
	dynamic _nxvarValue; //DONOT change fieldname:_nxvarValue, it is used by native extension
	/// printf style format for _nxvarValue (Optional)
	String nxsFormat; //DONOT change fieldname:format, it is used by native extension

	///iHeight defaults to 1 line
	//TODO:Make iPosX/iPosY relative to parent window not screen
	XInput(int iPosX, int iPosY, int iWidth, [int iHeight = 1, int iPropType = 0]) : super(XControl.iATTRCONTROLTYPE_FIELD, iPosX, iPosY, iHeight, iWidth) {
		//assert(XTerm.writeText("type:${iPropType} " + showBinary(_nxu8lAttrs[XControl.iATTRBITFLAGS]), 30, 0, 7));
		//clear type defaults to String type
		_nxu8lAttrs[XControl.iATTRBITFLAGS] &= ~(XControl.iPROPMASKFIELDTYPENUMBER | XControl.iPROPMASKFIELDTYPEDOUBLE);
		//assert(XTerm.writeText("clear type:${iPropType} " + showBinary(_nxu8lAttrs[XControl.iATTRBITFLAGS]), 31, 0, 7));

		if (iPropType == XControl.iPROPBITSFIELDTYPENUMBER) {
			_nxu8lAttrs[XControl.iATTRBITFLAGS] |= XControl.iPROPMASKFIELDTYPENUMBER;
			_nxvarValue = 0;
		} else if (iPropType == XControl.iPROPBITSFIELDTYPEFLOAT) {
			_nxu8lAttrs[XControl.iATTRBITFLAGS] |= XControl.iPROPMASKFIELDTYPEDOUBLE;
			_nxvarValue = 0.0;
		} else {
			//default to String
			_nxvarValue = "";
		}
		//assert(XTerm.writeText("set type:${iPropType} " + showBinary(_nxu8lAttrs[XControl.iATTRBITFLAGS]), 32, 0, 7));
	}

	set _value(dynamic _val) {
		_nxvarValue = _val;
		//verify Peer exists
		if (_nxPeer > 0) {
			_nxFnDataChanged(_nxPeer, _nxvarValue);
		}
	}

	//@override
	//bool _onCreate(XControlEventCreate evt) => super._onCreate(evt);
	//@override
	//bool _onFocusChange(XControlEventFocus evt);
	//@override
	bool _onPaint() {
		assert(_nxPeer > 0);
		return _nxFnPaint(_nxPeer, _nxvarValue);
	}
}
class XInputString extends XInput {
	//iHeight defaults to 1 line
	//TODO:Make iPosX/iPosY relative to parent window not screen
	XInputString(int iPosX, int iPosY, int iWidth, [int iHeight = 1]) : super(iPosX, iPosY, iWidth, iHeight, XControl.iPROPBITSFIELDTYPESTRING);
	String get value => _nxvarValue;
	set value(String _val) => super._value = _val;
}
class XInputNumber extends XInput {
	//iHeight defaults to 1 line
	//TODO:Make iPosX/iPosY relative to parent window not screen
	XInputNumber(int iPosX, int iPosY, int iWidth, [int iHeight = 1]) : super(iPosX, iPosY, iWidth, iHeight, XControl.iPROPBITSFIELDTYPENUMBER);
	int get value => _nxvarValue;
	set value(int _val) => super._value = _val;
}
class XInputDouble extends XInput {
	//iHeight defaults to 1 line
	//TODO:Make iPosX/iPosY relative to parent window not screen
	XInputDouble(int iPosX, int iPosY, int iWidth, [int iHeight = 1]) : super(iPosX, iPosY, iWidth, iHeight, XControl.iPROPBITSFIELDTYPEFLOAT);
	double get value => _nxvarValue;
	set value(double _val) => super._value = _val;
}

class XTab {
	final String _sLabel;
	final int _iPosX, _iPosY;
	XWindow _xwin;
	String onSelectedMsg;
	CALLBACKTABEVENT cbFnPaint;
	CALLBACKTABEVENT cbFnEvtHandler;
	bool bEnabled = true,
			bSelected = false;
	XTab(String this._sLabel, int this._iPosX, [int this._iPosY = 0, XWindow this._xwin]);
	XWindow get xwin => _xwin;
	set xwin(XWindow x) => _xwin = x;
}

class XTabStrip extends XControl {
	final Uint8List _u8lAttrsContentArea = new Uint8List(XControl.iATTRMAXSIZE);//content dimensions witin the parent window
	List<XTab> _listTabs;
	XTab xtabCachedCurrent;
	int _iCurrTab = iUNINITIALIZED_VALUE,
			_iColor256_Enabled,
			_iColor256_Disabled,
			_iColor256_Selected;

	XTabStrip(int iPosX, int iPosY, int iHeight, int iWidth) : super(XControl.iATTRCONTROLTYPE_TAB, iPosX, iPosY, iHeight, iWidth) {
		//TODO: Currently supports/assumes only 1 line of XTab controls

		//update XTabStrip(this) contentarea position/size attributes
		_nxu8lAttrs[XControl.iATTRBITFLAGS] = XControl.iPROPBITSBORDERTYPENONE;
		_u8lAttrsContentArea[XControl.iATTRPOSX] = iPosX + 1;
		_u8lAttrsContentArea[XControl.iATTRPOSY] = iPosY + 1;
		_u8lAttrsContentArea[XControl.iATTRHEIGHT] = iHeight;
		_u8lAttrsContentArea[XControl.iATTRWIDTH] = iWidth;
		_u8lAttrsContentArea[XControl.iATTRTEXTCOLOR] = iCOLOR256_ONCYAN;
		_u8lAttrsContentArea[XControl.iATTRBORDERCOLOR] = iCOLOR256_ONBRIGHTBLUE;
	}

	XTab operator [](int idx) {
		if (idx >= 0 && idx < _listTabs.length) {
			return _listTabs[idx];
		} else {
			return null;
		}
	}

	int get iCurrTab => _iCurrTab;
	set iCurrTab(int iTab) {
		assert(_listTabs != null);
		//check max
		if (iTab >= _listTabs.length) iTab = _listTabs.length - 1;
		//check min
		if (iTab < 0) _iCurrTab = 0;
		_iCurrTab = _moveTo(iTab);
	}

	void tabs(List<XTab> fixedlistTabs, int iAnsiColorEnabled, int iAnsiColorDisabled, int iAnsiColorSelected) {
		assert(iAnsiColorEnabled >= 0 && iAnsiColorEnabled <= iMAXBYTEVALUE);
		assert(iAnsiColorDisabled >= 0 && iAnsiColorDisabled <= iMAXBYTEVALUE);
		assert(iAnsiColorSelected >= 0 && iAnsiColorSelected <= iMAXBYTEVALUE);
		assert(fixedlistTabs.length > 0);

		_iColor256_Enabled = iAnsiColorEnabled;
		_iColor256_Disabled = iAnsiColorDisabled;
		_iColor256_Selected = iAnsiColorSelected;
		_listTabs = fixedlistTabs;

		//default first tab as "selected"
		_iCurrTab = 0;
		xtabCachedCurrent = _listTabs[0];
		xtabCachedCurrent.bSelected = true;
	}

	int _moveTo(int iRequestedTab) {
		XTab _tab = _listTabs[iRequestedTab];
		//has current tab changed?
		if (iRequestedTab != _iCurrTab && _tab.bEnabled) {
			if (_iCurrTab != iUNINITIALIZED_VALUE) _listTabs[_iCurrTab].bSelected = false;
			//dispatch lost focus to current tab window
			XWindow _xwin = _listTabs[_iCurrTab].xwin;
			if (_xwin != null) _xwin.dispatch(new XControlEventFocus(false, false));

			_tab.bSelected = true;
			_iCurrTab = iRequestedTab;

			//dispatch lost focus to current tab window
			_xwin = _tab.xwin;
			if (_xwin != null) _xwin.dispatch(new XControlEventFocus(true));
			//paint the tabs
			_onPaint();
		}
		return _iCurrTab;
	}

	XTab prev() {
		assert(_iCurrTab != iUNINITIALIZED_VALUE);
		int iSaveTab = _iCurrTab - 1,
				iLastTab = _listTabs.length - 1,
				idx = iLastTab;
		while (idx-- >= 0) {
			if (iSaveTab < 0) iSaveTab = iLastTab; //loop back to iLastTab
			if (_listTabs[iSaveTab].bEnabled) break;
			iSaveTab--;
		}
		xtabCachedCurrent = _listTabs[_moveTo(iSaveTab)];
		return xtabCachedCurrent;
	}

	XTab next() {
		assert(_iCurrTab != iUNINITIALIZED_VALUE);
		int iSaveTab = _iCurrTab + 1,
				iLastTab = _listTabs.length - 1,
				idx = iLastTab;
		while (idx-- >= 0) {
			if (iSaveTab > iLastTab) iSaveTab = 0; //loop back to 0
			if (_listTabs[iSaveTab].bEnabled) break;
			iSaveTab++;
		}
		xtabCachedCurrent = _listTabs[_moveTo(iSaveTab)];
		return xtabCachedCurrent;
	}

	//@override
	//bool _onCreate(XControlEventCreate evt) => super._onCreate(evt);
	//@override
	//bool _onFocusChange(XControlEventFocus evt) => super._onFocusChange(evt);
	@override
	bool _onResize(XControlEventResize evt) {
		assert(evt.bTopLevelWindow == false);
		//update XTabStrip(this) position/size attributes
		_nxu8lAttrs[XControl.iATTRPOSX] += evt.iPosX;
		_nxu8lAttrs[XControl.iATTRPOSY] += evt.iPosY;
		_nxu8lAttrs[XControl.iATTRHEIGHT] += evt.iHeight;
		_nxu8lAttrs[XControl.iATTRWIDTH] += evt.iWidth;
		//update XTabStrip(this) contentarea position/size attributes
		_u8lAttrsContentArea[XControl.iATTRPOSX] += evt.iPosX;
		_u8lAttrsContentArea[XControl.iATTRPOSY] += evt.iPosY;
		_u8lAttrsContentArea[XControl.iATTRHEIGHT] += evt.iHeight;
		_u8lAttrsContentArea[XControl.iATTRWIDTH] += evt.iWidth;
		if (_listTabs != null) {
			int iLen = _listTabs.length;
			XWindow _xwin;
			//dispatch resize to all children
			for (int idx = 0; idx < iLen; idx++) {
				_xwin = _listTabs[idx].xwin;
				//if (_xwin != null) _xwin.dispatch(new XControlEventResize(evt.iPosX, evt.iPosY, evt.iHeight, evt.iWidth, false));
				if (_xwin != null) _xwin._onResize(evt);
			}
		}

		return true;
	}

	@override
	bool _onPaint() {
		XTab xtab;
		int idx = _listTabs.length,
				iColor256;
		final bool bResult = (idx > 0);
		//clear content area rectangle
		DXConsole.clearRect(_u8lAttrsContentArea);

		if (bResult == true) {
			int _iPosX = _nxu8lAttrs[XControl.iATTRPOSX],
					_iPosY = _nxu8lAttrs[XControl.iATTRPOSY];

			//draw tabs using colors based on state
			while (idx-- > 0) {
				xtab = _listTabs[idx];
				if (xtab.bSelected == true) {
					iColor256 = _iColor256_Selected;
					if (xtab.cbFnPaint != null) {
						//pass control of the clientarea to fnCallback
						xtab.cbFnPaint(xtab, _u8lAttrsContentArea);
					}
				} else if (xtab.bEnabled == true) {
					iColor256 = _iColor256_Enabled;
				} else {
					iColor256 = _iColor256_Disabled;
				}
				//draw tab relative to tabstrip X/Y
				DXConsole.writeText(xtab._sLabel, xtab._iPosY + _iPosY, xtab._iPosX + _iPosX, iColor256);
			}
		}
		return bResult;
	}
}

class XWindow extends XControl {
//PERF:Declare static/final int, Enum value lookups are inefficient
//DONOT change, it is used by native extension
	final int iBOXCHARS_TOPLEFT = 0,
			iBOXCHARS_TOPRIGHT = 1,
			iBOXCHARS_BOTTOMLEFT = 2,
			iBOXCHARS_BOTTOMRIGHT = 3,
			iBOXCHARS_HORIZONTAL = 4,
			iBOXCHARS_VERTICAL = 5,
			iBOXCHARS_MIDLEFT = 6,
			iBOXCHARS_MIDRIGHT = 7,
			iBOXCHARS_MIDTOP = 8,
			iBOXCHARS_MIDBOTTOM = 9;

	List<XControl> _nxlistChildren; //DONOT change fieldname:siblings, it is used by native extension
	String _sInfomsg, nxsLabel; //DONOT change fieldname:title, it is used by native extension
	int _iIdxCurrFocusedControl = iUNINITIALIZED_VALUE;

	//Native extension methods
	void _nxFnInfoMsg(int hXWinPeer, String sMsg) native "DXCCntlWinInfoMsg";
	int _nxFnCreate() native "DXCWindowCreate";
	void _nxFnClose(int hXWinPeer) native "DXCWindowClose";

	XWindow([int iPosX = 0, int iPosY = 0, int iHeight = 25, int iWidth = 80]) : super(XControl.iATTRCONTROLTYPE_WINDOW, iPosX, iPosY, iHeight, iWidth) {
		_initEvtsHdlr();
	}
	XWindow.fromAttrs(Uint8List u8lAttributes) : super.fromAttrs(u8lAttributes) {
		_nxu8lAttrs[XControl.iATTRCONTROLTYPE] = XControl.iATTRCONTROLTYPE_WINDOW;
		_initEvtsHdlr();
	}

	StreamController<XControlEvent> _sc;

	XControl operator [](int idx) {
		if (idx >= 0 && idx < _nxlistChildren.length) {
			return _nxlistChildren[idx];
		} else {
			return null;
		}
	}

	Future<bool> dispatch(XControlEvent evt) {
		_sc.add(evt);
		return evt.completer.future;
	}

	//EVENT HANDLERS
	void _initEvtsHdlr() {
		_sc = new StreamController<XControlEvent>();
		_sc.stream.listen((XControlEvent evt) {
			final int _type = evt.iEType;
			bool bResult = false;
			if (_type == iXCONTROLEVENTTYPE_PAINT) {
				//assert(evt is XControlEvent);
				bResult = _onPaint();
			} else if (_type == iXCONTROLEVENTTYPE_FOCUS) {
				assert(evt is XControlEventFocus);
				bResult = _onFocusChange(evt);
			} else if (_type == iXCONTROLEVENTTYPE_RESIZE) {
				assert(evt is XControlEventResize);
				_onResize(evt);
				bResult = true;
			} else if (_type == iXCONTROLEVENTTYPE_CREATE) {
				assert(evt is XControlEventCreate);
				bResult = _onCreate(evt);
			} else {
				evt.completer.completeError("_initEvtsHdlr:: unsupported iEType:${evt.iEType}");
				return;
			}

			evt.completer.complete();
		});
	}

/// Defines window border type
/// [iBorderType] = true for show border
/// validation rules:
///    border value: [XControl.iPROPBITSBORDERTYPENONE]..[XControl.iPROPBITSBORDERTYPECUSTOM]
	int border(int iBorderType) {
		final int _iFLAGSNOBORDERBITMASK = iMAXBYTEVALUE - XControl.iPROPMASKBORDER;
		//cache flags without border value
		int _iFlags = _nxu8lAttrs[XControl.iATTRBITFLAGS] & _iFLAGSNOBORDERBITMASK;
		//validate iBorderType value range
		if (iBorderType < XControl.iPROPBITSBORDERTYPENONE || iBorderType > XControl.iPROPMASKBORDER) iBorderType = XControl.iPROPBITSBORDERTYPEBOX1;
		_nxu8lAttrs[XControl.iATTRBITFLAGS] = _iFlags + iBorderType;
		return iBorderType;
	}

	void addChildren(List<XControl> ctls) {
		assert(ctls != null);
		if (_nxlistChildren == null) {
			_nxlistChildren = ctls;
		} else {
			_nxlistChildren.addAll(ctls);
		}
//		if (_iIdxCurrFocusedControl == iUNINITIALIZED_VALUE) {
//			XControl xctl = nextEnabled();
//			if (xctl != null) xctl.setProperty(XControl.iPROPBITMASKHASFOCUS, true);
//		}
	}

	set infomsg(String sMsg) {
		assert(sMsg != null);
		assert(_nxPeer > 0);
		_sInfomsg = sMsg;
		_nxFnInfoMsg(_nxPeer, _sInfomsg);
	}

	XControl _findXCtrlEnabled(int iDirection) {
		assert(iDirection == 1 || iDirection == -1);
		if (_nxlistChildren != null) {
			final int iLastCtrl = _nxlistChildren.length - 1;
			XControl xctl/*, oldxctl*/;
			final XControlEventFocus evt = new XControlEventFocus();
			int iCurrCtrl;
			if (_iIdxCurrFocusedControl == iUNINITIALIZED_VALUE) {
				iCurrCtrl = 0;
			} else {
				iCurrCtrl = _iIdxCurrFocusedControl + iDirection;
			}
			//search _nxlistChildren for next enabled xcontrol in iDirection(forward/backward)
			for (int idx = 0; idx <= iLastCtrl; idx++) {
				if (iCurrCtrl < 0) {
					iCurrCtrl = iLastCtrl; //loop back to iLastCtrl
				} else if (iCurrCtrl > iLastCtrl) iCurrCtrl = 0; //loop back to 0
				xctl = _nxlistChildren[iCurrCtrl];
				if ((xctl._nxu8lAttrs[XControl.iATTRBITFLAGS] & XControl.iPROPMASKENABLED) == XControl.iPROPMASKENABLED) {
					//found next enabled xcontrol
					if (_iIdxCurrFocusedControl != iUNINITIALIZED_VALUE) {
						//send previous control lostFocus
						//_nxFnFocusChanged(_nxlistChildren[_iIdxCurrFocusedControl]._nxPeer, false);
						evt.bGotFocus = false;
						_nxlistChildren[_iIdxCurrFocusedControl]._onFocusChange(evt);
					}
					_iIdxCurrFocusedControl = iCurrCtrl;
					evt.bGotFocus = true;
					xctl._onFocusChange(evt);
					return xctl;
				}
				iCurrCtrl += iDirection;
			}
		}
		_iIdxCurrFocusedControl = iUNINITIALIZED_VALUE;
		return null;
	}

	XControl prevEnabled() => _findXCtrlEnabled(-1);
	XControl nextEnabled() => _findXCtrlEnabled(1);

	//@override
	bool _onFocusChange(XControlEventFocus evt) {
		if (_iIdxCurrFocusedControl != iUNINITIALIZED_VALUE) {
			_nxlistChildren[_iIdxCurrFocusedControl]._onFocusChange(new XControlEventFocus(false, false));
		}
		return super._onFocusChange(evt);
	}
	bool _onClose() {
		if (_nxPeer != 0) {
			_nxFnClose(_nxPeer);
			_nxlistChildren = null;
			_nxPeer = 0;
			return true;
		}
		return false;
	}

	@override
	bool _onCreate(XControlEventCreate evt) {
		bool bResult;
		_onClose();
		_nxPeer = _nxFnCreate();
		bResult = (_nxPeer != 0);
		if (bResult && evt.bPaint) bResult = _onPaint();
		return bResult;
	}

	@override
	bool _onPaint() {
		bool bResult = false;
		if (_nxPeer != 0) {
			bResult = _nxFnPaint(_nxPeer);
			if (bResult) {
				if (_sInfomsg != null) _nxFnInfoMsg(_nxPeer, _sInfomsg);
				//paint children
				if (_nxlistChildren != null) {
					int iLen = _nxlistChildren.length;
					//dispatch resize to all children
					for (int idx = 0; idx < iLen; idx++) {
						_nxlistChildren[idx]._onPaint();
					}

				}

			}
		}
		return (bResult);
	}

/// Update position/size attributes for the parent window and its child controls
/// [bTopLevelWindow]
/// 	true=top level/parent window, values are actual dimensions
/// 	false=subcontrol/childwindow, values are parent delta dimensions
	@override
	bool _onResize(XControlEventResize evt) {
		int _iDeltaWidth, _iDeltaHeight, _iDeltaX, _iDeltaY;

		if (evt.bTopLevelWindow) {
			assert(evt.iPosX >= 0 && evt.iPosY >= 0 && evt.iHeight > 0 && evt.iWidth > 0);
			//calc relative/delta change values for child controls
			_iDeltaX = evt.iPosX - _nxu8lAttrs[XControl.iATTRPOSX];
			_iDeltaY = evt.iPosY - _nxu8lAttrs[XControl.iATTRPOSY];
			_iDeltaHeight = evt.iHeight - _nxu8lAttrs[XControl.iATTRHEIGHT];
			_iDeltaWidth = evt.iWidth - _nxu8lAttrs[XControl.iATTRWIDTH];
		} else {
			//calc relative/delta change values for child controls
			_iDeltaX = evt.iPosX;
			_iDeltaY = evt.iPosY;
			_iDeltaHeight = 0;
			_iDeltaWidth = 0;
		}

		//resize/move all the child controls
		if (_nxlistChildren != null) {
			XControlEventResize _evtChild = new XControlEventResize(_iDeltaX, _iDeltaY, _iDeltaHeight, _iDeltaWidth, false);
			int iLen = _nxlistChildren.length;
			//dispatch resize to all children
			for (int idx = 0; idx < iLen; idx++) {
				_nxlistChildren[idx]._onResize(_evtChild);
			}
		}

		//update XWindow(peer) attributes
		return super._onResize(evt);
	}
}

class XTabbedWindow extends XWindow {
	//cache _tabstrip
	XTabStrip _tsCachedTabView;

	XTabbedWindow(XTabStrip ts, [int iPosX = 0, int iPosY = 0, int iHeight = 25, int iWidth = 80]) : super(iPosX, iPosY, iHeight, iWidth) {
		assert(ts != null);
		tabView = ts;
	}

	XTabStrip get tabView => _tsCachedTabView;
	set tabView(XTabStrip ts) {
		_tsCachedTabView = null;
		//add as a child control to automatically process resize & close events
		if (ts != null) addChildren([ts]);
	}

	@override
	bool _onClose() {
		if (super._onClose()) {
			_tsCachedTabView = null;
			return true;
		}
		return false;
	}

	void addChildren(List<XControl> ctls) {
		super.addChildren(ctls);
		if (_tsCachedTabView == null) {
			int iLen = _nxlistChildren.length;
			for (int idx = 0; idx < iLen; idx++) {
				if (_nxlistChildren[idx] is XTabStrip) {
					_tsCachedTabView = _nxlistChildren[idx];
					break;
				}
			}
		}
	}

	bool tabEvt(event) {
		assert(_tsCachedTabView != null);
		XTab xtab = _tsCachedTabView.xtabCachedCurrent;
		CALLBACKTABEVENT cbEvt = xtab.cbFnEvtHandler;
		return cbEvt != null && cbEvt(xtab, event);
	}

	bool tabMove([bool bNext = true]) {
		if (_tsCachedTabView != null) {
			XTab _xtab;
			if (bNext) {
				_xtab = _tsCachedTabView.next();
			} else {
				_xtab = _tsCachedTabView.prev();
			}
			_nxFnInfoMsg(_nxPeer, _xtab.onSelectedMsg);
			return true;
		}
		return false;
	}

}

class XWinMgr {
	List<XWindow> _listXWins;
	int _iCurrXWin = iUNINITIALIZED_VALUE;

	XWinMgr([int iCapacity = 1]) {
		assert(iCapacity > 0);
		_listXWins = new List<XWindow>(iCapacity);
	}

	int get idxCurrent => _iCurrXWin;
	set idxCurrent(int iXWin) {
		assert(_listXWins != null);
		//check max
		if (iXWin >= _listXWins.length) iXWin = _listXWins.length - 1;
		//check min
		if (iXWin < 0) _iCurrXWin = 0;
	}

	void clear() {
		_iCurrXWin = iUNINITIALIZED_VALUE;
		int iLen = _listXWins.length;
		for (int i = 0; i < iLen; i++) _listXWins[i] = null;
	}

	XWindow operator [](int idx) {
		if (idx >= 0 && idx < _listXWins.length) {
			_iCurrXWin = idx;
			return _listXWins[idx];
		} else {
			return null;
		}
	}

	void operator []=(int idx, XWindow value) {
		_listXWins[idx] = value;
		if (_iCurrXWin == iUNINITIALIZED_VALUE) _iCurrXWin = 0;
	}
}
