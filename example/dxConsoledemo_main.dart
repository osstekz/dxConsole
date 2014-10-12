library dxConsoleDemo;

import "dart:io";
import "dart:async";
import "dart:typed_data";

import "package:dxConsole/dxConsole.dart";
import "package:ansicolor/ansicolor.dart";
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

part "dxConsoledemo_defs.dart";
part "app_logger.dart";
part "dxConsoledemo_show.dart";
part "dxConsoledemo_evthdlrs.dart";

//-----------------------------------------------
// Redirect dart:core print function to logger.print
// Prints a string representation of the object to the console.
// Note: Always return true, so we can use assert(print("SomeDebugStuff"));
//-----------------------------------------------
@override
bool print(Object object) {
	logger.info(object.toString());
	return true;
}

//-----------------------------------------------
//Create sample messages for log window
//-----------------------------------------------
void cbTimer(Timer t) {
	logger.debug("waiting for stuff to do!");
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

bool DebugCheckType(Object oObj, String sCompareToTypeName, String sFnName) {
	String _oTypeName = oObj.runtimeType.toString();
	bool _bResult = (_oTypeName == sCompareToTypeName);
	if (!_bResult) {
		String sData = oObj.toString();
		logger.error("DebugCheckType: caller:${sFnName} objTypeName:${_oTypeName} != CompareToTypeName:${sCompareToTypeName}\n...oObj(${sData.length}): ${sData}");
	}
	return _bResult;
}

void main() {
	assert(() {
		bIsCheckedMode = true;
		return true;
	});

	//create console input parameters and function handler
	ciEvents.mapInputParms[iCONSOLEPARMS_MAIN] = new ConsoleInputEventsParms(evthdlrConsoleInput);
	ciEvents.mapInputParms[iCONSOLEPARMS_FORMSMODE] = new ConsoleInputEventsParms(evthdlrMainMenu, false)
			..bMouseEvents = true
			..bWindowEvents = true;
//	ciEvents.start(iCONSOLEPARMS_MAIN, sSTDIN_CMD_HELP)
	ciEvents.start(iCONSOLEPARMS_MAIN, sSTDIN_CMD_FORMSMODE).whenComplete(() => new Future(() {
		print("System Started:" + new DateTime.now().toString());
		logger.warn("NavRCServer:: Sample warn");
		logger.error("NavRCServer:: Sample error\n...line 2");
		logger.debug("NavRCServer:: Sample debug");
		logger.error("NavRCServer:: Sample multi-line error\n" '''
While parsing a protocol message, the input ended unexpectedly
in the middle of a field.  This could mean either than the
input has been truncated or that an embedded message
misreported its own length.''');
	})).catchError((excp) {
		_unhandledExceptionCallback("main::Error:$excp");
	});
}
