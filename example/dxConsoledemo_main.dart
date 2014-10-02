library dxConsoleDemo;

import "dart:io";
import "dart:async";
import "dart:typed_data";

import "package:dxConsole/dxConsole.dart";
import "package:ansicolor/ansicolor.dart";

part "dxConsoledemo_defs.dart";
part "dxConsoledemo_show.dart";
part "dxConsoledemo_evthdlrs.dart";

//-----------------------------------------------
// Redirect dart:core print function to logger.print
// Prints a string representation of the object to the console.
//-----------------------------------------------
bool print(Object object) {
	iCount++;
	return logger.print("Log:$iCount $object");
	//return logger.print("Log:$iCount $object -----------------------------------------------1234567890QWERTYUIOPASDFGHJKLZXCVBNM");
}

//-----------------------------------------------
//Create sample messages for log window
//-----------------------------------------------
void cbTimer(Timer t) {
	String sMsg;
	if (stdout.hasTerminal) {
		sMsg ="terminal Lines:${stdout.terminalLines} Cols:${stdout.terminalColumns}";
	}
	else	{
		sMsg="...sample message";
		}
	print(sMsg);
	if (cachedXInputLogCount != null) {
		cachedXInputLogCount.value = iCount;
	}
}

void startPeriodic(int sec) {
	if (tmrMsgs == null || tmrMsgs.isActive == false) tmrMsgs = new Timer.periodic(new Duration(seconds: sec), cbTimer);
}

//REFER:https://code.google.com/p/dart/issues/detail?id=9273
//Issue 9273:	Need a global error handler primitive in the VM
_unhandledExceptionCallback(e) {
	stderr.writeln("\nUHE:" + e.toString());
//	StringBuffer sb = new StringBuffer();
//	xpen.white(bold: true);
//	preAnsiFGColor = xpen.down;
//	sb.writeAll([preAnsiFGColor, "\n\n-------- _unhandledExceptionCallback---------\n"]);
//	xpen.red(bold: true);
//	sb.writeAll([xpen.down, "\nUHE:" + e.toString()]);
//	xpen.white(bold: true);
//	sb.writeAll([preAnsiFGColor, "\n---------------------------------------------\n\n"]);
//	XTerm.writeraw(sb.toString());

	exit(127);
	//return false;
}

bool DebugCheckType(obj, String CompareToTypeName, String FnName) {
	String oTypeName = obj.runtimeType.toString();
	bool bResult = (oTypeName == CompareToTypeName);
	if (!bResult) {
		print("\n-------- DebugCheckType---------\n...caller:${FnName}\n...objTypeName:${oTypeName} != CompareToTypeName:${CompareToTypeName}");
		String data = obj.toString();
		print("...data length:${data.length}\n${data}\n--------------------------------");
	}
	return bResult;
}

void main() {
	//create console input parameters and function handler
	ciEvents.mapInputParms[iCONSOLEPARMS_MAIN] = new ConsoleInputEventsParms(evthdlrConsoleInput);
	ciEvents.mapInputParms[iCONSOLEPARMS_FORMSMODE] = new ConsoleInputEventsParms(evthdlrMainMenu, false)
			..bMouseEvents = true
			..bWindowEvents = true;

//	ciEvents.start(iCONSOLEPARMS_MAIN, sSTDIN_CMD_HELP)
		ciEvents.start(iCONSOLEPARMS_MAIN, sSTDIN_CMD_FORMSMODE)
//	.whenComplete((){
//		XTerm.parseText(XTerm.ANSICMD_ERASE2J_CLEARSCREEN_HOME_CURSOR+XTerm.ANSICMD_CURSOR_SHOW+"main::whenComplete");
//	_xwinmgr.idxCurrent = UNINITIALIZED_VALUE;
//	})
	.catchError((excp) {
		if (bDEBUGMODEDXCONSOLE) _unhandledExceptionCallback("main::Error:$excp");
	});
}
