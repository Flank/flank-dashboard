import 'dart:io';

/// A helper class that provides methods for working with files.
class FileHelper {
  /// Creates a new instance of the [FileHelper].
  const FileHelper();

  /// Deletes files by the given [path].
  Future<void> deleteDirectory(Directory directory) async {;
    try {
      await directory.delete(recursive: true);
    } catch (error) {
      print(error);
    }
  }
}
