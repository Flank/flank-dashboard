// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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
}
