// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/runner/metrics_cli_runner.dart';

Future main(List<String> arguments) async {
  final runner = MetricsCliRunner();

  try {
    await runner.run(arguments);
    exit(0);
  } catch (error) {
    stderr.writeln(error);
    exit(1);
  }
}
