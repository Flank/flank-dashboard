// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:coverage_converter/common/arguments/parser/coverage_converter_arguments_parser.dart';
import 'package:test/test.dart';

void main() {
  group("CoverageConverterArgumentsParser", () {
    test(
      ".parseArgResults() parses the given arg results to the CoverageConverterArguments object",
      () {
        const inputFilePath = 'inputFilePath';
        const outputFilePath = 'outputFilePath';
        final options = ['-i', inputFilePath, '-o', outputFilePath];

        final parser = ArgParser();
        final argumentsParser = CoverageConverterArgumentsParser();

        argumentsParser.configureArguments(parser);

        final argResults = parser.parse(options);
        final arguments = argumentsParser.parseArgResults(argResults);

        expect(arguments.inputFilePath, equals(inputFilePath));
        expect(arguments.outputFilePath, equals(outputFilePath));
      },
    );
  });
}
