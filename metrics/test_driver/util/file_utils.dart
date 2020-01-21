import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart';

import '../config/driver_tests_config.dart';

class FileUtils {
  static Future<String> downloadSelenium(String workingDir) async {
    const seleniumFileName = 'selenium.jar';
    final selenium = "$workingDir/$seleniumFileName";
    final seleniumFile = File(selenium);

    if (!seleniumFile.existsSync()) {
      await _download(DriverTestsConfig.seleniumDownloadUrl, selenium);
    }

    return seleniumFileName;
  }

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

  static Future<void> _download(String url, String fileName) async {
    final file = File(fileName);

    if (file.existsSync()) return;
    print("Downloading $file");

    final downloadingResponse = await get(url);

    // Throw an error if the downloading response is not successful
    if (downloadingResponse.statusCode != 200) throw downloadingResponse.body;

    await file.writeAsBytes(downloadingResponse.bodyBytes);

    print('Downloaded $fileName');
  }

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
}
