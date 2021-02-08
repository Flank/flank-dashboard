// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:coverage_converter/common/runner/coverage_converter_runner.dart';
import 'package:coverage_converter/lcov/command/lcov_coverage_converter_command.dart';
import 'package:test/test.dart';

void main() {
  group("CoverageConverterRunner", () {
    test("successfully creates an instance", () {
      expect(() => CoverageConverterRunner(), returnsNormally);
    });

    test("contains an LCOV coverage converter command", () {
      final runner = CoverageConverterRunner();

      expect(
        runner.commands.values,
        contains(isA<LcovCoverageConverterCommand>()),
      );
    });
  });
}
