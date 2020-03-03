import 'dart:io';

import 'package:archive/archive.dart';

import '../../../common/config/driver_tests_config.dart';
import '../../../util/file_utils.dart';

/// Represents the chrome driver.
class ChromeDriver {
  /// Check if the chrome driver file exists in [workingDir].
  /// If not - downloads the chrome driver and makes it executable.
  static Future<void> prepare(String workingDir) async {
    final chromeDriver = "$workingDir/chromedriver";
    final chromeDriverZip = "$chromeDriver.zip";
    final chromeDriverFile = File(chromeDriver);

    if (!chromeDriverFile.existsSync()) {
      await FileUtils.download(
        DriverTestsConfig.chromeDriverDownloadUrl,
        chromeDriverZip,
      );

      final ZipDecoder archive = ZipDecoder();
      final chromeDriverBytes = File(chromeDriverZip).readAsBytesSync();

      final chromeDriverArchive = archive.decodeBytes(chromeDriverBytes);

      FileUtils.extractFromArchive(chromeDriverArchive, workingDir);

      await Process.run('chmod', ['a+x', '$chromeDriver']);
    }
  }
}
