import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart';

import '../common/config/driver_tests_config.dart';

/// Util class to work with files
/// Helps to create, download and write data to files
class FileUtils {
  /// Checks if the selenium server file is available in [workingDir] directory
  /// Downloads the selenium server to [workingDir] if not exists
  static Future<String> downloadSelenium(String workingDir) async {
    const seleniumFileName = 'selenium.jar';
    final selenium = "$workingDir/$seleniumFileName";
    final seleniumFile = File(selenium);

    if (!seleniumFile.existsSync()) {
      await _download(DriverTestsConfig.seleniumDownloadUrl, selenium);
    }

    return seleniumFileName;
  }

  /// Check if the chrome driver file exists in [workingDir]
  /// If not - downloads the chrome driver and makes it executable
  static Future<void> downloadChromeDriver(String workingDir) async {
    final chromeDriver = "$workingDir/chromedriver";
    final chromeDriverZip = "$chromeDriver.zip";

    await _download(DriverTestsConfig.chromeDriverDownloadUrl, chromeDriverZip);

    final chromeDriverFile = File(chromeDriver);

    if (!chromeDriverFile.existsSync()) {
      final ZipDecoder archive = ZipDecoder();
      final chromeDriverBytes = File(chromeDriverZip).readAsBytesSync();

      final chromeDriverArchive = archive.decodeBytes(chromeDriverBytes);

      _extractFromArchive(chromeDriverArchive, workingDir);

      await Process.run('chmod', ['a+x', '$chromeDriver']);
    }
  }

  /// Checks if the firefox driver file exists in [workingDir]
  /// If not - downloads it and makes it executable
  static Future<void> downloadFirefoxDriver(String workingDir) async {
    final geckoDriver = '$workingDir/geckodriver';
    final geckoDriverArchive = '$geckoDriver-v0.26.0-macos.tar.gz';

    await _download(
      DriverTestsConfig.firefoxDriverDownloadUrl,
      geckoDriverArchive,
    );

    final geckoDriverFile = File(geckoDriver);

    if (!geckoDriverFile.existsSync()) {
      final archiveDecoder = GZipDecoder();
      final archive = TarDecoder();

      final geckoArchiveBytes = File(geckoDriverArchive).readAsBytesSync();
      final decodedArchiveBytes = archiveDecoder.decodeBytes(geckoArchiveBytes);
      final geckoArchive = archive.decodeBytes(decodedArchiveBytes);

      _extractFromArchive(geckoArchive, workingDir);

      await Process.run('chmod', ['a+x', '$geckoDriver']);
    }
  }

  /// Downloads file from [url] and saves it to [filePath]
  static Future<void> _download(String url, String filePath) async {
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
  static void _extractFromArchive(Archive archive, String workingDir) {
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

  /// Saves the process outputs from the [stderr] and [stdout]
  /// to [fileName] in [workingDirPath] directory.
  static void saveOutputsToFile(
    Stream<List<int>> stdout,
    Stream<List<int>> stderr,
    String fileName,
    String workingDirPath,
  ) {
    final File outputFile = File('$workingDirPath/$fileName.log');

    if (!outputFile.existsSync()) {
      outputFile.createSync();
    }

    // Clear file before writing to avoid appending ald logs with new one.
    outputFile.writeAsStringSync('');

    stdout.asBroadcastStream().listen(
          (data) => outputFile.writeAsBytes(data, mode: FileMode.append),
        );
    stderr.asBroadcastStream().listen(
          (data) => outputFile.writeAsBytes(data, mode: FileMode.append),
        );
  }
}
