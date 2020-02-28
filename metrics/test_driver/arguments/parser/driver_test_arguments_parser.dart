import 'package:args/args.dart';

import '../../common/config/browser_name.dart';
import '../../common/config/driver_tests_config.dart';
import '../model/driver_test_arguments.dart';

/// Parses the arguments for the driver tests.
class DriverTestArgumentsParser {
  static const String _workingDirOptionName = 'working-dir';
  static const String _portOptionName = 'port';
  static const String _storeLogsToOptionName = 'store-logs-to';
  static const String _browserNameOptionName = 'browser-name';
  static const String _verboseFlagName = 'verbose';
  static const String _quietFlagName = 'quiet';

  /// Parses the [args] and creates the [DriverTestArguments].
  static DriverTestArguments parseArguments(List<String> args) {
    final _parser = ArgParser();

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
      defaultsTo: '${BrowserName.chrome}',
    );

    _parser.addFlag(
      _verboseFlagName,
      help: "The verbose mode pronts all the outputs to the stdout",
      abbr: 'v',
      defaultsTo: true,
    );

    _parser.addFlag(
      _quietFlagName,
      help: 'Silences all the driver and run command outputs',
    );

    final result = _parser.parse(args);

    final portArgString = result[_portOptionName] as String;
    final port = int.tryParse(portArgString) ?? DriverTestsConfig.port;

    final browserNameArg = result[_browserNameOptionName] as String;
    final browserName =
        BrowserName.fromValue(browserNameArg) ?? BrowserName.chrome;

    final verbose = result[_verboseFlagName] as bool;
    final quiet = result[_quietFlagName] as bool;
    final logsDir = result[_storeLogsToOptionName] as String;
    final workingDir = result[_workingDirOptionName] as String;

    return DriverTestArguments(
      port: port,
      logsDir: logsDir,
      workingDir: workingDir,
      browserName: browserName,
      verbose: verbose,
      quiet: quiet,
    );
  }
}
