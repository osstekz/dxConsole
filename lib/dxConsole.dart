library dxConsole;

import "dart:async";
import "dart:io";
import "dart:isolate";
import "dart:typed_data";
import "package:ansicolor/ansicolor.dart";
//import "package:osslib/ossutils.dart";
//import "package:ossdevtools/utils.dart";

//===================================================
//SECTION: Native extensions
//REFER:https://www.dartlang.org/articles/native-extensions-for-standalone-dart-vm/#building-on-windows
//SOURCE:http://dart.googlecode.com/svn/trunk/dart/samples/sample_extension/
import "dart-ext:bin/dxConsole";
//import 'dart:nativewrappers' as nw;
//===================================================
part 'src/dxconsole_input.dart';
part 'src/dxconsole_main.dart';
