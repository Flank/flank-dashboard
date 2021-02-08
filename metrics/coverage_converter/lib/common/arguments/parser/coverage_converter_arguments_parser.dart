// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:coverage_converter/common/arguments/model/coverage_converter_arguments.dart';
import 'package:coverage_converter/common/arguments/parser/arguments_parser.dart';

/// An [ArgumentsParser] used to parse the coverage converter command
/// arguments to [CoverageConverterArguments] object.
class CoverageConverterArgumentsParser
    extends ArgumentsParser<CoverageConverterArguments> {
  @override
  CoverageConverterArguments parseArgResults(ArgResults argResults) {
    final inputFilePath =
        argResults[ArgumentsParser.inputArgumentName] as String;
    final outputFilePath =
        argResults[ArgumentsParser.outputArgumentName] as String;

    return CoverageConverterArguments(
      inputFilePath: inputFilePath,
      outputFilePath: outputFilePath,
    );
  }
}
