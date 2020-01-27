import 'package:args/args.dart';

import '../config/browser_name.dart';
import '../config/driver_tests_config.dart';

/// Class needed to parse and provide the arguments for running the driver tests
/// Available arguments: working-dir, port and store-logs-to
class DriverTestsArgs {
  static const String workingDirOptionName = 'working-dir';
  static const String portOptionName = 'port';
  static const String storeLogsToOptionName = 'store-logs-to';
  static const String browserNameOptionName = 'browser-name';

  String _workingDir;
  String _logsDir;
  int _port;
  BrowserName _browserName;

  DriverTestsArgs(List<String> args) {
    final ArgParser _parser = ArgParser();

    _parser.addOption(
      workingDirOptionName,
      help:
          "The directory to save the selenium server and browser drivers files. The default is 'build'",
      defaultsTo: '${DriverTestsConfig.defaultWorkingDirectory}',
    );

    _parser.addOption(
      portOptionName,
      help: 'The port to serve the runned application from',
      defaultsTo: '${DriverTestsConfig.port}',
    );

    _parser.addOption(
      storeLogsToOptionName,
      help:
          "The directory to store output from running application and driver tests. The default is 'build'",
      defaultsTo: DriverTestsConfig.defaultWorkingDirectory,
    );

    _parser.addOption(
      browserNameOptionName,
      help: 'Name of browser where tests will be executed. The default one is chrome',
      defaultsTo: 'chrome',
    );

    final result = _parser.parse(args);
    final portArgString = result[portOptionName] as String;
    final browserName = result[browserNameOptionName] as String;

    _workingDir = result[workingDirOptionName] as String;
    _logsDir = result[storeLogsToOptionName] as String;
    _port = int.tryParse(portArgString) ?? DriverTestsConfig.port;
    _browserName = BrowserName.fromValue(browserName) ?? BrowserName.chrome;
  }

  String get workDir => _workingDir;

  int get port => _port;

  String get logsDir => _logsDir;

  BrowserName get browserName => _browserName;
}
