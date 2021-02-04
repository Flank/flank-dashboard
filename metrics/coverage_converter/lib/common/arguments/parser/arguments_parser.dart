// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:coverage_converter/common/arguments/model/coverage_converter_arguments.dart';
import 'package:meta/meta.dart';

/// An abstract class used to configure and parse the command line arguments.
abstract class ArgumentsParser<T extends CoverageConverterArguments> {
  /// A name of the input file path argument.
  static const String inputArgumentName = 'input';

  /// A name of the output file path argument.
  static const String outputArgumentName = 'output';

  /// Configures the given [argParser] to accept the required arguments.
  ///
  /// The implementers must call super implementation.
  @mustCallSuper
  void configureArguments(ArgParser argParser) {
    argParser.addOption(
      inputArgumentName,
      help:
          'A file path to the input file containing the specific coverage reports',
      valueHelp: 'coverage/lcov_coverage.info',
      abbr: 'i',
    );

    argParser.addOption(
      outputArgumentName,
      help:
          'A file path to the output file to write the CI integrations readable coverage report',
      valueHelp: 'coverage/coverage-summary.json',
      abbr: 'o',
      defaultsTo: 'coverage-summary.json',
    );
  }

  /// Parses the [argResults] to the [T] object.
  T parseArgResults(ArgResults argResults);
}
