import '../../common/config/browser_name.dart';
import 'user_credentials.dart';

/// Represents the arguments for the test driver application.
class DriverTestArguments {
  final String workingDir;
  final String logsDir;
  final BrowserName browserName;
  final bool verbose;
  final bool quiet;
  final bool showHelp;
  final UserCredentials credentials;

  /// Creates the [DriverTestArguments].
  ///
  /// [workingDir] is the directory to run all the commands.
  /// [logsDir] is the directory to store the logs from commands.
  /// [browserName] is the name of the browser, used to run the tests.
  /// [verbose] specifies whether run all commands with the `--verbose` flag or not.
  /// [quiet] disables any prints to the console.
  /// [showHelp] specifies whether to print the usage information or not.
  DriverTestArguments({
    this.workingDir,
    this.logsDir,
    this.browserName,
    this.verbose,
    this.quiet,
    this.showHelp,
    this.credentials,
  });
}
