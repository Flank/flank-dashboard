/// The class with the constants for preparing the environment and running tests
class DriverTestsConfig {
  /// The default port to serve the application from.
  ///
  /// Will be used if no --port parameter specified
  static const int port = 9499;

  /// The default directory to store the selenium server, drivers and log files.
  ///
  /// Will be used if no --working-dir param will be specified
  static const String defaultWorkingDirectory = 'build';

  /// The selenium server download url.
  ///
  /// Will be used to download the selenuim server if there are no 'selenium.jar'
  /// file will be found in working directory
  static const String seleniumDownloadUrl =
      'https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar';

  /// Chrome driver download url.
  ///
  /// Will be used to download the chrome driver if there are no 'chromedriver'
  /// file will be found in working directory
  static const String chromeDriverDownloadUrl =
      'https://chromedriver.storage.googleapis.com/83.0.4103.39/chromedriver_mac64.zip';

  /// Firefox driver download url.
  ///
  /// Will be used to download the firefox driver (geckodriver) if there are no
  /// 'geckodriver' will be found in working directory
  static const String firefoxDriverDownloadUrl =
      'https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-macos.tar.gz';
}
