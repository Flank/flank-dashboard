// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

/// A class that provides methods for working with the file system.
class FileHelper {
  /// Creates a new instance of the [FileHelper].
  const FileHelper();

  /// Returns a [File] by the given [path].
  File getFile(String path) {
    return File(path);
  }

  /// Creates a temporary directory in the given [directory]
  /// with the given [prefix].
  ///
  /// Throws an [ArgumentError] if the given [directory] is `null`.
  Directory createTempDirectory(Directory directory, String prefix) {
    ArgumentError.checkNotNull(directory, 'directory');

    return directory.createTempSync(prefix);
  }

  /// Deletes the given [directory] if it exists.
  void deleteDirectory(Directory directory) {
    final directoryExist = directory.existsSync();

    if (!directoryExist) return;

    directory.deleteSync(recursive: true);
  }

  /// Replaces variables defined in the [environment] it's values
  /// in the given [file].
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
