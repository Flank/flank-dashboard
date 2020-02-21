import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../util/file_utils.dart';
import '../command/command.dart';
import '../config/browser_name.dart';
import '../config/device.dart';
import 'process/flutter_process.dart';
import 'process/process_wrapper.dart';
import 'process/selenium_process.dart';

/// Starts new processes and then manages them.
class ProcessManager {
  static const String flutterLogsFileName = 'flutter_logs';
  static const String driverLogsFileName = 'driver_logs';

  final List<Process> _startedProcesses = [];
  final int _port;
  final String _logsDir;
  final bool _verbose;
  final bool _quiet;

  ProcessManager(
    this._port,
    this._logsDir, {
    bool verbose = false,
    bool quiet = false,
  })  : _verbose = verbose,
        _quiet = quiet;

  /// Kills all started processes and then exits the app with the current [exitCode].
  void exitApp() {
    print("Cleaning...");

    for (final process in _startedProcesses) {
      process.kill();
    }

    exit(exitCode);
  }

  /// Start the selenium server.
  ///
  /// [seleniumFileName] is the name of the selenium server file.
  /// [workingDir] is the directory in which the selenium server file
  /// and driver files are placed.
  Future startSelenium(String seleniumFileName, String workingDir) async {
    final args = ['-jar', seleniumFileName];

    _logCommandRun(SeleniumProcess.executableName, args);

    final seleniumProcess = await SeleniumProcess.start(
      args,
      workingDir: workingDir,
    );

    _startedProcesses.add(seleniumProcess);

    const seleniumHealthRequest = "http://localhost:4444/wd/hub/status";

    bool seleniumIsUp = false;

    while (!seleniumIsUp) {
      final seleniumResponse =
          await http.get(seleniumHealthRequest).catchError((_) => null);

      if (seleniumResponse == null) continue;

      final seleniumResponseBody = jsonDecode(seleniumResponse.body);

      seleniumIsUp = seleniumResponseBody['value']['ready'] as bool;
    }
  }

  /// Starts the available for testing flutter application.
  ///
  /// Returns the id of the started process.
  Future<Process> startFlutterApp({
    bool useSkia = false,
    String logFileName = flutterLogsFileName,
  }) async {
    final runCommand = RunCommand()
      ..device(Device.webServer)
      ..target('lib/app.dart')
      ..webPort(_port)
      ..useSkia(value: useSkia);

    if (_verbose) {
      runCommand.verbose();
    }

    final args = runCommand.buildArgs();

    _logCommandRun(FlutterProcess.executableName, args);

    final flutterProcess = await FlutterProcess.start(args);

    _startedProcesses.add(flutterProcess);

    flutterProcess.stderrBroadcast
        .listen((_) => _processErrorHandler(flutterProcess));

    _subscribeToProcessOutput(
      flutterProcess,
      logFileName,
    );

    await flutterProcess.stdoutBroadcast.firstWhere((out) {
      if (out == null || out.isEmpty) return false;
      final consoleOut = String.fromCharCodes(out);
      return consoleOut.contains('is being served at');
    }, orElse: () => null);

    return flutterProcess;
  }

  /// Starts the driver tests.
  ///
  /// Specify the [browserName] param to use the custom browser driver.
  /// Default is [BrowserName.chrome].
  Future<void> startDriverTests({
    BrowserName browserName = BrowserName.chrome,
  }) async {
    final driveCommand = DriveCommand()
      ..target('lib/app.dart')
      ..driver('test_driver/app_test.dart')
      ..device(Device.chrome)
      ..useExistingApp('http://localhost:$_port/#')
      ..browserName(browserName)
      ..noKeepAppRunning();

    if (_verbose) {
      driveCommand.verbose();
    }

    final args = driveCommand.buildArgs();

    _logCommandRun(FlutterProcess.executableName, args);

    final driverProcess = await FlutterProcess.start(args);

    _startedProcesses.add(driverProcess);

    driverProcess.stderrBroadcast
        .asBroadcastStream()
        .listen((error) => _processErrorHandler(driverProcess));

    _subscribeToProcessOutput(
      driverProcess,
      driverLogsFileName,
    );

    exitCode = await driverProcess.exitCode;
  }

  void _logCommandRun(String executable, List<String> args) {
    print("$executable ${args.join(" ")}\n");
  }

  /// Closes the application on process error.
  Future<void> _processErrorHandler(Process process) async {
    exitCode = await process.exitCode;
    exitApp();
  }

  /// Starts listening [outputStream] and [errorStream] and saving
  /// the outputs to [logFileName] file.
  ///
  /// If is not in [_quiet] mode, writes the outputs into [stdout] and [stderr].
  void _subscribeToProcessOutput(
    ProcessWrapper process,
    String logFileName,
  ) {
    final outputStream = process.stdoutBroadcast;
    final errorStream = process.stderrBroadcast;

    if (!_quiet) {
      outputStream.listen(stdout.add);
      errorStream.listen(stderr.add);
    }

    FileUtils.saveOutputsToFile(
      outputStream,
      errorStream,
      logFileName,
      _logsDir,
    );
  }
}
