part of dxConsoleDemo;

const bool bDEBUGMODE = true;

//PERF:Use int keys instead of String
const int iCONSOLEPARMS_MAIN = 1;//"main";
const int iCONSOLEPARMS_FORMSMODE = 2;//"forms";
//const String CONSOLEPARMS_TEST = "test";

const String sSTDIN_CMD_FORMSMODE = "form";
//const String sSTDIN_CMD_TESTXWIN = "test";
const String sSTDIN_CMD_HELP = "help";
const String sSTDIN_CMD_COLORS = "apcolors";
const String sSTDIN_CMD_QUIT = "quit";
const String sSTDIN_CMD_CLEARSCREEN = "cls";

//#if _DEBUG && INC_DEVEXAMPLES
//const String sSTDIN_CMD_DB = "db";
//const String sSTDIN_CMD_NATIVESTREAM = "nstrm";
//const String sSTDIN_CMD_RANDOMARRY = "rarray";
//const String sSTDIN_CMD_BENCHFORLOOPS = "testforeach";

const int iCOLORCOL1 = 2;
const int iCOLORCOL2 = 4;
const int iCOLORCOL3 = iCOLORCOL2 + 12;
const int iCOLORCOL4 = iCOLORCOL3 + 20;
const int iCOLORCOL5 = iCOLORCOL4 + 12;

const String sANSIFGBLACK = "\x1B[38;5;0m";//black
String sPostAnsiReset = "\x1B[0m";//reset
String sPreAnsiFGColor = "\x1B[38;5;15m";//white bold
bool bShowRuler = false;
bool bIsCheckedMode = false;

XInputNumber cachedXInputLogCount;
XTabbedWindow cachedXWinTabbedMain;
int iCount = 0;
Timer tmrMsgs;

final ConsoleInputEvents ciEvents = new ConsoleInputEvents();

//XWINDOW
final int iMAXROWS_MAINMENU = 15,
		iMAXCOLS_MAINMENU = 80;

const int iXWINIDX_MAIN = 0;
final XWinMgr _xwinmgr = new XWinMgr(1);
final XScrollView xsvlogger = new XScrollView(0, iMAXROWS_MAINMENU, iMAXCOLS_MAINMENU, 20, iDOCKPOSITION_TOP);
final AppLogger logger = new AppLogger("MobotoServer", xsvlogger);
