import '../../common/config/browser_name.dart';
import 'user_credentials.dart';

/// Represents the arguments for the test driver application.
class DriverTestArguments {
  /// The directory to run all the commands.
  final String workingDir;

  /// The directory to store the logs from commands.
  final String logsDir;

  /// The version of the chromedriver.
  final String chromedriverVersion;

  /// The name of the browser, used to run the tests.
  final BrowserName browserName;

  /// Specifies whether run all commands with the `--verbose` flag or not.
  final bool verbose;

  /// Disables any prints to the console.
  final bool quiet;

  /// Specifies whether to print the usage information or not.
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
