import 'dart:io';

import 'package:ci_integration/command/logger/logger.dart';
import 'package:ci_integration/command/runner/ci_integration_runner.dart';

Future<void> main(List<String> arguments) async {
  final Logger logger = Logger();
  final runner = CiIntegrationsRunner(logger);

  try {
    await runner.run(arguments);
    exit(0);
  } catch (error) {
    logger.printError(error);
    exit(1);
  }
}
