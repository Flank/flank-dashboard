import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../util/file_utils.dart';
import '../command/drive_command.dart';
import '../command/run_command.dart';
import '../config/browser_name.dart';
import '../config/device.dart';

/// The class needed to manage started processes and start new processes
class ProcessManager {
  final List<int> _startedPids = [];
  final int _port;
  final String _logsDir;

  ProcessManager(
    this._port,
    this._logsDir,
  );

  /// Kill all started processes and exit the app with the current [exitCode]
  void exitApp() {
    print("Cleaning...");

    for (final pid in _startedPids) {
      Process.killPid(pid);
    }

    exit(exitCode);
  }

  /// Start the selenium server
  /// [seleniumFileName] it the name of the selenium server file
  /// [workingDir] is the directory in which the selenium server file
  /// and driver files are placed
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

  /// Starts the available for testing flutter application
  Future<void> startFlutterApp() async {
    final runCommand = RunCommand()
      ..verbose()
      ..device(Device.webServer)
      ..target('lib/app.dart')
      ..webPort(_port);

    final flutterProcess = await _processStart(
      'flutter',
      runCommand.buildArgs(),
    );

    final flutterOutput = flutterProcess.stdout.asBroadcastStream();

    FileUtils.saveOutputsToFile(
      flutterOutput,
      flutterProcess.stderr,
      'flutter_logs',
      _logsDir,
    );

    await flutterOutput.firstWhere((out) {
      if (out == null || out.isEmpty) return false;
      final consoleOut = String.fromCharCodes(out);
      return consoleOut.contains('is being served at');
    });
  }

  /// Starts the driver tests with the given
  /// Specify the [browserName] param to use the custom browser driver.
  /// Default is [BrowserName.chrome]
  Future<void> startDriverTests({
    BrowserName browserName = BrowserName.chrome,
  }) async {
    final driveCommand = DriveCommand()
      ..target('lib/app.dart')
      ..driver('test_driver/app_test.dart')
      ..useExistingApp('http://localhost:$_port/#')
      ..browserName(browserName)
      ..noKeepAppRunning();

    final driverProcess = await _processStart(
      'flutter',
      driveCommand.buildArgs(),
    );

    FileUtils.saveOutputsToFile(
      driverProcess.stdout,
      driverProcess.stderr,
      'drvier_logs',
      _logsDir,
    );

    exitCode = await driverProcess.exitCode;
  }

  /// Starts a process running the [executable] with the specified [arguments]
  /// and adds the process pid to [_startedPids] to be able to terminate it.
  /// Specify the [workingDirectory] to run the executable from this directory
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

    _startedPids.add(process.pid);

    return process;
  }
}
