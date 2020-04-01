import 'dart:io';

import 'package:ci_integration/ci_integration/runner/ci_integration_runner.dart';

Future<void> main(List<String> arguments) async {
  final runner = CiIntegrationsRunner();

  try {
    await runner.run(arguments);
    exit(0);
  } catch (error) {
    stderr.writeln(error);
    exit(1);
  }
}
