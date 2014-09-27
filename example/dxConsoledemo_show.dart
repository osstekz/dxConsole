part of dxConsoleDemo;

//-----------------------------------------------
//
//-----------------------------------------------
bool showMMTabFields(XTab xtab, Uint8List attrs) {
	final List<Future<bool>> _listFutures = new List<Future<bool>>();

	XWindow xwinTab1 = xtab.xwin;
	bool bResult = (xwinTab1 != null);
	//does xwinTab1 exit?
	if (!bResult) {
		final int iSTARTROW = 4,
				iSTARTCOL1 = 5,
				iSTARTCOL2 = 25,
				iELEMENTWIDTH = 17;
		//create XWindow object
		try {
			assert(attrs != null && attrs.length == XControl.iATTRMAXSIZE);
			final int iBORDERTYPE = XControl.iPROPBITSBORDERTYPENONE;
			//Define XWindow:sXWINCHILDTAB1 with child controls
			xwinTab1 = new XWindow.fromAttrs(attrs)
					..border(iBORDERTYPE)
					..nxsLabel = "Title: Fields"
					..colors(iCOLOR256_SYSTEM | iCOLOR256_ONCYAN, iCOLOR256_BRIGHTYELLOW | iCOLOR256_ONBRIGHTRED);
			xwinTab1.addChildren([new XInputString(iSTARTCOL1, iSTARTROW, iELEMENTWIDTH)
						..nxsFormat = "%10s"
						..nxsLabel = "String:"
						..value = "14", new XInputString(iSTARTCOL1, iSTARTROW + 2, iELEMENTWIDTH)
						..setProperty(XControl.iPROPMASKENABLED, false)
						..nxsFormat = "%8s"
						..nxsLabel = "Disabled:"
						..value = "2", new XInputNumber(iSTARTCOL1, iSTARTROW + 4, iELEMENTWIDTH)
						..nxsFormat = "%9d"
						..nxsLabel = "Num   : "
						..value = 32, new XInputDouble(iSTARTCOL1, iSTARTROW + 6, iELEMENTWIDTH)
						..nxsFormat = "%10.2f"
						..nxsLabel = "float :"
						..value = 17.32, new XText(iSTARTCOL2, iSTARTROW, iELEMENTWIDTH + 10, 4)
						..colors(iCOLOR256_BLACK | iCOLOR256_ONCYAN)
						..nxsText = "*Programming is like sex,  One mistake and you have to support it for the rest of your life."]);
			//create XWindow object
			_listFutures.add(xwinTab1.dispatch(new XControlEventCreate(false)).then((bResult) {
				//set xwinTab1 as a child control of xtab.xwin
				xtab.xwin = xwinTab1;
			}).catchError((onError) {
				//DXConsole.processText(DXConsole.ANSICMD_BELL + "\x1B[0;30;40mDXConsole.CreateWindow failed\n");
				_unhandledExceptionCallback("showMMTab1 catchError excp: " + onError.toString());
			}));
			bResult = true;
		} catch (e) { // No specified type, handles all
			_unhandledExceptionCallback("showMMTab1 catch excp: " + e.toString());
			//			print("showMainMenu excp: ${e.toString()}");
			//			DXConsole.parseText(DXConsole.ANSICMD_BELL);
		}
	}
	if (bResult) {
		_listFutures.add(xwinTab1.dispatch(new XControlEvent(iXCONTROLEVENTTYPE_PAINT)));
		Future.wait(_listFutures, eagerError: true);
	}

	return bResult;
}
bool showMMTabLog(XTab xtab, Uint8List attrs) {
	final List<Future<bool>> _listFutures = new List<Future<bool>>();

	XWindow xwinTab = xtab.xwin;
	bool bResult = (xwinTab != null);
	//does xwinTab1 exit?
	if (!bResult) {
		final int iSTARTROW = 4,
				iSTARTCOL1 = 5,
				iSTARTCOL2 = 25,
				iELEMENTWIDTH = 17;
		//create XWindow object
		try {
			assert(attrs != null && attrs.length == XControl.iATTRMAXSIZE);
			final int iBORDERTYPE = XControl.iPROPBITSBORDERTYPENONE;
			//Define XWindow:sXWINCHILDTAB1 with child controls
			xwinTab = new XWindow.fromAttrs(attrs)
					..border(iBORDERTYPE)
					..nxsLabel = "Title: Log"
					..colors(iCOLOR256_SYSTEM | iCOLOR256_ONCYAN, iCOLOR256_BRIGHTYELLOW | iCOLOR256_ONBRIGHTRED);
			cachedXInputLogCount = new XInputNumber(iSTARTCOL1, iSTARTROW, iELEMENTWIDTH)
					..setProperty(XControl.iPROPMASKENABLED, false)
					..nxsFormat = "%9d"
					..nxsLabel = "Count  :"
					..value = 0;
			xwinTab.addChildren([cachedXInputLogCount, new XInputNumber(iSTARTCOL1, iSTARTROW + 2, iELEMENTWIDTH)
						..setProperty(XControl.iPROPMASKENABLED, false)
						..nxsFormat = "%9d"
						..nxsLabel = "Errors :"
						..colors(iCOLOR256_BRIGHTWHITE | iCOLOR256_ONRED)
						..value = 0, new XText(iSTARTCOL2, iSTARTROW, iELEMENTWIDTH + 10, 4)
						..colors(iCOLOR256_BLACK | iCOLOR256_ONCYAN)
						..nxsText = "Scrolls top-to-bottom, docked to bottom"]);
			//create XWindow object
			_listFutures.add(xwinTab.dispatch(new XControlEventCreate(false)).then((bResult) {
				//set xwinTab1 as a child control of xtab.xwin
				xtab.xwin = xwinTab;
			}).catchError((onError) {
				//DXConsole.processText(DXConsole.ANSICMD_BELL + "\x1B[0;30;40mDXConsole.CreateWindow failed\n");
				_unhandledExceptionCallback("showMMTabLog catchError excp: " + onError.toString());
			}));
			bResult = true;
		} catch (e) { // No specified type, handles all
			_unhandledExceptionCallback("showMMTabLog catch excp: " + e.toString());
			//			print("showMainMenu excp: ${e.toString()}");
			//			DXConsole.parseText(DXConsole.ANSICMD_BELL);
		}
	}
	if (bResult) {
		_listFutures.add(xwinTab.dispatch(new XControlEvent(iXCONTROLEVENTTYPE_PAINT)));
		Future.wait(_listFutures, eagerError: true);
	}

	return bResult;
}
bool showMainMenu([bool bAttrsChanged = false]) {
	final List<Future<bool>> _listFutures = new List<Future<bool>>();
	final int iPOSX = bShowRuler ? 1 : 0,
			iPOSY = iPOSX,
			iBORDERTYPE = XControl.iPROPBITSBORDERTYPEBOX2,
			//iBORDERTYPE = XControl.ATTRFLAGBORDERTYPENONE,
			iBORDERSIZE = iBORDERTYPE == XControl.iPROPBITSBORDERTYPENONE ? 0 : 1,
			iNAVROW1 = iPOSY + iMAXROWS_MAINMENU - 2,
			iNAVROW2 = iNAVROW1 + 1;
	XTabbedWindow xwinMain = _xwinmgr[iXWINIDX_MAIN];
	bool bResult = xwinMain != null;
	//does mainmenu exit?
	if (!bResult) {
		// Create XWindow object
		try {
			/* Define tabs
			 * HINT:Postion X/Y is zero (0) relative
			 */
			final int iTABROW = 2,
					iTABCOL1 = 2,
					iTABCOL2 = iTABCOL1 + 10,
					iTABCOL3 = iTABCOL2 + 10,
					iTABCOL4 = iTABCOL3 + 10,
					iTABCOL5 = iTABCOL4 + 10,
					iTABCOLHELP = iMAXCOLS_MAINMENU - 7;
			//PERF: Build fixed length tabs
			List<XTab> listTabs = new List<XTab>(6);
			listTabs[0] = new XTab("[Fields]", iTABCOL1)
					..onSelectedMsg = "Demonstrates various field types"
					..cbFnPaint = showMMTabFields
					..cbFnEvtHandler = evthdlrTab1;
			listTabs[1] = new XTab("[Tab2]", iTABCOL2)..onSelectedMsg = "Tab2 Description";
			listTabs[2] = new XTab("[Tab3]", iTABCOL3)
					..onSelectedMsg = "Tab3 Description"
					..bEnabled = false;
			listTabs[3] = new XTab("[Tab4]", iTABCOL4)..onSelectedMsg = "Tab4 Description";
			listTabs[4] = new XTab("[Log]", iTABCOL5)
					..onSelectedMsg = "Logger Description"
					..cbFnPaint = showMMTabLog;
			listTabs[5] = new XTab("[Help]", iTABCOLHELP)..onSelectedMsg = "HelpMe!!!";
			XTabStrip ts = new XTabStrip(0, iTABROW, iNAVROW1 - iTABROW - 1, iMAXCOLS_MAINMENU - iBORDERSIZE)
					..colors(iCOLOR256_BRIGHTBLUE | iCOLOR256_ONCYAN, iCOLOR256_BRIGHTYELLOW | iCOLOR256_ONBLUE) //contentarea colors
					..tabs(listTabs, iCOLOR256_SYSTEM, iCOLOR256_YELLOW, iCOLOR256_BRIGHTYELLOW);
			//define XWindow:Mainmenu
			xwinMain = new XTabbedWindow(ts, iPOSX, iPOSY, iMAXROWS_MAINMENU, iMAXCOLS_MAINMENU)
					..nxsLabel = "dxConsole: Dart Console Library for Windows (FormsMode)"
					..border(iBORDERTYPE);

			//create XWindow object
			_listFutures.add(xwinMain.dispatch(new XControlEventCreate(false)).then((bResult) {
				//save new XWindow object in cached list
				_xwinmgr[iXWINIDX_MAIN] = xwinMain;
			}).catchError((onError) {
				//DXConsole.processText(DXConsole.ANSICMD_BELL + "\x1B[0;30;40mDXConsole.CreateWindow failed\n");
				_unhandledExceptionCallback("showMainMenu catchError excp: " + onError.toString());
			}));
			bResult = true;
		} catch (e) { // No specified type, handles all
			_unhandledExceptionCallback("showMainMenu catch excp: " + e.toString());
			//			print("showMainMenu excp: ${e.toString()}");
			//			DXConsole.parseText(DXConsole.ANSICMD_BELL);
		}
	}
	if (bResult) {
		//clear screen and home cursor
		DXConsole.processText(sPostAnsiReset + DXConsole.ANSICMD_ERASE2J_CLEARSCREEN_HOME_CURSOR);
		if (bAttrsChanged) {
			_listFutures.add(xwinMain.dispatch(new XControlEventResize(iPOSX, iPOSY, iMAXROWS_MAINMENU, iMAXCOLS_MAINMENU)));
		}
		_listFutures.add(xwinMain.dispatch(new XControlEvent(iXCONTROLEVENTTYPE_PAINT)));
		Future.wait(_listFutures, eagerError: true).then((onValue) {
			cachedXWinTabbedMain = xwinMain;
			//cachedXInput = cachedXWinTabbedMain.tabView[0].xwin[0];
			if (bShowRuler) {
				final int MAXROWSRULER = 30,
						RULERCOLOR = 31;
				int iLineNo;
				DXConsole.writeText("*....:....1....:....2....:....3....:....4....:....5....:....6....:....7....:....8....:....9", 0, 0, RULERCOLOR);
				for (int i = 1; i < MAXROWSRULER; i++) {
					for (int i2 = 0; i2 < 4; i2++) {
						DXConsole.writeText(".", i++, 0, RULERCOLOR);
					}
					iLineNo = i % 10;
					DXConsole.writeText(iLineNo == 5 ? "-" : (i ~/ 10).toString(), i, 0, RULERCOLOR);
				}
			}
			//--------------------------------------------------------
			//set statusbar message
			xwinMain.infomsg = "Ready";
			//--------------------------------------------------------
			//draw nav commands
			//DXConsole write direct
			//HINT:Postion X/Y is zero (0) relative
			//--------------------------------------------------------
//			final int iCOL1 = iPOSX + 1,
//					_colorFGBG = ANSICOLOR_GREEN;
//			DXConsole.writeText("F1  :Help", iNAVROW1, iCOL1, _colorFGBG);
//			DXConsole.writeText("ESC :Exit", iNAVROW2, iCOL1, _colorFGBG);
//			DXConsole.writeText("-> :NextTab", iNAVROW1, iCOL1 + 10, _colorFGBG);
//			DXConsole.writeText("<- :PrevTab", iNAVROW2, iCOL1 + 10, _colorFGBG);
			//--------------------------------------------------------
			//DXConsole supports interpreted ansi control codes
			//HINT:Postion X/Y is one (1) relative
			//--------------------------------------------------------
			final int iCOL1 = iPOSX + 2,
					iCOL2 = iCOL1 + 10,
					iCOL3 = iCOL2 + 12;
			sb.clear();
			//minimize color changes,group same color text
			//keystoke actions are bold
			xpen
					..blue(bg: true)
					..green(bold: true);
			sb.writeAll([xpen.down, xpen.getANSICMD_MOVE_CURSOR_ROW_COL_H(iNAVROW1, iCOL1), "F1", //
				xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOL2), "->", //
				xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOL3), "F2", //
				xpen.getANSICMD_MOVE_CURSOR_ROW_COL_H(iNAVROW2, iCOL1), "ESC", //
				xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOL2), "<-"]);
			//keystoke labels are normal
			xpen.white(bold: true);
			sb.writeAll([xpen.down, xpen.getANSICMD_MOVE_CURSOR_ROW_COL_H(iNAVROW1, iCOL1 + 2), " :Help", //
				xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOL2 + 2), ":NextTab", //
				xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOL3 + 2), ":Ruler", //
				xpen.getANSICMD_MOVE_CURSOR_ROW_COL_H(iNAVROW2, iCOL1 + 3), ":Exit", //
				xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOL2 + 2), ":PrevTab", //ring the bell and hide the cursor
				DXConsole.ANSICMD_BELL + DXConsole.ANSICMD_CURSOR_HIDE]);
			DXConsole.processText(sb.toString());
			if (tmrMsgs == null || tmrMsgs.isActive == false) startPeriodic(1);
		});
	}

	return bResult;
}
bool showHelp() {
	bool bResult;
	const int iCOMMANDCOL = 5;
	const int iCOMMANDDESCCOL = 15;
	StringBuffer sb = new StringBuffer();
	//color_disabled = false;

	bool bSI_IsLittleEndian = false;
	int iSI_PageSize = 0;
	int iSI_SizeOfInt = 0;
	String sSI_Version = "";

	bSI_IsLittleEndian = SysInfo.isLittleEndian;
	iSI_PageSize = SysInfo.pageSize;
	iSI_SizeOfInt = SysInfo.sizeOfInt;
	sSI_Version = SysInfo.version;

	//pen.write('${DXConsole.ANSICMD_ERASE2J_CLEARSCREEN_HOME_CURSOR}');
	//AnsiTerm.write('${pen..black(bg:true)}');
	xpen
			..reset()
			..white(bold: true)
			..black(bg: true);
	sPreAnsiFGColor = xpen.down /* + resetBackground()*/;
	xpen..green(bold: true)//..black(bg:true,bold:false)
	;

	sb.clear();
	sb.writeAll([sPreAnsiFGColor, DXConsole.ANSICMD_ERASE2J_CLEARSCREEN_HOME_CURSOR, "==============", xpen.down, " dxConsole: Dart Console Library for Windows  (CommandMode)", sPreAnsiFGColor, "=============="]);
	sb.writeAll(["\nDart VM (", xpen.down, iSI_SizeOfInt * 8, sPreAnsiFGColor, "bit): ", xpen.down, sSI_Version]);
	sb.writeAll([sPreAnsiFGColor, "\nPage size: ", xpen.down, iSI_PageSize, sPreAnsiFGColor, "kb Endianness: ", xpen.down, bSI_IsLittleEndian ? 'Little-endian' : 'Big-endian']);
	sb.writeAll([sPreAnsiFGColor, "\nStdIn: ", xpen.down, stdioType(stdin).name, sPreAnsiFGColor, " StdOut: ", xpen.down, stdioType(stdout).name]);
	sb.writeAll([sPreAnsiFGColor, " StdErr: ", xpen.down, stdioType(stderr).name, sPreAnsiFGColor, "\n\nCommands:\n"]);

	sPostAnsiReset = sPreAnsiFGColor + xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDDESCCOL);
	xpen.cyan(bold: true);
	sPreAnsiFGColor = xpen.down;
	xpen.reset();

