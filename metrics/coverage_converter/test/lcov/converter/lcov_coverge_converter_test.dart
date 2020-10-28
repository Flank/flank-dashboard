import 'package:coverage_converter/lcov/converter/lcov_coverage_converter.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../utils/file_mock.dart';

void main() {
  group("LcovCoverageConverter", () {
    /// Gets a valid LCOV coverage report used in tests.
    String getValidReport(int linesFound, int linesHit) =>
        "SF:test.dart\nLF:$linesFound\nLH:$linesHit\nend_of_record";

    const linesFound = 10;
    const linesHit = 4;
    const invalidCoverageReport = "SF:lib/main.dart\nDA:3,0";
    final validCoverageReport = getValidReport(linesFound, linesHit);

    final inputFile = FileMock();
    final converter = LcovCoverageConverter();

    tearDown(() {
      reset(inputFile);
    });

    test(
      ".canConvert() returns true if the given file is a valid LCOV report",
      () {
        when(inputFile.readAsStringSync()).thenReturn(validCoverageReport);

        final canConvert = converter.canConvert(inputFile, null);

        expect(canConvert, isTrue);
      },
    );

    test(
      ".canConvert() returns false if the given file is not valid LCOV report",
      () {
        when(inputFile.readAsStringSync()).thenReturn(invalidCoverageReport);

        final canConvert = converter.canConvert(inputFile, null);

        expect(canConvert, isFalse);
      },
    );

    test(
      ".convert() calculates the total line coverage",
      () {
        final expectedCoverage = CoverageData(
          percent: Percent(linesHit / linesFound),
        );

        when(inputFile.readAsStringSync()).thenReturn(validCoverageReport);

        final coverage = converter.convert(inputFile, null);

        expect(coverage, equals(expectedCoverage));
      },
    );

    test(
      ".convert() returns coverage with null percent if the given report does not contain any lines",
      () {
        const linesFound = 0;
        const linesHit = 0;
        final coverageReport = getValidReport(linesFound, linesHit);

        const expectedCoverage = CoverageData();

        when(inputFile.readAsStringSync()).thenReturn(coverageReport);

        final coverage = converter.convert(inputFile, null);

        expect(coverage, equals(expectedCoverage));
      },
    );
  });
}
