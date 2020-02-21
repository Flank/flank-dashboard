import 'dart:io';

import 'common/arguments/driver_tests_parser.dart';
import 'common/process_manager/process_manager.dart';
import 'util/file_utils.dart';

Future<void> main(List<String> arguments) async {
  const skiaFlutterLogsFileName = 'skia_flutter_logs';

  final args = DriverTestsArgs(arguments);

  final Directory workingDir = Directory(args.workDir);
  final Directory logsDir = Directory(args.logsDir);

  if (!workingDir.existsSync()) workingDir.createSync();
  if (!logsDir.existsSync()) logsDir.createSync();

  final workingDirPath = workingDir.path;

  final processManager = ProcessManager(
    args.port,
    logsDir.path,
    verbose: args.verbose,
    quiet: args.quiet,
  );

  final seleniumFileName = await FileUtils.downloadSelenium(workingDirPath);
  await FileUtils.downloadChromeDriver(workingDirPath);
  await FileUtils.downloadFirefoxDriver(workingDirPath);

  print('Running $seleniumFileName...');

  await processManager.startSelenium(seleniumFileName, workingDirPath);

  print("Selenium server is up, running flutter application...");

  final flutterProcess = await processManager.startFlutterApp();

  stdout.done.asStream().listen((_) => processManager.exitApp());

  print("Application is up, running tests...");

  await processManager.startDriverTests(browserName: args.browserName);

  flutterProcess.kill();

  print('Running application using SKIA...');

  await processManager.startFlutterApp(
    useSkia: true,
    logFileName: skiaFlutterLogsFileName,
  );

  await processManager.startDriverTests(browserName: args.browserName);

  final logsDirUri = logsDir.absolute.uri;

  print(
      "Flutter logs are stored in $logsDirUri${ProcessManager.flutterLogsFileName}.log file");
  print(
      "Flutter, runned with skia renderer, logs are stored in $logsDirUri$skiaFlutterLogsFileName.log file");
  print(
      "Driver logs are stored in $logsDirUri${ProcessManager.driverLogsFileName}.log file");

  processManager.exitApp();
}
