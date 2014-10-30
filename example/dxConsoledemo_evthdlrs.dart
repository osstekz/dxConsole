part of dxConsoleDemo;

bool evthdlrTab1(XTab xtab, Uint8List evtInput) {
	assert(DebugCheckType(evtInput, "Uint8List", "evthdlrTab1"));
	bool bHandled = false;

	if (evtInput[iEVENTTYPE] == EVT_KEYBOARD) {
		assert(evtInput.length == iKA_TOTAL_ELEMENTS);
//	assert(evtInput[iKA_EVENTTYPE] == KEY_EVENT);
		assert(null != xtab.xwin);
		int iKey = evtInput[iKA_KEYCHAR],
				iCode;
		XWindow _xwin = xtab.xwin;

		switch (iKey) {
			case 0:
				iCode = evtInput[iKA_KEYCODE];
				switch (iCode) {
					case VK_UP:
						_xwin.prevEnabled();
						bHandled = true;
						break;
					case VK_DOWN:
						_xwin.nextEnabled();
						bHandled = true;
						break;
					default:
						assert(print("evthdlrTab1 iKey:${iKey.toRadixString(16)}  iCode:${iCode.toRadixString(16)}"));
						break;
				}
				break;
			case VK_ENTER:
			case VK_TAB:
				_xwin.nextEnabled();
				bHandled = true;
				break;
			case VK_ESCAPE:
				break;
			default:
				//send iKey to focused field
				DXConsole.writeTextDecoded(DXConsole.ANSICMD_BELL);
				bHandled = true;
				break;
		}
	}
	return bHandled;
}
void evthdlrMainMenu(Uint8List evtInput) {
	assert(DebugCheckType(evtInput, "Uint8List", "evthdlrMainMenu"));
	assert(cachedXWinTabbedMain == _xwinmgr[iXWINIDX_MAIN]);

	new Future(() {
		int iEvtType = evtInput[iEVENTTYPE];

		if (iEvtType == EVT_MOUSE) {
			assert(evtInput.length == iMI_MOUSE_TOTAL_ELEMENTS);
			assert(print("evthdlrMainMenu::MouseEventProc dwEventFlags:${evtInput[iMI_MOUSE_FLAGS]} dwButtonState:${evtInput[iMI_MOUSE_BTNSTATE]} dwMousePosition:X(${evtInput[iMI_MOUSE_POSX]}) Y(${evtInput[iMI_MOUSE_POSY]})"));
//		switch (evtInput[iMI_MOUSE_FLAGS]) {
//			case EVTFLAGS_SINGLE_CLICK:
//				if (evtInput[iMI_MOUSE_BTNSTATE] == FROM_LEFT_1ST_BUTTON_PRESSED) {
//					print("...left button press");
//				} else if (evtInput[iMI_MOUSE_BTNSTATE] == RIGHTMOST_BUTTON_PRESSED) {
//					print("...right button press");
//				} else {
//					print("...button press");
//				}
//				break;
//			case EVTFLAGS_DOUBLE_CLICK:
//				print("...double click");
//				break;
//			case EVTFLAGS_MOUSE_HWHEELED:
//				print("...horizontal mouse wheel");
//				break;
//			case EVTFLAGS_MOUSE_MOVED:
//				print("...mouse moved");
//				break;
//			case EVTFLAGS_MOUSE_WHEELED:
//				print("...vertical mouse wheel");
//				break;
//			default:
//				print("...unknown");
//				break;
//		}
		} else if (iEvtType == EVT_KEYBOARD) {
			assert(evtInput.length == iKA_TOTAL_ELEMENTS);
			int iKey = evtInput[iKA_KEYCHAR];
			//Event processed by tab handler?
			if (cachedXWinTabbedMain.tabEvt(evtInput) == false) {
				if (iKey == 0) {
					int iCode = evtInput[iKA_KEYCODE];
					switch (iCode) {
						case VK_F2:
							bShowRuler = !bShowRuler;
							showMainMenu(true);
							break;
						case VK_LEFT:
							cachedXWinTabbedMain.tabMove(false);
							break;
						case VK_RIGHT:
							cachedXWinTabbedMain.tabMove(true);
							break;
						default:
							assert(print("evthdlrMainMenu::iKA_KEYCODE:${evtInput[iKA_KEYCODE].toRadixString(16)} iKey:${iKey} ${evtInput}"));
							break;
					}
				} else {
					switch (iKey) {
						case VK_ESCAPE:
							//restart ConsoleInput
							ciEvents.start(iCONSOLEPARMS_MAIN, sSTDIN_CMD_HELP).whenComplete(() {
								if (tmrMsgs != null && tmrMsgs.isActive) tmrMsgs.cancel();
								DXConsole.writeTextDecoded(DXConsole.ANSICMD_CURSOR_SHOW);
								//_xwinmgr.clear();
								//xwinCachedTabbedMain = null;
								//_cacheXFld = null;
							}).catchError((excp) {
								assert(_unhandledExceptionCallback("doConsoleInputMainMenu::Error:$excp"));
							});
							break;
						default:
							assert(print("evthdlrMainMenu:: iKey:${iKey} ${evtInput}"));
							break;
					}
				}
			}
		} else if (iEvtType == EVT_WINDOW_BUFFER_SIZE) {
			assert(evtInput.length == iWI_WBER_TOTAL_ELEMENTS);
			assert((evtInput[iWI_WBER_ROWS] - iMAXROWS_MAINMENU) > 0);
			xsvlogger.resize(0, iMAXROWS_MAINMENU, iMAXCOLS_MAINMENU, evtInput[iWI_WBER_ROWS] - iMAXROWS_MAINMENU, iDOCKPOSITION_BOTTOM);
			if (stdout.hasTerminal) {
				assert(print("evthdlrMainMenu EVT_WINDOW_BUFFER_SIZE iWI_WBER_COLS:$evtInput[iWI_WBER_COLS] iWI_WBER_ROWS:$evtInput[iWI_WBER_ROWS]"));
			}
		} else if (iEvtType == EVT_FOCUS) {
		} else if (iEvtType == EVT_MENU) {
		} else {
			logger.error("evthdlrMainMenu invalid iEvtType:$iEvtType");
		}
	});
}

