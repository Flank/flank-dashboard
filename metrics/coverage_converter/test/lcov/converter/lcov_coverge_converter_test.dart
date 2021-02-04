// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:coverage_converter/common/exception/coverage_converter_exception.dart';
import 'package:coverage_converter/common/exception/error_code/coverage_converter_error_code.dart';
import 'package:coverage_converter/lcov/converter/lcov_coverage_converter.dart';
import 'package:lcov/lcov.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../utils/file_mock.dart';

void main() {
  group("LcovCoverageConverter", () {
    const linesFound = 10;
    const linesHit = 4;

    final converter = LcovCoverageConverter();
    final inputFile = FileMock();

    tearDown(() {
      reset(inputFile);
    });

    test(
      ".parse() returns Report if the given file is a valid LCOV report",
      () {
        const validCoverageReport =
            "SF:test.dart\nLF:$linesFound\nLH:$linesHit\nend_of_record";

        when(inputFile.readAsStringSync()).thenReturn(validCoverageReport);

        final canConvert = converter.parse(inputFile);

        expect(canConvert, isNotNull);
      },
    );

    test(
      ".parse() throws an invalid file format exception if the given file is not valid LCOV report",
      () {
        const invalidCoverageReport = "SF:lib/main.dart\nDA:3,0";

        const expectedException = CoverageConverterException(
          CoverageConverterErrorCode.invalidFileFormat,
        );

        when(inputFile.readAsStringSync()).thenReturn(invalidCoverageReport);

        expect(
          () => converter.parse(inputFile),
          throwsA(expectedException),
        );
      },
    );

    test(
      ".parse() throws an invalid file format exception if the given file is null",
      () {
        const expectedException = CoverageConverterException(
          CoverageConverterErrorCode.invalidFileFormat,
        );

        expect(
          () => converter.parse(null),
          throwsA(expectedException),
        );
      },
    );

    test(
      ".convert() calculates the total line coverage from the given report",
      () {
        final expectedCoverage = CoverageData(
          percent: Percent(linesHit / linesFound),
        );

        final coverageReport = Report('test', [
          Record(
            'test.dart',
            lines: LineCoverage(linesFound, linesHit),
          )
        ]);

        final coverage = converter.convert(coverageReport, null);

        expect(coverage, equals(expectedCoverage));
      },
    );

    test(
      ".convert() returns coverage with null percent if the given report does not contain any lines",
      () {
        const expectedCoverage = CoverageData();

        final coverageReport = Report('test', [
          Record(
            'test.dart',
            lines: LineCoverage(),
          )
        ]);

        final coverage = converter.convert(coverageReport, null);

        expect(coverage, equals(expectedCoverage));
      },
    );
  });
}
