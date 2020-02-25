import 'dart:convert';

import 'package:http/http.dart';

import '../../common/runner/process_runner.dart';
import '../command/selenium_command.dart';
import '../process/selenium_process.dart';
import '../selenium.dart';

/// Runs the selenium process.
class SeleniumProcessRunner implements ProcessRunner {
  static const String seleniumHealthRequest =
      "http://localhost:4444/wd/hub/status";

  final SeleniumCommand _arguments;

  SeleniumProcessRunner()
      : _arguments = SeleniumCommand(Selenium.seleniumFileName);

  @override
  Future<SeleniumProcess> run({String workingDir}) async {
    return SeleniumProcess.start(
      _arguments,
      workingDir: workingDir,
    );
  }

  @override
  Future<void> get started async {
    bool seleniumIsUp = false;

    while (!seleniumIsUp) {
      final seleniumResponse =
          await get(seleniumHealthRequest).catchError((_) => null);

      if (seleniumResponse == null) continue;

      final seleniumResponseBody = jsonDecode(seleniumResponse.body);

      seleniumIsUp = seleniumResponseBody['value']['ready'] as bool;
    }
  }

  @override
  List<String> get args => _arguments.buildArgs();

  @override
  String get executableName => SeleniumCommand.executableName;
}
