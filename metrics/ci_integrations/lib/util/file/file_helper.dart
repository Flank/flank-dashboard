// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

/// A helper class that provides methods for working with [File]s.
class FileHelper {
  /// Creates a new instance of the [FileHelper].
  const FileHelper();

  /// Returns a [File] located by the given [path].
  File getFile(String path) {
    return File(path);
  }
}
