import 'dart:io';

import 'package:archive/archive.dart';

import '../../../common/config/driver_tests_config.dart';
import '../../../util/file_utils.dart';

/// Represents the firefox driver.
class FirefoxDriver {
  /// Checks if the firefox driver file exists in [workingDir].
  /// If not - downloads it and makes it executable.
  static Future<void> prepare(String workingDir) async {
    final geckoDriver = '$workingDir/geckodriver';
    final geckoDriverArchive = '$geckoDriver-v0.26.0-macos.tar.gz';
    final geckoDriverFile = File(geckoDriver);

    if (!geckoDriverFile.existsSync()) {
      await FileUtils.download(
        DriverTestsConfig.firefoxDriverDownloadUrl,
        geckoDriverArchive,
      );

      final archiveDecoder = GZipDecoder();
      final archive = TarDecoder();

      final geckoArchiveBytes = File(geckoDriverArchive).readAsBytesSync();
      final decodedArchiveBytes = archiveDecoder.decodeBytes(geckoArchiveBytes);
      final geckoArchive = archive.decodeBytes(decodedArchiveBytes);

      FileUtils.extractFromArchive(geckoArchive, workingDir);

      await Process.run('chmod', ['a+x', '$geckoDriver']);
    }
  }
}
