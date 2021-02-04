// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:archive/archive.dart';

import '../../util/chrome_driver_utils.dart';
import 'web_driver.dart';

/// A class that represents the chrome [WebDriver].
class ChromeDriver extends WebDriver {
  /// A base path for the Chromedriver related URLs.
  static const String chromedriverUrlBasePath =
      'https://chromedriver.storage.googleapis.com';

  /// A name of the archive with the Chromedriver for MacOS.
  static const String macosDriverArchiveName = 'chromedriver_mac64.zip';

  /// A name of the archive with the Chromedriver for Linux.
  static const String linuxDriverArchiveName = 'chromedriver_linux64.zip';

  /// A name of the archive with the Chromedriver for Windows.
  static const String windowsDriverArchiveName = 'chromedriver_win32.zip';

  /// A [ZipDecoder] used to decode an archive with this driver.
  final ZipDecoder _archiveDecoder = ZipDecoder();

  @override
  Future<String> get downloadUrl async {
    String _driverVersion = version;

    _driverVersion ??= await ChromeDriverUtils.getLatestVersion();

    return _buildDownloadUrl(_driverVersion);
  }

  @override
  String get executableName => 'chromedriver';

  /// Creates a new instance of the [ChromeDriver] with the given [version].
  ChromeDriver({String version}) : super(version);

  @override
  Archive decodeArchive(String filePath) {
    final chromeDriverBytes = File(filePath).readAsBytesSync();

    return _archiveDecoder.decodeBytes(chromeDriverBytes);
  }

  /// Builds the download URL for the Chromedriver based
  /// on the given [driverVersion].
  String _buildDownloadUrl(driverVersion) {
    const basePath = chromedriverUrlBasePath;

    final driverArchiveName = _getDriverArchiveName();

    return '$basePath/$driverVersion/$driverArchiveName';
  }

  /// Returns the name of the Chromedriver compatible with the current [Platform].
  String _getDriverArchiveName() {
    if (Platform.isMacOS) {
      return macosDriverArchiveName;
    }

    if (Platform.isWindows) {
      return windowsDriverArchiveName;
    }

    return linuxDriverArchiveName;
  }
}
