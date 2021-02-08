// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:coverage_converter/common/arguments/parser/coverage_converter_arguments_parser.dart';
import 'package:coverage_converter/lcov/command/lcov_coverage_converter_command.dart';
import 'package:coverage_converter/lcov/converter/lcov_coverage_converter.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LcovCoverageConverterCommand", () {
    test("creates an instance with the given arguments parser", () {
      final argumentsParser = CoverageConverterArgumentsParser();

      final command = LcovCoverageConverterCommand(
        argumentsParser: argumentsParser,
      );

      expect(command.argumentsParser, equals(argumentsParser));
    });

    test(
      "creates an instance with default arguments parser if the given one is null",
      () {
        final command = LcovCoverageConverterCommand(
          argumentsParser: null,
        );

        expect(
          command.argumentsParser,
          isA<CoverageConverterArgumentsParser>(),
        );
      },
    );

    test("provides an LCOV coverage converter", () {
      final command = LcovCoverageConverterCommand();

      expect(command.converter, isA<LcovCoverageConverter>());
    });
  });
}
