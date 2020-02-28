import '../../common/config/browser_name.dart';

/// Represents the arguments for the test driver application.
class DriverTestArguments {
  final String workingDir;
  final String logsDir;
  final int port;
  final BrowserName browserName;
  final bool verbose;
  final bool quiet;

  /// Creates the [DriverTestArguments].
  ///
  /// [workingDir] is the directory to run all the commands.
  /// [logsDir] is the directory to store the logs from commands.
  /// [port] is the port to run the application under test on.
  /// [browserName] is the name of the browser, used to run the tests.
  /// [verbose] specifies whether run all commands with the `--verbose` flag or not.
  /// [quiet] disables any prints to the console.
  DriverTestArguments({
    this.workingDir,
    this.logsDir,
    this.port,
    this.browserName,
    this.verbose,
    this.quiet,
  });
}
