// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:args/src/arg_results.dart';
import 'package:coverage_converter/common/arguments/model/coverage_converter_arguments.dart';
import 'package:coverage_converter/common/arguments/parser/arguments_parser.dart';
import 'package:test/test.dart';

void main() {
  group("ArgumentsParser", () {
    test(
      ".configureArguments() configures the given arg parser to accept the input option",
      () {
        final parser = ArgParser();
        final argumentsParser = _ArgumentsParserFake();

        argumentsParser.configureArguments(parser);

        final options = parser.options;

        expect(options, contains(ArgumentsParser.inputArgumentName));
      },
    );

    test(
      ".configureArguments() configures the given arg parser to accept the output option",
      () {
        final parser = ArgParser();
        final argumentsParser = _ArgumentsParserFake();

        argumentsParser.configureArguments(parser);

        final options = parser.options;

        expect(options, contains(ArgumentsParser.outputArgumentName));
      },
    );

    test(
      ".configureArguments() configures the given arg parser to have the default output option value",
      () {
        final parser = ArgParser();
        final argumentsParser = _ArgumentsParserFake();

        argumentsParser.configureArguments(parser);

        final options = parser.options;
        final outputOption = options[ArgumentsParser.outputArgumentName];

        expect(outputOption.defaultsTo, isNotNull);
      },
    );
  });
}

/// An [ArgumentsParser] fake class needed to test
/// the non-abstract methods.
class _ArgumentsParserFake extends ArgumentsParser {
  @override
  CoverageConverterArguments parseArgResults(ArgResults argResults) => null;
}
