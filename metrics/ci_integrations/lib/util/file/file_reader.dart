// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:ci_integration/util/file/file_helper.dart';

/// A class that provides methods for reading [File]s.
class FileReader {
  /// A [FileHelper] of this reader uses to work with the file system.
  final FileHelper fileHelper;

  /// Creates a new instance of the [FileReader] with the given [fileHelper].
  ///
  /// If the given [fileHelper] is `null`, a new instance of the [FileHelper]
  /// is used.
  const FileReader([
    FileHelper fileHelper,
  ]) : fileHelper = fileHelper ?? const FileHelper();

  /// Returns the contents of the [File] located by the given [path].
  ///
  /// Throws a [StateError] if the [File] with the given [path] does not exist.
  String read(String path) {
    final file = fileHelper.getFile(path);

    if (!file.existsSync()) {
      throw StateError('The file with the given path is not found.');
    }

    return file.readAsStringSync();
  }
}
