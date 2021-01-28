import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';

/// An abstract class that provides methods for [Config] validation.
abstract class ConfigValidator<T extends Config> {
  /// A [ValidationDelegate] this validator uses for [Config]'s
  /// specific fields validation.
  final ValidationDelegate validationDelegate;

  /// A [StringBuffer] that this validator uses to accumulate error messages.
  final StringBuffer errorBuffer;

  /// Creates a new instance of the [ConfigValidator] with the
  /// given [validationDelegate] and [errorBuffer].
  ///
  /// Throws an [ArgumentError] if any of the parameters is `null`.
  ConfigValidator(this.validationDelegate, this.errorBuffer) {
    ArgumentError.checkNotNull(validationDelegate);
    ArgumentError.checkNotNull(errorBuffer);
  }

  /// Validates the given [config].
  Future<void> validate(T config);

  /// Generates an error message from the given [configField]
  /// and [additionalContext] and adds it to the [errorBuffer].
  void addErrorMessage(String configField, [String additionalContext]) {
    final errorMessage = _generateErrorMessage(configField, additionalContext);

    errorBuffer.write(errorMessage);
  }

  /// Generates an error message from the given [configField]
  /// and [additionalContext].
  ///
  /// Does not add the [additionalContext] if it is `null`.
  String _generateErrorMessage(String configField, [String additionalContext]) {
    String message =
        'A validation error occurred while validating $T.\nThe following field(s) may be incorrect: $configField.';

    if (additionalContext != null) {
      message += '\nAdditional context: $additionalContext';
    }

    return message;
  }
}
