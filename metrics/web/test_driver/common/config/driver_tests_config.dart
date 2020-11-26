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

  /// A base path for the Chromedriver related URLs.
  static const String chromedriverUrlBasePath =
      'https://chromedriver.storage.googleapis.com';

  /// A name of the archive with the Chromedriver for MacOS.
  static const String macosDriverArchiveName = 'chromedriver_mac64.zip';

  /// A name of the archive with the Chromedriver for Linux.
  static const String linuxDriverArchiveName = 'chromedriver_linux64.zip';

  /// A name of the archive with the Chromedriver for Windows.
  static const String windowsDriverArchiveName = 'chromedriver_win32.zip';
}
