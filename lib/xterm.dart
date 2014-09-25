library xterm;

import "dart:async";
import "dart:io";
import "dart:isolate";

//===================================================
//SECTION: Native extensions
//REFER:https://www.dartlang.org/articles/native-extensions-for-standalone-dart-vm/#building-on-windows
//SOURCE:http://dart.googlecode.com/svn/trunk/dart/samples/sample_extension/
//===================================================
import "dart-ext:../bin/xterm";
//import 'dart:nativewrappers' as nw;

import "package:ansicolor/ansicolor.dart";
import "dart:typed_data";
//import "package:osslib/ossutils.dart";
//import "package:ossdevtools/utils.dart";

part 'src/consoleinput.dart';
part 'src/xterm_main.dart';

class SysInfo {
//TODO:PERF:Combine SysInfo into single call native "XTGetSysInfo";
	static final bool isLittleEndian = _isLittleEndian();
	static bool _isLittleEndian() native "XTIsLittleEndian";

	static final int pageSize = _getPageSize();
	static int _getPageSize() native "XTGetPageSize";

	static final int sizeOfInt = _getSizeOfInt();
	static int _getSizeOfInt() native "XTGetSizeOfInt";

	static final String version = _getVersionString();
	static String _getVersionString() native "XTGetVersionString";
}