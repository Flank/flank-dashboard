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

  /// A base URL download path for the Chromedriver.
  static const String baseDownloadPath =
      'https://chromedriver.storage.googleapis.com';

  /// A Chromedriver name for macOS.
  static const String macosDriverName = 'chromedriver_mac64.zip';

  /// A Chromedriver name for Linux.
  static const String linuxDriverName = 'chromedriver_linux64.zip';

  /// A Chromedriver name for Windows.
  static const String windowsDriverName = 'chromedriver_win32.zip';
}
