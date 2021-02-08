// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'arguments/model/driver_test_arguments.dart';
import 'arguments/parser/driver_test_arguments_parser.dart';
import 'cli/flutter/model/flutter_drive_environment.dart';
import 'cli/flutter/runner/flutter_drive_process_runner.dart';
import 'cli/web_driver/chrome_driver.dart';
import 'cli/web_driver/runner/chrome_driver_runner.dart';
import 'common/config/logs_file_config.dart';
import 'common/logger/logger.dart';
import 'process_manager/process_manager.dart';

/// Runs the application and driver tests for this application.
class FlutterWebDriver {
  /// An application arguments used to configure testing.
  ///
  /// See [DriverTestArgumentsParser] for all supported arguments.
  final DriverTestArguments _args;

  /// A [ProcessManager] used to manage run processes.
  ProcessManager _processManager;

  /// Creates the [FlutterWebDriver].
  FlutterWebDriver(this._args);

  /// Configures environment and starts driver tests.
  Future<void> startDriverTests() async {
    final bool verbose = _args.verbose;

    _setupLogger(_args.quiet);

    _processManager = ProcessManager(
      processErrorHandler: _processErrorHandler,
    );

    _prepareWorkingDir();

    await _prepareWebDriver();

    _setupDispose();

    Logger.log('Running web driver...');
    await _processManager.run(
      ChromeDriverRunner(),
      workingDir: _args.workingDir,
    );

    Logger.log("Running driver tests...");
    await _runDriverTests(
      verbose,
      LogsFileConfig.driverLogsFileName,
    );

    Logger.log("Running driver tests with SKIA renderer...");
    await _runDriverTests(
      verbose,
      LogsFileConfig.skiaDriverLogsFileName,
      useSkia: true,
    );

    _tearDown();
  }

  /// Listens to the [stdout] onDone event to be able to dispose the [_processManager]
  /// if the application was terminated by the user
  /// (user closed the console window, quit the process, etc.).
  void _setupDispose() {
    stdout.done.asStream().listen((_) => _processManager.dispose());
  }

  /// Sets up logger corresponding to [_args], passed to the application.
  void _setupLogger(bool quiet) {
    final Directory logsDir = Directory(_args.logsDir);
    if (!logsDir.existsSync()) logsDir.createSync(recursive: true);

    Logger.setup(quiet: quiet, logsDirectory: logsDir);
  }

  /// Checks if the working dir exists and creates it if not.
  void _prepareWorkingDir() {
    final Directory workingDir = Directory(_args.workingDir);
    if (!workingDir.existsSync()) workingDir.createSync(recursive: true);
  }

  /// Prepares the web driver for the driver tests.
  Future<void> _prepareWebDriver() async {
    await ChromeDriver(version: _args.chromedriverVersion)
        .prepare(_args.workingDir);
  }

  /// Runs the driver tests.
  ///
  /// [verbose] defines whether print the detailed logs or not.
  /// [logsFileName] is the name of file to store the logs.
  /// [useSkia] defines whether to run the application under test
  /// using the SKIA renderer.
  Future<void> _runDriverTests(
    bool verbose,
    String logsFileName, {
    bool useSkia = false,
  }) async {
    final driverProcessRunner = FlutterDriveProcessRunner(
      browserName: _args.browserName,
      verbose: verbose,
      environment: FlutterDriveEnvironment(userCredentials: _args.credentials),
      useSkia: useSkia,
    );

    final driverProcess = await _processManager.run(
      driverProcessRunner,
      logFileName: logsFileName,
    );

    final driverExitCode = await driverProcess.exitCode;
    exitCode = driverExitCode;
  }

  /// Disposes the [_processManager] and exits the app
  /// with the [process]'s exit code.
  Future<void> _processErrorHandler(Process process) async {
    _processManager.dispose();
    exit(await process.exitCode);
  }

  /// Cleans up the driver test before finishing it.
  ///
  /// Disposes the [_processManager] and prints the logs file location to console.
  void _tearDown() {
    final logsDirUri = Logger.logsDirectory.absolute.uri;

    Logger.log(
        "Driver logs are stored in $logsDirUri${LogsFileConfig.driverLogsFileName} file");

    Logger.log(
        "Driver, ran with skia renderer, logs are stored in $logsDirUri${LogsFileConfig.skiaDriverLogsFileName} file");

    _processManager.dispose();
  }
}
