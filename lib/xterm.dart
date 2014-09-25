library xterm;

import "dart:async";
import "dart:io";
import "dart:isolate";

//===================================================
//SECTION: Native extensions
//REFER:https://www.dartlang.org/articles/native-extensions-for-standalone-dart-vm/#building-on-windows
//SOURCE:http://dart.googlecode.com/svn/trunk/dart/samples/sample_extension/
//SOURCE:c:\users\ossdevyorgi\documents\visual studio 2010\Projects\DartX_ConsoleXTerm\Debug\DartX_ConsoleXTerm.dll
//===================================================
import "dart-ext:../bin/xterm";
//import 'dart:nativewrappers' as nw;

import "package:ansicolor/ansicolor.dart";
import "dart:typed_data";
//import "package:osslib/ossutils.dart";
import "package:ossdevtools/utils.dart";

part 'src/consoleinput.dart';
part 'src/xterm_main.dart';

class SysInfo {
	static final bool isLittleEndian = _isLittleEndian();
	static bool _isLittleEndian() native "XTIsLittleEndian";

	static final int pageSize = _getPageSize();
	static int _getPageSize() native "XTGetPageSize";

	static final int sizeOfInt = _getSizeOfInt();
	static int _getSizeOfInt() native "XTGetSizeOfInt";

	static final String version = _getVersionString();
	static String _getVersionString() native "XTGetVersionString";
}