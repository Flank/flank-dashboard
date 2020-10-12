import 'dart:typed_data';

import 'package:archive/archive.dart';

/// A utility class needed to decode archives.
class ArchiveUtil {
  /// A [ZipDecoder] of this util.
  static final _zipDecoder = ZipDecoder();

  /// Decodes the given archive's [bytes] and returns a list of [ArchiveFile]s.
  static List<ArchiveFile> decodeZip(Uint8List bytes) {
    final archive = _zipDecoder.decodeBytes(bytes);
    return archive.files;
  }

  /// Returns the [ArchiveFile] with the given [fileName] from the archive,
  /// specified by its [bytes].
  /// If the file with such [fileName] was not found, returns `null`.
  static ArchiveFile getArchiveFile({Uint8List bytes, String fileName}) {
    final files = decodeZip(bytes);
    return files.firstWhere(
      (file) => file.name == fileName,
      orElse: () => null,
    );
  }
}
