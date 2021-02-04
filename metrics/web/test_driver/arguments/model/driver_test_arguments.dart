// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import '../../common/config/browser_name.dart';
import 'user_credentials.dart';

/// A class that represents the arguments for the test driver application.
class DriverTestArguments {
  /// A working directory to run all the commands.
  final String workingDir;

  /// A directory to store the logs from commands.
  final String logsDir;

  /// The version of the chromedriver.
  final String chromedriverVersion;

  /// The name of the browser, used to run the tests.
  final BrowserName browserName;

  /// Indicates whether to run all commands with the `--verbose` flag or not.
  final bool verbose;

  /// Indicates whether to disable any prints to the console from
  /// commands or not.
  final bool quiet;

  /// Indicates whether to print the usage information or not.
  final bool showHelp;

  /// The user credentials for the application.
  final UserCredentials credentials;

  /// Creates a new instance of the [DriverTestArguments].
  DriverTestArguments({
    this.workingDir,
    this.logsDir,
    this.chromedriverVersion,
    this.browserName,
    this.verbose,
    this.quiet,
    this.showHelp,
    this.credentials,
  });
}
