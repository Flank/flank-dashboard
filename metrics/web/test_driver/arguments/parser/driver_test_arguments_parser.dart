// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/args.dart';

import '../../common/config/browser_name.dart';
import '../../common/config/driver_tests_config.dart';
import '../model/driver_test_arguments.dart';
import '../model/user_credentials.dart';

/// Parses the arguments for the driver tests.
class DriverTestArgumentsParser {
  static const String _workingDirOptionName = 'working-dir';
  static const String _storeLogsToOptionName = 'store-logs-to';
  static const String _browserNameOptionName = 'browser-name';
  static const String _chromedriverVersion = 'chromedriver-version';
  static const String _emailOptionName = 'email';
  static const String _passwordOptionName = 'password';
  static const String _verboseFlagName = 'verbose';
  static const String _quietFlagName = 'quiet';
  static const String _helpFlagName = 'help';

  final _parser = ArgParser();

  DriverTestArgumentsParser() {
    _configureParser();
  }

  /// Parses the [args] and creates the [DriverTestArguments].
  DriverTestArguments parseArguments(List<String> args) {
    final result = _parser.parse(args);

    final browserNameArg = result[_browserNameOptionName] as String;
    final browserName =
        BrowserName.fromValue(browserNameArg) ?? BrowserName.chrome;

    final verbose = result[_verboseFlagName] as bool;
    final quiet = result[_quietFlagName] as bool;
    final logsDir = result[_storeLogsToOptionName] as String;
    final workingDir = result[_workingDirOptionName] as String;
    final showHelp = result[_helpFlagName] as bool;
    final email = result[_emailOptionName] as String;
    final password = result[_passwordOptionName] as String;
    final chromedriverVersion = result[_chromedriverVersion] as String;

    return DriverTestArguments(
      logsDir: logsDir,
      workingDir: workingDir,
      browserName: browserName,
      verbose: verbose,
      quiet: quiet,
      showHelp: showHelp,
      chromedriverVersion: chromedriverVersion,
      credentials: UserCredentials(
        email: email,
        password: password,
      ),
    );
  }

  /// Configures all available arguments.
  void _configureParser() {
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
      defaultsTo: DriverTestsConfig.defaultWorkingDirectory,
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
      allowed: BrowserName.values.map((name) => name.toString()),
      defaultsTo: '${BrowserName.chrome}',
    );

    _parser.addOption(
      _chromedriverVersion,
      help:
          'The chromedriver version to use for tests if the driver is not installed. If not specified, the latest version is used.',
    );

    _parser.addOption(
      _emailOptionName,
      help: 'An email the tests will use to log in to the application',
    );

    _parser.addOption(
      _passwordOptionName,
      help: 'A password the tests will use to log in to the application',
    );
  }

  void showHelp() {
    print(_parser.usage);
  }
}
