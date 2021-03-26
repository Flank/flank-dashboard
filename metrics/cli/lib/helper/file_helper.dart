// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

/// A class that provides methods for working with the [Directory] and [File]s.
class FileHelper {
  /// Returns a [File] by the given [path].
  File getFile(String path) {
    return File(path);
  }

  /// Returns a [Directory] by the given [path].
  Directory getDirectory(String path) {
    return Directory(path);
  }

  /// Replaces variables defined by the [environment.keys]
  /// with the [environment.values] in the given [file].
  ///
  /// Throws an [ArgumentError] if the given [file] is `null`.
  /// Throws an [ArgumentError] if the given [environment] is `null`.
  void replaceEnvironmentVariables(
    File file,
    Map<String, dynamic> environment,
  ) {
    ArgumentError.checkNotNull(file, 'file');
    ArgumentError.checkNotNull(environment, 'environment');

    if (environment.isEmpty || !file.existsSync()) {
      return;
    }

    String content = file.readAsStringSync();
    for (final variable in environment.keys) {
      content = content.replaceAll(
        '\$$variable',
        environment[variable].toString(),
      );
    }

    file.writeAsStringSync(content);
  }
}
