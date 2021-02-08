// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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

  /// Returns content bytes of the file with the given [fileName] from 
  /// the [archive].
  ///
  /// Returns `null`, if a file with the given [fileName] is not found.
  Uint8List getFileContent(Archive archive, String fileName) {
    final file = archive.findFile(fileName);

    return file == null ? null : file.content as Uint8List;
  }
}
