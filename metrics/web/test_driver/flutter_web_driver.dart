import 'dart:async';
import 'dart:io';

import 'arguments/model/driver_test_arguments.dart';
import 'arguments/parser/driver_test_arguments_parser.dart';
import 'cli/common/process/process_wrapper.dart';
import 'cli/flutter/runner/flutter_drive_process_runner.dart';
import 'cli/flutter/runner/flutter_run_process_runner.dart';
import 'cli/selenium/runner/selenium_process_runner.dart';
import 'cli/selenium/selenium.dart';
import 'common/config/logs_file_config.dart';
import 'common/logger/logger.dart';
import 'process_manager/process_manager.dart';

/// Runs the application and driver tests for this application.
class FlutterWebDriver {
  final DriverTestArguments _args;
  ProcessManager _processManager;

  /// Creates the [FlutterWebDriver].
  ///
  /// [args] is the application arguments used to configure testing.
  /// See [DriverTestArgumentsParser] for all supported arguments..
  FlutterWebDriver(this._args);

  /// Configures environment and starts driver tests.
  Future<void> startDriverTests() async {
    final bool verbose = _args.verbose;
    final int port = _args.port;

    _setupLogger(_args.quiet);

    _processManager = ProcessManager(
      processErrorHandler: _processErrorHandler,
    );

    _prepareWorkingDir();

    await _prepareSelenium();

    _setupDispose();

    Logger.log('Running selenium...');
    await _processManager.run(
      SeleniumProcessRunner(),
      workingDir: _args.workingDir,
    );

    Logger.log("Selenium server is up, running flutter application...");
    final flutterAppProcess = await _runFlutterApp(port, verbose);

    Logger.log("Application is up, running tests...");
    await _runDriverTests(port, verbose, LogsFileConfig.driverLogsFileName);
    _processManager.kill(flutterAppProcess);

    Logger.log('Running application using SKIA...');
    await _runFlutterApp(port, verbose, useSkia: true);

    Logger.log("SKIA Application is up, running tests...");
    await _runDriverTests(port, verbose, LogsFileConfig.skiaDriverLogsFileName);

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
    if (!logsDir.existsSync()) logsDir.createSync();

    Logger.setup(quiet: quiet, logsDirectory: logsDir);
  }

  /// Checks if the working dir exists and creates it if not.
  void _prepareWorkingDir() {
    final Directory workingDir = Directory(_args.workingDir);
    if (!workingDir.existsSync()) workingDir.createSync();
  }

  /// Prepares the selenium server for driver tests.
  Future<void> _prepareSelenium() async {
    await Selenium.prepare(_args.workingDir);
  }

  /// Runs the flutter web app on specified [port].
  ///
  /// [verbose] defines whether to print detailed logs or not.
  /// [useSkia] defines whether use the SKIA renderer or not.
  Future<ProcessWrapper> _runFlutterApp(
    int port,
    bool verbose, {
    bool useSkia = false,
  }) async {
    final flutterProcessRunner = FlutterRunProcessRunner(
      port: port,
      verbose: verbose,
    );

    final flutterRunProcess = await _processManager.run(
      flutterProcessRunner,
      logFileName: LogsFileConfig.flutterLogsFileName,
    );
    return flutterRunProcess;
  }

  /// Runs the driver tests.
  ///
  /// [port] is the port on which the application under test is running.
  /// [verbose] defines whether print the detailed logs or not.
  /// [logsFileName] is the name of file to store the logs
  Future<void> _runDriverTests(
    int port,
    bool verbose,
    String logsFileName,
  ) async {
    final driverProcessRunner = FlutterDriveProcessRunner(
      port: port,
      browserName: _args.browserName,
      verbose: verbose,
    );

    final driverProcess = await _processManager.run(
      driverProcessRunner,
      logFileName: logsFileName,
    );

    await driverProcess.exitCode;
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
        "Flutter logs are stored in $logsDirUri${LogsFileConfig.flutterLogsFileName} file");
    Logger.log(
        "Driver logs are stored in $logsDirUri${LogsFileConfig.driverLogsFileName} file");
    Logger.log(
        "Flutter, ran with skia renderer, logs are stored in $logsDirUri${LogsFileConfig.skiaFlutterLogsFileName} file");
    Logger.log(
        "Driver, ran with skia renderer, logs are stored in $logsDirUri${LogsFileConfig.skiaDriverLogsFileName} file");

    _processManager.dispose();
  }
}
