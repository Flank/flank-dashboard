import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../util/file_utils.dart';
import '../command/command.dart';
import '../config/browser_name.dart';
import '../config/device.dart';

/// The class needed to manage started processes and start new processes.
class ProcessManager {
  static const String flutterLogsFileName = 'flutter_logs';
  static const String driverLogsFileName = 'driver_logs';
  static const String _flutterExecutableName = 'flutter';
  static final _quiteAppCommand = 'q'.codeUnits;

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

  /// Kills all started processes and exit the app with the current [exitCode].
  void exitApp() {
    print("Cleaning...");

    for (final process in _startedProcesses) {
      exitProcess(process);
    }

    exit(exitCode);
  }

  /// Quites the process's application and kills the process.
  void exitProcess(Process process) {
    process.stdin.add(_quiteAppCommand);
    process.kill();
  }

  /// Start the selenium server.
  ///
  /// [seleniumFileName] is the name of the selenium server file.
  /// [workingDir] is the directory in which the selenium server file.
  /// and driver files are placed.
  Future startSelenium(String seleniumFileName, String workingDir) async {
    await _processStart(
      'java',
      ['-jar', seleniumFileName],
      workingDirectory: workingDir,
    );

    const seleniumHealthRequest = "http://localhost:4444/wd/hub/status";

    bool seleniumIsUp = false;

    while (seleniumIsUp) {
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

    final flutterProcess = await _processStart(
      _flutterExecutableName,
      runCommand.buildArgs(),
    );

    final flutterOutput = flutterProcess.stdout.asBroadcastStream();
    final flutterErrors = flutterProcess.stderr.asBroadcastStream();

    flutterErrors.listen((_) => _processErrorHandler(flutterProcess));

    _subscribeToOutput(
      flutterOutput,
      flutterErrors,
      logFileName,
    );

    await flutterOutput.firstWhere((out) {
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

    final driverProcess = await _processStart(
      _flutterExecutableName,
      driveCommand.buildArgs(),
    );

    final driverOutput = driverProcess.stdout.asBroadcastStream();
    final driverErrors = driverProcess.stderr.asBroadcastStream();

    driverErrors.listen((error) => _processErrorHandler(driverProcess));

    _subscribeToOutput(
      driverOutput,
      driverErrors,
      driverLogsFileName,
    );

    exitCode = await driverProcess.exitCode;
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
  void _subscribeToOutput(
    Stream<List<int>> outputStream,
    Stream<List<int>> errorStream,
    String logFileName,
  ) {
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

  /// Starts a process running the [executable] with the specified [arguments].
  ///
  /// Adds the process pid to [_startedProcesses] to be able to terminate it.
  /// Specify the [workingDirectory] to run the executable from this directory.
  Future<Process> _processStart(
    String executable,
    List<String> arguments, {
    String workingDirectory,
  }) async {
    print("$executable ${arguments.join(" ")}\n");

    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
    );

    _startedProcesses.add(process);

    return process;
  }
}
