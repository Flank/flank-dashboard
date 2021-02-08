// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

/// A class that provides methods for working with files.
class FileHelperUtil {
  /// Returns a new instance of the [FileHelperUtil].
  const FileHelperUtil();

  /// Returns a [List] of [File]s by the given [paths].
  List<File> getFiles(List<String> paths) {
    final files = <File>[];

    for (final path in paths) {
      final file = getFile(path);

      if (file != null) files.add(file);
    }

    return files;
  }

  /// Returns a [File] by the given [path] if such exists,
  /// otherwise returns `null`.
  File getFile(String path) {
    final file = File(path);

    if (file.existsSync()) return file;

    return null;
  }
}
