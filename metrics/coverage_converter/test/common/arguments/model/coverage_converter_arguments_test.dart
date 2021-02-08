// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:coverage_converter/common/arguments/model/coverage_converter_arguments.dart';
import 'package:test/test.dart';

void main() {
  group("CoverageConverterArguments", () {
    const inputFilePath = "coverage/lcov_coverage.info";
    const outputFilePath = "coverage/coverage-summary.json";

    test(
      "throws an ArgumentError if the input file path is null",
      () {
        expect(
          () => CoverageConverterArguments(outputFilePath: outputFilePath),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the output file path is null",
      () {
        expect(
          () => CoverageConverterArguments(inputFilePath: inputFilePath),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final arguments = CoverageConverterArguments(
          inputFilePath: inputFilePath,
          outputFilePath: outputFilePath,
        );

        expect(arguments.inputFilePath, equals(inputFilePath));
        expect(arguments.outputFilePath, equals(outputFilePath));
      },
    );
  });
}
