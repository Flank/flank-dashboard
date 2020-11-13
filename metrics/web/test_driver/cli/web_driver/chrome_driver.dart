import 'dart:io';

import 'package:archive/archive.dart';

import '../../common/config/driver_tests_config.dart';
import 'web_driver.dart';

/// A class that represents the chrome [WebDriver].
class ChromeDriver extends WebDriver {
  final ZipDecoder _archiveDecoder = ZipDecoder();

  @override
  String get downloadUrl {
    return Platform.isMacOS
        ? DriverTestsConfig.macOsChromeDriverDownloadUrl
        : DriverTestsConfig.linuxChromeDriverDownloadUrl;
  }

  @override
  String get executableName => 'chromedriver';

  @override
  Archive decodeArchive(String filePath) {
    final chromeDriverBytes = File(filePath).readAsBytesSync();

    return _archiveDecoder.decodeBytes(chromeDriverBytes);
  }
}
