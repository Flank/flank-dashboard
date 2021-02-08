// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:coverage_converter/lcov/command/lcov_coverage_converter_command.dart';

/// A [CommandRunner] for the coverage converter CLI.
class CoverageConverterRunner extends CommandRunner<void> {
  /// Creates a new instance of the [CoverageConverterRunner]
  /// and registers all available sub-commands.
  CoverageConverterRunner()
      : super(
          'coverage_converter',
          'A coverage converter tool.',
        ) {
    addCommand(LcovCoverageConverterCommand());
  }
}
