import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart';

/// Util class to work with files.
///
/// Helps to create, download and write data to files.
class FileUtils {
  /// Downloads file from [url] and saves it to [filePath].
  static Future<void> download(String url, String filePath) async {
    final file = File(filePath);

    if (file.existsSync()) return;
    print("Downloading $file");

    final downloadingResponse = await get(url);

    // Throw an error if the downloading response is not successful
    if (downloadingResponse.statusCode != 200) throw downloadingResponse.body;

    await file.writeAsBytes(downloadingResponse.bodyBytes);

    print('Downloaded $filePath');
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

  /// Creates the empty [fileName].log file in [workingDirPath].
  ///
  /// If the file is already exists - cleans the file.
  static File createLogFile(
    String fileName,
    String workingDirPath,
  ) {
    final File logsFile = File('$workingDirPath/$fileName.log');

    if (!logsFile.existsSync()) {
      logsFile.createSync();
    }

    // Clear file before writing to avoid appending ald logs with new one.
    logsFile.writeAsStringSync('');

    return logsFile;
  }
}
