// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart';

import '../common/logger/logger.dart';

/// Util class to work with files.
///
/// Helps to create, download and write data to files.
class FileUtils {
  /// If the [filePath] does not exists - downloads it, using the [url].
  static Future<void> download(String url, String filePath) async {
    final file = File(filePath);

    if (file.existsSync()) return;

    Logger.log("Downloading $file");

    final downloadingResponse = await get(url);

    // Throw an error if the downloading response is not successful
    if (downloadingResponse.statusCode != 200) throw downloadingResponse.body;

    await file.writeAsBytes(downloadingResponse.bodyBytes);

    Logger.log('Downloaded $filePath');
  }

  /// Extracts files from [Archive] to [workingDir].
  static void extractFromArchive(Archive archive, String workingDir) {
    for (final file in archive) {
      final fileName = file.name;
      if (file.isFile) {
        File('$workingDir/$fileName')
          ..createSync(recursive: true)
          ..writeAsBytesSync(file.content as List<int>);
      } else {
        Directory(fileName).createSync();
      }
    }
  }

  /// Creates the empty [fileName] file in [workingDirPath].
  ///
  /// If [cleanContent] is true - cleans the file.
  static File createFile(
    String fileName,
    String workingDirPath, {
    bool cleanContent = true,
  }) {
    final File logsFile = File('$workingDirPath/$fileName');

    if (!logsFile.existsSync()) {
      logsFile.createSync();
    }

    if (cleanContent) logsFile.writeAsStringSync('');

    return logsFile;
  }
}