void evthdlrConsoleInput(line) {
	assert(DebugCheckType(line, "String", "doConsoleInput"));

//	if (!(line is String)) {
//		stderr.writeln("doConsoleInput:${line}");
//		return;
//	}
	new Future(() {
		final String _cmd = line.trim().toLowerCase();
		if (_cmd == sSTDIN_CMD_FORMSMODE) {
			if (showMainMenu() == true) {
				ciEvents.start(iCONSOLEPARMS_FORMSMODE);
			} else {
				//XTerm.sendKeys(sSTDIN_CMD_HELP);
			}
			return;

		} else if (_cmd == sSTDIN_CMD_COLORS) {
			final StringBuffer sb = new StringBuffer();

			xpen.white();
			sPreAnsiFGColor = xpen.down + resetBackground();

			//sb.clear();
			sb.writeAll([sPostAnsiReset, DXConsole.ANSICMD_ERASE2J_CLEARSCREEN_HOME_CURSOR]);
			sb.write(sPreAnsiFGColor);
			sb.write("============AnsiPen Standard 16 color(8bit) Demo===========\n");
			sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOLORCOL1));
			sb.write("#");
			sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOLORCOL2));
			sb.write("Foreground");
			sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOLORCOL3));
			sb.write("(bold)");
			sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOLORCOL4));
			sb.write("Background");
			sb.write(xpen.getANSICMD_MOVE_CURSOR_CURRENTROW_COL_G(iCOLORCOL5));
			sb.write("(bold)\n");
			xpen.reset();

			DXConsole.writeTextDecoded(sb.toString());

			_showColorString("black", 0, xpen);
			_showColorString("red", 1, xpen);
			_showColorString("green", 2, xpen);
			_showColorString("yellow", 3, xpen);
			_showColorString("blue", 4, xpen);
			_showColorString("magenta", 5, xpen);
			_showColorString("cyan", 6, xpen);
			_showColorString("white", 7, xpen);

			sb.clear();
			sb.write(sPreAnsiFGColor);
			sb.write("\n\n=================AnsiPen RGB Colors Demo================\n");

			sb.write(ansi_demo());
			sb.write("\n");
			xpen.reset();
			DXConsole.writeTextDecoded(sb.toString());
		} else if (_cmd == sSTDIN_CMD_CLEARSCREEN) {
			DXConsole.writeTextDecoded(sPostAnsiReset + DXConsole.ANSICMD_ERASE2J_CLEARSCREEN_HOME_CURSOR);
		} else if (_cmd == sSTDIN_CMD_QUIT) {
			ciEvents.stop().then((_) {
				//print ("ready to exit(0)");
				exit(0);
			});
		} else if (_cmd == sSTDIN_CMD_HELP) {
			showHelp();
		} else if (line.length > 0) {
			final StringBuffer sb = new StringBuffer();

			xpen.red(bold: true);
			//sb.clear();
			sb.writeAll([xpen.down, "\n'", line, "' unknown command, try '", sSTDIN_CMD_HELP, "'"]);
			DXConsole.writeTextDecoded(sb.toString());
		}
//show command prompt
		xpen.white(bold: true);
		DXConsole.writeTextDecoded(resetBackground() + xpen.down + "\n>");
	});
}
