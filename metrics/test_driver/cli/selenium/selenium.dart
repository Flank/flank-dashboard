import 'dart:io';

import '../../common/config/driver_tests_config.dart';
import '../../util/file_utils.dart';
import 'driver/chrome_driver.dart';
import 'driver/firefox_driver.dart';

/// Represents the selenium server.
class Selenium {
  static const String seleniumFileName = 'selenium.jar';

  /// Checks if the selenium server file and drivers for it are available
  /// in [workingDir] directory.
  /// Downloads them to [workingDir] if not exists.
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
