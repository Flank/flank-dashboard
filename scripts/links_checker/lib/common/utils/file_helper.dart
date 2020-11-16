import 'dart:io';

/// A class that provides methods for working with files.
class FileHelper {
  /// Returns a new instance of the [FileHelper].
  const FileHelper();

  /// Returns a [List] of [File]s by the given [paths].
  List<File> getFiles(String paths) {
    final files = <File>[];

    for (final path in paths.split(' ')) {
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
