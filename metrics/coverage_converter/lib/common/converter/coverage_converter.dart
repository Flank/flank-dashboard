// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:coverage_converter/common/arguments/model/coverage_converter_arguments.dart';
import 'package:coverage_converter/common/exception/coverage_converter_exception.dart';
import 'package:metrics_core/metrics_core.dart';

/// An interface for all specific coverage format converters.
abstract class CoverageConverter<T extends CoverageConverterArguments, R> {
  /// Creates a new instance of the [CoverageConverter].
  const CoverageConverter();

  /// Parses the contents of the [inputFile] to the [R] instance.
  ///
  /// If the [inputFile] is null, or has an invalid coverage
  /// report throws a [CoverageConverterException].
  FutureOr<R> parse(File inputFile);

  /// Converts the given [coverage] report to the [CoverageData].
  FutureOr<CoverageData> convert(R coverage, T arguments);
}
