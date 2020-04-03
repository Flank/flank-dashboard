import 'dart:io';

/// A class providing methods for working with files.
class FileHelper {
  /// Checks whether a file by the given [filePath] exists.
  bool exists(String filePath) {
    final file = File(filePath);
    return file.existsSync();
  }

  /// Reads the content of a file by the given [filePath] as a string.
  String read(String filePath) {
    final file = File(filePath);
    return file.readAsStringSync();
  }
}
