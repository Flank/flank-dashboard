import 'coverage_converter_error_strings.dart';
import 'error_code/coverage_converter_error_code.dart';

/// A class that provides the coverage converter error description, based on [CoverageConverterErrorCode].
class CoverageConverterException {
  /// An [CoverageConverterErrorCode] provides an information about
  /// concrete coverage converter exception.
  final CoverageConverterErrorCode _code;

  /// Creates the [CoverageConverterException] from the given [CoverageConverterErrorCode].
  const CoverageConverterException(this._code);

  /// Provides an coverage converter error message based on the [CoverageConverterErrorCode].
  String get message {
    switch (_code) {
      case CoverageConverterErrorCode.noSuchFile:
        return CoverageConverterErrorStrings.noSuchFile;
      case CoverageConverterErrorCode.fileIsEmpty:
        return CoverageConverterErrorStrings.fileIsEmpty;
      case CoverageConverterErrorCode.invalidFileFormat:
        return CoverageConverterErrorStrings.invalidFileFormat;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return message;
  }
}
