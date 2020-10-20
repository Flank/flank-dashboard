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

  /// Chrome driver download url.
  ///
  /// Will be used to download the chrome driver if there are no 'chromedriver'
  /// file will be found in working directory
  static const String chromeDriverDownloadUrl =
      'https://chromedriver.storage.googleapis.com/85.0.4183.87/chromedriver_mac64.zip';
}
