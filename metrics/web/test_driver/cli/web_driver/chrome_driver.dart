import 'dart:io';

import 'package:archive/archive.dart';

import '../../common/config/driver_tests_config.dart';
import '../../util/chrome_driver_utils.dart';
import 'web_driver.dart';

/// A class that represents the chrome [WebDriver].
class ChromeDriver extends WebDriver {
  final ZipDecoder _archiveDecoder = ZipDecoder();

  /// A version of the Chromedriver.
  final String _version;

  /// Creates a new instance of the [ChromeDriver] with the given version.
  ChromeDriver(this._version);

  @override
  Future<String> get downloadUrl async {
    String _driverVersion = _version;

    _driverVersion ??= await ChromeDriverUtils.getLatestVersion();

    return _buildDownloadUrl(_driverVersion);
  }

  @override
  String get version => _version;

  @override
  String get executableName => 'chromedriver';

  @override
  Archive decodeArchive(String filePath) {
    final chromeDriverBytes = File(filePath).readAsBytesSync();

    return _archiveDecoder.decodeBytes(chromeDriverBytes);
  }

  /// Builds the download URL for the Chromedriver based
  /// on the given [driverVersion].
  String _buildDownloadUrl(driverVersion) {
    const basePath = DriverTestsConfig.chromedriverUrlBasePath;
    final driverArchiveName = _getDriverArchiveName();

    return '$basePath/$driverVersion/$driverArchiveName';
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
