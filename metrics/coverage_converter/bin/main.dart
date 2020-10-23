import 'dart:io';

import 'package:coverage_converter/common/runner/coverage_converter_runner.dart';

Future<void> main(List<String> arguments) async {
  final runner = CoverageConverterRunner();

  try {
    await runner.run(arguments);
    exit(0);
  } catch (exception) {
    stderr.writeln(exception);
    exit(1);
  }
}
