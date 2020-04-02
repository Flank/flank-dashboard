import 'dart:io';

import 'package:ci_integration/ci_integration/runner/ci_integration_runner.dart';
import 'package:ci_integration/common/logger/logger.dart';

Future<void> main(List<String> arguments) async {
  const Logger logger = Logger();
  final runner = CiIntegrationsRunner(logger);

  try {
    await runner.run(arguments);
    exit(0);
  } catch (error) {
    logger.printError(error);
    exit(1);
  }
}
