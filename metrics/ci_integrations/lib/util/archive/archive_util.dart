import 'dart:typed_data';

import 'package:archive/archive.dart';

/// A helper class that provides methods for decoding archives and listing
/// decoded files.
class ArchiveHelper {
  /// A [ZipDecoder] that is used by this helper.
  final ZipDecoder zipDecoder;

  /// Creates a new instance of the [ArchiveHelper].
  ///
  /// Throws an [ArgumentError] if the given [zipDecoder] is `null`.
  ArchiveHelper(this.zipDecoder) {
    ArgumentError.checkNotNull(zipDecoder);
  }

  /// Decodes the given archive's [bytes] and returns an [Archive].
  Archive decodeArchive(Uint8List bytes) {
    final archive = zipDecoder.decodeBytes(bytes);

    return archive;
  }

  /// Returns the [ArchiveFile] with the given [fileName] from the [archive].
  ///
  /// Returns `null`, if a file with the given [fileName] is not found.
  ArchiveFile getFile(Archive archive, String fileName) {
    final files = archive.files;

    return files.firstWhere(
      (file) => file.name == fileName,
      orElse: () => null,
    );
  }
}
