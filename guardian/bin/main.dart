import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:guardian/runner/options/global_options.dart';
import 'package:guardian/runner/guardian_runner.dart';

Future<void> main(List<String> arguments) async {
  final globalOptions = GlobalOptions();
  final runner = GuardianRunner();

  try {
    await runner.run(arguments);
    exit(0);
  } catch (error, stackTrace) {
    if (error is UsageException) {
      stdout.writeln(error);
    } else {
      stdout.writeln(error);
    }

    if (globalOptions.enableStackTrace ?? false) {
      stdout.writeln(stackTrace);
    }
    exit(1);
  }
}
