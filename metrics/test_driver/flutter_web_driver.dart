import 'dart:io';

import 'common/arguments/driver_tests_parser.dart';
import 'common/process_manager/process_manager.dart';
import 'util/file_utils.dart';

Future<void> main(List<String> arguments) async {
  final args = DriverTestsArgs(arguments);

  final Directory workingDir = Directory(args.workDir);
  final Directory logsDir = Directory(args.logsDir);

  if (!workingDir.existsSync()) workingDir.createSync();
  if (!logsDir.existsSync()) logsDir.createSync();

  final workingDirPath = workingDir.path;

  final processManager = ProcessManager(args.port, logsDir.path);

  final seleniumFileName = await FileUtils.downloadSelenium(workingDirPath);
  await FileUtils.downloadChromeDriver(workingDirPath);
  await FileUtils.downloadFirefoxDriver(workingDirPath);

  print('Running $seleniumFileName...');

  await processManager.startSelenium(seleniumFileName, workingDirPath);

  print("Selenium server is up, running flutter application...");

  await processManager.startFlutterApp().catchError((error) {
    exitCode = 1;
    processManager.exitApp();
  });

  stdout.done.asStream().listen((_) => processManager.exitApp());

  print("Application is up, running tests...");

  await processManager.startDriverTests(browserName: args.browserName);

  processManager.exitApp();
}
