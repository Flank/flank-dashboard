import 'dart:io';

import 'package:coverage_converter/common/runner/coverage_converter_runner.dart';

void main(List<String> arguments) {
  final runner = CoverageConverterRunner();

  try {
    runner.run(arguments);
    exit(0);
  } catch (exception) {
    stderr.writeln(exception);
    exit(1);
  }
}
