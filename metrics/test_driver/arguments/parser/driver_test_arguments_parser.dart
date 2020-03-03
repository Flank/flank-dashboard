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
  static const String _helpFlagName = 'help';

  static final _parser = ArgParser();

  /// Parses the [args] and creates the [DriverTestArguments].
  static DriverTestArguments parseArguments(List<String> args) {
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
    final showHelp = result[_helpFlagName] as bool;

    return DriverTestArguments(
      port: port,
      logsDir: logsDir,
      workingDir: workingDir,
      browserName: browserName,
      verbose: verbose,
      quiet: quiet,
      showHelp: showHelp,
    );
  }

  /// Configures all available arguments.
  static void configureParser() {
    _parser.addCommand('flutter_web_driver');

    _parser.addFlag(
      _helpFlagName,
      abbr: 'h',
      help: 'Prints the usage information',
      negatable: false,
    );

    _parser.addFlag(
      _verboseFlagName,
      help: "The verbose mode pronts all the outputs to the stdout.",
      abbr: 'v',
      defaultsTo: true,
    );

    _parser.addFlag(
      _quietFlagName,
      help: 'Silences all the driver and run command outputs.',
      negatable: false,
    );

    _parser.addOption(
      _workingDirOptionName,
      help:
          "The directory to save the selenium server and browser drivers files.",
      defaultsTo: '${DriverTestsConfig.defaultWorkingDirectory}',
    );

    _parser.addOption(
      _portOptionName,
      help: 'The port to serve the application under tests from.',
      defaultsTo: '${DriverTestsConfig.port}',
    );

    _parser.addOption(
      _storeLogsToOptionName,
      help:
          "The directory to store output from running application and driver tests.",
      defaultsTo: DriverTestsConfig.defaultWorkingDirectory,
    );

    _parser.addOption(
      _browserNameOptionName,
      help: 'Name of browser where tests will be executed.',
      defaultsTo: '${BrowserName.chrome}',
    );
  }

  static void showHelp() {
    print(_parser.usage);
  }
}
