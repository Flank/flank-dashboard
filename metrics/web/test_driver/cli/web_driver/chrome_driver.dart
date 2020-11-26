import 'dart:io';

import 'package:archive/archive.dart';
import 'package:meta/meta.dart';

import '../../common/config/driver_tests_config.dart';
import 'web_driver.dart';

/// A class that represents the chrome [WebDriver].
class ChromeDriver extends WebDriver {
  final ZipDecoder _archiveDecoder = ZipDecoder();

  /// A version of the Chromedriver.
  final String version;

  /// Creates a new instance of the [ChromeDriver] with the given [version].
  ///
  /// The [version] must not be `null`.
  ChromeDriver({
    @required this.version,
  }) : assert(version != null);

  @override
  String get downloadUrl {
    const basePath = DriverTestsConfig.chromedriverUrlBasePath;
    final driverArchiveName = _getDriverArchiveName();

    return '$basePath/$version/$driverArchiveName';
  }

  @override
  String get executableName => 'chromedriver';

  @override
  Archive decodeArchive(String filePath) {
    final chromeDriverBytes = File(filePath).readAsBytesSync();

    return _archiveDecoder.decodeBytes(chromeDriverBytes);
  }

  /// Returns the name of the Chromedriver compatible with the current [Platform].
  String _getDriverArchiveName() {
    if (Platform.isMacOS) {
      return DriverTestsConfig.macosDriverArchiveName;
    }

    if (Platform.isWindows) {
      return DriverTestsConfig.windowsDriverArchiveName;
    }

    return DriverTestsConfig.linuxDriverArchiveName;
  }
}
