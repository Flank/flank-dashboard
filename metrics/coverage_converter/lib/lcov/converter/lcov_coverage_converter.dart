import 'dart:io';

import 'package:coverage_converter/common/arguments/model/coverage_converter_arguments.dart';
import 'package:coverage_converter/common/converter/coverage_converter.dart';
import 'package:lcov/lcov.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [CoverageConverter] used to convert the LCOV coverage reports.
class LcovCoverageConverter implements CoverageConverter {
  @override
  bool canConvert(File inputFile, CoverageConverterArguments arguments) {
    if (inputFile == null) return false;

    final coverage = inputFile.readAsStringSync();

    try {
      Report.fromCoverage(coverage);
      return true;
    } on LcovException {
      return false;
    }
  }

  @override
  CoverageData convert(File inputFile, CoverageConverterArguments arguments) {
    final coverage = inputFile.readAsStringSync();
    final report = Report.fromCoverage(coverage);

    int foundLines = 0;
    int hitLines = 0;

    for (final record in report.records) {
      final lines = record.lines;

      foundLines += lines.found;
      hitLines += lines.hit;
    }

    if (foundLines == 0) return const CoverageData();

    final coveragePercent = hitLines / foundLines;

    return CoverageData(percent: Percent(coveragePercent));
  }
}
