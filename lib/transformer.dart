// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:barback/barback.dart';
import 'dart:io';
import 'dart:async';

class NativeExtensionByOS extends Transformer {
  // A constructor named "asPlugin" is required. It can be empty, but
  // it must be present. It is how pub determines that you want this
  // class to be publicly available as a loadable transformer plugin.
  NativeExtensionByOS.asPlugin();

  Future<bool> isPrimary(AssetId input) {
    return new Future.value(input.path.startsWith('bin/dxConsole_win') && input.extension == '.dll');
  }

  Future apply(Transform transform) {
    return transform.primaryInput.readAsString().then((content) {
      AssetId id = transform.primaryInput.id;
      stderr.writeln("NativeExtensionByOS found:$id");
//      String newContent = copyright + content;
//      transform.addOutput(new Asset.fromString(id, newContent));
    });
  }
}