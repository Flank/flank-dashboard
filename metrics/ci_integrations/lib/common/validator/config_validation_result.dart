import 'package:ci_integration/common/config/ci_config.dart';

/// A class containing the result of [CiConfig] validation.
class ConfigValidationResult {
  /// Used to indicate that [CiConfig] is valid.
  final bool _isValid;

  /// Contains a message with a result of validation.
  final String message;

  /// Indicates if the validation has finished successfully.
  bool get isValid => _isValid;

  /// Indicates if the validation has finished with an error.
  bool get isInvalid => !_isValid;

  const ConfigValidationResult._(this._isValid, this.message);

  /// Creates an instance representing a result of validating valid [CiConfig]
  /// instance.
  const ConfigValidationResult.valid({String message}) : this._(true, message);

  /// Creates an instance representing a result of validating invalid [CiConfig]
  /// instance.
  const ConfigValidationResult.invalid({String message})
      : this._(false, message);
}
