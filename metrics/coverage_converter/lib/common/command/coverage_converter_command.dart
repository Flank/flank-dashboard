// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:coverage_converter/common/arguments/model/coverage_converter_arguments.dart';
import 'package:coverage_converter/common/arguments/parser/arguments_parser.dart';
import 'package:coverage_converter/common/converter/coverage_converter.dart';
import 'package:coverage_converter/common/exception/coverage_converter_exception.dart';
import 'package:coverage_converter/common/exception/error_code/coverage_converter_error_code.dart';

/// An abstract class that represents the specific coverage format converter [Command].
abstract class CoverageConverterCommand<T extends CoverageConverterArguments>
    extends Command<void> {
  /// An [ArgumentsParser] used to parse the arguments for this command.
  final ArgumentsParser<T> argumentsParser;

  /// A [CoverageConverter] used to convert the specific coverage report.
  CoverageConverter<T, dynamic> get converter;

  /// Creates a new instance of the [CoverageConverterCommand]
  /// with the given [argumentsParser].
  ///
  /// The [argumentsParser] must not be null.
  CoverageConverterCommand(this.argumentsParser) {
    ArgumentError.checkNotNull(argumentsParser, 'argumentsParser');

    argumentsParser.configureArguments(argParser);
  }

  @override
  Future<void> run() async {
    final arguments = argumentsParser.parseArgResults(argResults);
    final inputFile = getInputFile(arguments.inputFilePath);

    if (!inputFile.existsSync()) {
      throw const CoverageConverterException(
        CoverageConverterErrorCode.noSuchFile,
      );
    }

    final coverage = await converter.parse(inputFile);
    final coverageData = await converter.convert(coverage, arguments);

    final outputFile = getOutputFile(arguments.outputFilePath);

    outputFile.writeAsStringSync(jsonEncode(coverageData.toJson()));
  }

  /// Returns the input [File] by the given [inputFilePath].
  File getInputFile(String inputFilePath) {
    return File(inputFilePath);
  }

  /// Returns the output [File] by the given [outputFilePath].
  File getOutputFile(String outputFilePath) {
    return File(outputFilePath)..createSync();
  }
}
