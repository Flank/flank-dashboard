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
  static const String _verboseFlagName = 'verbose';
  static const String _quietFlagName = 'quiet';

  String _workingDir;
  String _logsDir;
  int _port;
  BrowserName _browserName;
  bool _verbose;
  bool _quiet;

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

    _parser.addFlag(
      _verboseFlagName,
      help: "The verbose mode pronts all the outputs to the stdout",
      abbr: 'v',
    );

    _parser.addFlag(
      _quietFlagName,
      help: 'Silences all the driver and run command ooutputs',
    );

    final result = _parser.parse(args);
    final portArgString = result[_portOptionName] as String;
    final browserName = result[_browserNameOptionName] as String;
    final verbose = result[_verboseFlagName] as bool;
    final quiet = result[_quietFlagName] as bool;

    _workingDir = result[_workingDirOptionName] as String;
    _logsDir = result[_storeLogsToOptionName] as String;
    _port = int.tryParse(portArgString) ?? DriverTestsConfig.port;
    _browserName = BrowserName.fromValue(browserName) ?? BrowserName.chrome;
    _verbose = verbose;
    _quiet = quiet;
  }

  String get workDir => _workingDir;

  int get port => _port;

  String get logsDir => _logsDir;

  BrowserName get browserName => _browserName;

  bool get verbose => _verbose;

  bool get quiet => _quiet;
}
