// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import '../../common/runner/web_driver_process_runner.dart';
import '../command/chrome_driver_command.dart';
import '../process/chrome_driver_process.dart';

/// A class needed to run the chrome driver for driver tests.
class ChromeDriverRunner extends WebDriverProcessRunner {
  /// An arguments to run the chrome driver with.
  final ChromeDriverCommand _arguments = ChromeDriverCommand()
    ..port(WebDriverProcessRunner.port);

  /// Creates a new instance of the [ChromeDriverRunner].
  ///
  /// [verbose] detects whether the ran process will print verbose logs.
  /// [silent] detects whether the ran process will print any logs or not.
  ///
  /// If the given [verbose] and [silent] are both `true`
  /// the process runs as a` verbose` one.
  ChromeDriverRunner({
    bool verbose = false,
    bool silent = false,
  }) {
    if (verbose) {
      _arguments.verbose();
    } else if (silent) {
      _arguments.silent();
    }
  }

  @override
  Future<ChromeDriverProcess> run({String workingDir}) async {
    await super.run();
    return ChromeDriverProcess.start(
      _arguments,
      workingDir: workingDir,
    );
  }

  @override
  List<String> get args => _arguments.buildArgs();

  @override
  String get executableName => ChromeDriverCommand.executableName;

  @override
  String get statusRequestUrl =>
      'http://localhost:${WebDriverProcessRunner.port}/status';
}
