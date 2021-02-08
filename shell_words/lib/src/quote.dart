// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io' show Platform;

import 'posix.dart';
import 'batch.dart';

/// Quote chooses between `QuotePosix` and `QuoteBatch` based on your operating system
String quote(String word) {
  String result;
  if (Platform.isWindows) {
    result = quoteBatch(word);
  } else {
    result = quotePosix(word);
  }
  return result;
}
