import 'dart:io';

import '../../common/config/driver_tests_config.dart';
import '../../util/file_utils.dart';
import 'driver/chrome_driver.dart';
import 'driver/firefox_driver.dart';

/// Represents the selenium server.
class Selenium {
  static const String seleniumFileName = 'selenium.jar';

  /// Prepares the selenium server and drivers for it.
  /// Checks if the selenium server and driver files exist, and downloads
  /// them if not.
  static Future<void> prepare(String workingDir) async {
    final selenium = "$workingDir/$seleniumFileName";
    final seleniumFile = File(selenium);

    if (!seleniumFile.existsSync()) {
      await FileUtils.download(DriverTestsConfig.seleniumDownloadUrl, selenium);
    }

    await _prepareDrivers(workingDir);
  }

  /// Checks that required drivers are prepared.
  static Future<void> _prepareDrivers(String workingDir) async {
    await FirefoxDriver.prepare(workingDir);
    await ChromeDriver.prepare(workingDir);
  }
}