//#if _DEBUG && INC_DEVEXAMPLES
//	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDCOL));
//	sb.writeAll([sPreAnsiFGColor, sSTDIN_CMD_BENCHFORLOOPS, sPostAnsiReset, "- test compare foreach vs while\n"]);
//	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDCOL));
//	sb.writeAll([sPreAnsiFGColor, sSTDIN_CMD_DB, sPostAnsiReset, "- dbConnection\n"]);
//	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDCOL));
//	sb.writeAll([sPreAnsiFGColor, sSTDIN_CMD_NATIVESTREAM, sPostAnsiReset, "- NativeStream\n"]);
//	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDCOL));
//	sb.writeAll([sPreAnsiFGColor, sSTDIN_CMD_RANDOMARRY, sPostAnsiReset, "- Async Isolate RandomArray\n"]);

	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDCOL));
	sb.writeAll([sPreAnsiFGColor, sSTDIN_CMD_FORMSMODE, sPostAnsiReset, "- Forms Mode\n"]);
//	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDCOL));
//	sb.writeAll([sPreAnsiFGColor, sSTDIN_CMD_TESTXWIN, sPostAnsiReset, "- DXConsole test panel\n"]);
	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDCOL));
	sb.writeAll([sPreAnsiFGColor, sSTDIN_CMD_CLEARSCREEN, sPostAnsiReset, "- clear screen\n"]);
	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDCOL));
	sb.writeAll([sPreAnsiFGColor, sSTDIN_CMD_HELP, sPostAnsiReset, "- this help\n"]);
	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDCOL));
	sb.writeAll([sPreAnsiFGColor, sSTDIN_CMD_COLORS, sPostAnsiReset, "- AnsiPen color chart\n"]);
	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOMMANDCOL));
	sb.writeAll([sPreAnsiFGColor, sSTDIN_CMD_QUIT, sPostAnsiReset, "- exit\n"]);
	DXConsole.processText(sb.toString());
	return bResult;
}
void _showColorString(String sName, int iColor, AnsiPen ansiPen) {
	sb.clear();
	//foreground
	ansiPen.reset();
	sb.write(sPreAnsiFGColor);
	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOLORCOL1));
	sb.write(iColor);

	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOLORCOL2));
	ansiPen.xterm(iColor);
	sb.write(ansiPen.down);
	sb.write(sName);

	//foreground bold
	ansiPen.reset();
	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOLORCOL3));
	sb.write(sPreAnsiFGColor);
	ansiPen.xterm(iColor + 8);
	sb.write(ansiPen.down);
	sb.write(sName);

	//background
	ansiPen.reset();
	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOLORCOL4));
	sb.write(sPreAnsiFGColor);
	ansiPen.xterm(iColor, bg: true);
	sb.write(ansiPen.down);
	sb.write(sName);

	//background bold
	ansiPen.reset();
	sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOLORCOL5));
	sb.write(sPreAnsiFGColor);
	ansiPen.xterm(iColor + 8, bg: true);
	sb.write(ansiPen.down);
	sb.write(sName);
	sb.write("\n");

	DXConsole.processText(sb.toString());
}
