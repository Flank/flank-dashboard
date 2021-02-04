// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:args/src/arg_results.dart';
import 'package:coverage_converter/common/arguments/model/coverage_converter_arguments.dart';
import 'package:coverage_converter/common/arguments/parser/arguments_parser.dart';
import 'package:coverage_converter/common/command/coverage_converter_command.dart';
import 'package:coverage_converter/common/converter/coverage_converter.dart';
import 'package:coverage_converter/common/exception/coverage_converter_exception.dart';
import 'package:coverage_converter/common/exception/error_code/coverage_converter_error_code.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../utils/file_mock.dart';

void main() {
  group("CoverageConverterCommand", () {
    final converter = _CoverageConverterMock();
    final coverage = CoverageData(percent: Percent(1.0));
    final inputFile = FileMock();
    final outputFile = FileMock();

    tearDown(() {
      reset(inputFile);
      reset(outputFile);
      reset(converter);
    });

    test(
      "throws a 'no such file' exception if the given input file does not exist",
      () {
        const noSuchFileException = CoverageConverterException(
          CoverageConverterErrorCode.noSuchFile,
        );

        when(inputFile.existsSync()).thenReturn(false);

        final command = _CoverageConverterCommandFake(
          inputFile: inputFile,
        );

        expect(command.run, throwsA(equals(noSuchFileException)));
      },
    );

    test(
      "throws an 'invalid file format' exception if the converter throws an 'invalid file format' exception",
      () {
        const invalidFormatException = CoverageConverterException(
          CoverageConverterErrorCode.invalidFileFormat,
        );

        when(inputFile.existsSync()).thenReturn(true);
        when(converter.parse(any)).thenThrow(invalidFormatException);

        final command = _CoverageConverterCommandFake(
          inputFile: inputFile,
          converter: converter,
        );

        expect(command.run, throwsA(equals(invalidFormatException)));
      },
    );

    test(
      "converts the input file",
      () async {
        when(inputFile.existsSync()).thenReturn(true);
        when(converter.convert(any, any)).thenReturn(coverage);

        final command = _CoverageConverterCommandFake(
          inputFile: inputFile,
          outputFile: outputFile,
          converter: converter,
        );

        await command.run();

        verify(converter.convert(any, any)).called(equals(1));
      },
    );

    test(
      "writes the converted file to the output file as a JSON",
      () async {
        final coverageJson = jsonEncode(coverage.toJson());

        when(inputFile.existsSync()).thenReturn(true);
        when(converter.convert(any, any)).thenReturn(coverage);

        final command = _CoverageConverterCommandFake(
          inputFile: inputFile,
          outputFile: outputFile,
          converter: converter,
        );

        await command.run();

        verify(outputFile.writeAsStringSync(coverageJson)).called(equals(1));
      },
    );
  });
}

/// A [CoverageConverterCommand] fake class used to test the non-abstract methods.
class _CoverageConverterCommandFake extends CoverageConverterCommand {
  /// An input [File] used in tests.
  final File inputFile;

  /// An output [File] used in tests.
  final File outputFile;

  @override
  final CoverageConverter converter;

  @override
  String get description => '';

  @override
  String get name => '';

  /// Creates a new instance of this fake.
  ///
  /// If the [converter] is null, the mock implementation used.
  /// If the [argumentsParser] is null, the stub implementation used.
  _CoverageConverterCommandFake({
    ArgumentsParser<CoverageConverterArguments> argumentsParser,
    this.inputFile,
    this.outputFile,
    CoverageConverter converter,
  })  : converter = converter ?? _CoverageConverterMock(),
        super(argumentsParser ?? _ArgumentsParserStub());

  @override
  File getInputFile(String path) => inputFile;

  @override
  File getOutputFile(String path) => outputFile;
}

/// A stub implementation of the [ArgumentsParser].
class _ArgumentsParserStub extends ArgumentsParser {
  /// A [CoverageConverterArguments] used in tests.
  final _arguments = CoverageConverterArguments(
    inputFilePath: 'input.json',
    outputFilePath: 'output.json',
  );

  @override
  CoverageConverterArguments parseArgResults(ArgResults argResults) {
    return _arguments;
  }
}

class _CoverageConverterMock extends Mock implements CoverageConverter {}
