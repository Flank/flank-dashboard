class DriverTestsConfig {
  static const int port = 9499;
  static const String seleniumDownloadUrl =
      'https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar';

  // Chrome driver version must match local chrome version
  static const String chromeDriverDownloadUrl =
      'https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_mac64.zip';
  static const String firefoxDriverDownloadUrl =
      'https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-macos.tar.gz';
}
