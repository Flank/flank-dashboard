// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:coverage_converter/common/strings/common_strings.dart';
import 'package:equatable/equatable.dart';

import 'error_code/coverage_converter_error_code.dart';

/// A class that represents the coverage converter [Exception].
class CoverageConverterException extends Equatable implements Exception {
  /// A [CoverageConverterErrorCode] provides an information
  /// about concrete coverage converter exception.
  final CoverageConverterErrorCode _code;

  /// A [StackTrace] of this error.
  final StackTrace stackTrace;

  /// Creates the [CoverageConverterException]
  /// with the given [CoverageConverterErrorCode].
  const CoverageConverterException(
    this._code, {
    this.stackTrace,
  });

  @override
  List<Object> get props => [_code];

  /// Provides an error message based on the [CoverageConverterErrorCode].
  String get message {
    switch (_code) {
      case CoverageConverterErrorCode.noSuchFile:
        return CommonStrings.noSuchFile;
      case CoverageConverterErrorCode.fileIsEmpty:
        return CommonStrings.fileIsEmpty;
      case CoverageConverterErrorCode.invalidFileFormat:
        return CommonStrings.invalidFileFormat;
      default:
        return null;
    }
  }

  @override
  String toString() {
    if (stackTrace == null) return message;

    return "$message \n\n$stackTrace";
  }
}
