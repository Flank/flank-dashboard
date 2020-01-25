import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'config/driver_tests_config.dart';
import 'util/file_utils.dart';

// TODO: refactor this into a Flutter Web Driver package on pub.dev
Future<void> main() async {
  final Directory workingDir = Directory('build');
  workingDir.createSync();

  final workingDirPath = workingDir.path;

  final seleniumPath = await FileUtils.downloadSelenium(workingDirPath);
  await FileUtils.downloadChromeDriver(workingDirPath);
  await FileUtils.downloadFirefoxDriver(workingDirPath);

  print('Running selenium $seleniumPath...');

  final seleniumPid = await _startSelenium(seleniumPath, workingDirPath);

  print("Selenium server is up, runnig flutter application...");

  final flutterAppProcess = await _startFlutterApp();

  print("Application is up, running tests...");

  exitCode = await _runDriverTests();

  print("Cleaning...");

  // Closing flutter application under test like this to make sure that browser window is also closed
  // TODO: remove that as we start in headless now
  flutterAppProcess.stdin.add('q'.codeUnits);

  // Killing all processes
  Process.killPid(seleniumPid);
  Process.killPid(flutterAppProcess.pid);

  exit(exitCode);
}

Future<int> _startSelenium(String seleniumPath, String workingDir) async {
  final seleniumProcess = await Process.start(
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
  final flutterProcess = await Process.start(
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
  final driverProcess = await Process.start(
    'flutter',
    [
      'drive',
      '--target',
      'lib/app.dart',
      '--driver',
      'test_driver/app_test.dart',
      '--use-existing-app',
      'http://localhost:${DriverTestsConfig.port}/#',
      '--browser-name',
      'chrome',
    ],
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
