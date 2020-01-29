import 'package:args/args.dart';

import '../config/browser_name.dart';
import '../config/driver_tests_config.dart';

/// Parses and provides the arguments for running the driver tests.
///
/// Available arguments: working-dir, port, store-logs-to and browser-name
class DriverTestsArgs {
  static const String _workingDirOptionName = 'working-dir';
  static const String _portOptionName = 'port';
  static const String _storeLogsToOptionName = 'store-logs-to';
  static const String _browserNameOptionName = 'browser-name';

  String _workingDir;
  String _logsDir;
  int _port;
  BrowserName _browserName;

  DriverTestsArgs(List<String> args) {
    final ArgParser _parser = ArgParser();

    _parser.addOption(
      _workingDirOptionName,
      help:
          "The directory to save the selenium server and browser drivers files. The default is 'build'",
      defaultsTo: '${DriverTestsConfig.defaultWorkingDirectory}',
    );

    _parser.addOption(
      _portOptionName,
      help: 'The port to serve the runned application from',
      defaultsTo: '${DriverTestsConfig.port}',
    );

    _parser.addOption(
      _storeLogsToOptionName,
      help:
          "The directory to store output from running application and driver tests. The default is 'build'",
      defaultsTo: DriverTestsConfig.defaultWorkingDirectory,
    );

    _parser.addOption(
      _browserNameOptionName,
      help:
          'Name of browser where tests will be executed. The default one is chrome',
      defaultsTo: 'chrome',
    );

    final result = _parser.parse(args);
    final portArgString = result[_portOptionName] as String;
    final browserName = result[_browserNameOptionName] as String;

    _workingDir = result[_workingDirOptionName] as String;
    _logsDir = result[_storeLogsToOptionName] as String;
    _port = int.tryParse(portArgString) ?? DriverTestsConfig.port;
    _browserName = BrowserName.fromValue(browserName) ?? BrowserName.chrome;
  }

  String get workDir => _workingDir;

  int get port => _port;

  String get logsDir => _logsDir;

  BrowserName get browserName => _browserName;
}
