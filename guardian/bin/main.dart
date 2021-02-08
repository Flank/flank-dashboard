// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:guardian/runner/options/global_options.dart';
import 'package:guardian/runner/guardian_runner.dart';

Future<void> main(List<String> arguments) async {
  final globalOptions = GlobalOptions();
  final runner = GuardianRunner();

  try {
    await runner.run(arguments);
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
