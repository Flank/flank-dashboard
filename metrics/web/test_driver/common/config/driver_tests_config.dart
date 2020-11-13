/// The class with the constants for preparing the environment and running tests.
class DriverTestsConfig {
  /// The default port to serve the application from.
  ///
  /// Will be used if no --port parameter specified.
  static const int port = 9499;

  /// The default directory to store the selenium server, drivers and log files.
  ///
  /// Will be used if no --working-dir param will be specified.
  static const String defaultWorkingDirectory = 'build';

  /// Chrome driver download url for macOS.
  ///
  /// Will be used to download the chrome driver if there are no 'chromedriver'
  /// file will be found in working directory.
  static const String macOsChromeDriverDownloadUrl =
      'https://chromedriver.storage.googleapis.com/86.0.4240.22/chromedriver_mac64.zip';

  /// Chrome driver download url for Linux.
  ///
  /// Will be used to download the chrome driver if there are no 'chromedriver'
  /// file will be found in working directory.
  static const String linuxChromeDriverDownloadUrl =
      'https://chromedriver.storage.googleapis.com/86.0.4240.22/chromedriver_linux64.zip';
}
