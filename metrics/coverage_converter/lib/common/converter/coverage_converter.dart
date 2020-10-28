import 'dart:async';
import 'dart:io';

import 'package:coverage_converter/common/arguments/model/coverage_converter_arguments.dart';
import 'package:metrics_core/metrics_core.dart';

/// An interface for all specific coverage format converters.
abstract class CoverageConverter<T extends CoverageConverterArguments> {
  /// Creates a new instance of the [CoverageConverter].
  const CoverageConverter();

  /// Converts the coverage report from the given [inputFile]
  /// to the [CoverageData].
  FutureOr<CoverageData> convert(File inputFile, T arguments);

  /// Indicates whether this converter can convert the coverage report
  /// from the given [inputFile].
  FutureOr<bool> canConvert(File inputFile, T arguments);
}
