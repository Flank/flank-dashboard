// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

/// A class that provides methods for working with the [Directory] and [File]s.
class FileHelper {
  /// Replaces variables defined by the [environment.keys]
  /// with the [environment.values] in the given [file].
  ///
  /// Does nothing if the given [file] is `null` or does not exist.
  /// Does nothing if the given [environment] is `null` or empty.
  Future<void> replaceEnvironmentVariables(
    File file,
    Map<String, dynamic> environment,
  ) async {
    final environmentIsEmpty = environment == null || environment.isEmpty;
    final fileNotExists = file == null || !(await file.exists());

    if (environmentIsEmpty || fileNotExists) {
      return;
    }
    String content = await file.readAsString();
    for (final variable in environment.keys) {
      content = content.replaceAll(
        variable,
        environment[variable].toString(),
      );
    }

    await file.writeAsString(content);
  }

  /// Deletes the given [directory].
  ///
  /// Does nothing if the given [directory] is `null` or does not exist.
  Future<void> deleteDirectory(Directory directory) async {
    final isDirectoryExist = directory != null && await directory.exists();

    if (isDirectoryExist) {
      await directory.delete();
    }
  }
}
