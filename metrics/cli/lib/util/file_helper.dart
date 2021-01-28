import 'dart:io';

/// A helper class that provides methods for working with files.
class FileHelper {
  /// Deletes the given [Directory].
  Future<void> deleteDirectory(Directory directory) async {
    try {
      await directory.delete(recursive: true);
    } catch (error) {
      print(error);
    }
  }
}
