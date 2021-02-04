// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:coverage_converter/common/arguments/model/coverage_converter_arguments.dart';
import 'package:coverage_converter/common/converter/coverage_converter.dart';
import 'package:coverage_converter/common/exception/coverage_converter_exception.dart';
import 'package:coverage_converter/common/exception/error_code/coverage_converter_error_code.dart';
import 'package:lcov/lcov.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [CoverageConverter] used to convert the LCOV coverage reports.
class LcovCoverageConverter
    implements CoverageConverter<CoverageConverterArguments, Report> {
  @override
  Report parse(File inputFile) {
    final coverage = inputFile?.readAsStringSync() ?? '';

    try {
      return Report.fromCoverage(coverage);
    } catch (_, stackTrace) {
      throw CoverageConverterException(
        CoverageConverterErrorCode.invalidFileFormat,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  CoverageData convert(Report coverage, CoverageConverterArguments arguments) {
    int foundLines = 0;
    int hitLines = 0;

    for (final record in coverage.records) {
      final lines = record.lines;

      foundLines += lines.found;
      hitLines += lines.hit;
    }

    if (foundLines == 0) return const CoverageData();

    final coveragePercent = hitLines / foundLines;

    return CoverageData(percent: Percent(coveragePercent));
  }
}
