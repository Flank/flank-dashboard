import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'browser_name.dart';
import 'config/driver_tests_config.dart';
import 'drive_command.dart';
import 'util/file_utils.dart';

// Automate running Flutter Web Driver tests for Chrome and Firefox
// https://github.com/flutter/flutter/blob/93a5b7d419d764bfcad2fea25ab6dc62d39f401a/packages/flutter_driver/lib/src/driver/web_driver.dart#L27

// TODO: Why do we get 'Unhandled exception: Bad state: No element' when running the script a few times?

// TODO: refactor this into a Flutter Web Driver package on pub.dev
Future<void> main() async {
  final Directory workingDir = Directory('build');
  workingDir.createSync();

  final workingDirPath = workingDir.path;

  final seleniumPath = await FileUtils.downloadSelenium(workingDirPath);
  await FileUtils.downloadChromeDriver(workingDirPath);
  await FileUtils.downloadFirefoxDriver(workingDirPath);

  print('Running $seleniumPath...');

  final seleniumPid = await _startSelenium(seleniumPath, workingDirPath);

  print("Selenium server is up, running flutter application...");

  final flutterAppProcess = await _startFlutterApp();

  print("Application is up, running tests...");

  exitCode = await _runDriverTests();

  print("Cleaning...");

  // TODO: Always kill pids, even if an error/exception is thrown in the script
  // Killing all processes
  Process.killPid(seleniumPid);
  Process.killPid(flutterAppProcess.pid);

  exit(exitCode);
}

Future<int> _startSelenium(String seleniumPath, String workingDir) async {
  final seleniumProcess = await _processStart(
    'java',
    ['-jar', seleniumPath],
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

  return seleniumProcess.pid;
}

Future<Process> _startFlutterApp() async {
  final flutterProcess = await _processStart(
    'flutter',
    [
      'run',
      '-v',
      '-d',
      'web-server',
      '-t',
      'lib/app.dart',
      '--web-port',
      '${DriverTestsConfig.port}',
    ],
  );

  final broadcastStdOut = flutterProcess.stdout.asBroadcastStream();

  await broadcastStdOut.firstWhere((out) {
    final consoleOut = String.fromCharCodes(out);
    return consoleOut.contains('is being served at');
  });

  // TODO: Save stdout/stderr output from flutterProcess to text file

  return flutterProcess;
}

// TODO: Support taking a configuration option: chrome or firefox for browser-name
Future<int> _runDriverTests() async {
  final driverProcess = await _processStart(
    'flutter',
    DriveCommand()
        .target('lib/app.dart')
        .driver('test_driver/app_test.dart')
        .useExistingApp('http://localhost:${DriverTestsConfig.port}/#')
        .noKeepAppRunning()
        .browserName(BrowserName.chrome),
  );

  // TODO: Save stdout/stderr output from driver to text file
  driverProcess.stdout.transform(utf8.decoder).listen((event) {
    print(event);
  });
  driverProcess.stderr.transform(utf8.decoder).listen((event) {
    print(event);
  });

  return driverProcess.exitCode;
}

Future<Process> _processStart(String executable, List<String> arguments,
    {String workingDirectory,
    Map<String, String> environment,
    bool includeParentEnvironment: true,
    bool runInShell: false,
    ProcessStartMode mode: ProcessStartMode.normal}) {
  print("$executable ${arguments.join(" ")}\n");

  return Process.start(executable, arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      mode: mode);
}
