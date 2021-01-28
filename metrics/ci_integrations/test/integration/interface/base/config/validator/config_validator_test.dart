import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ConfigValidator", () {
    const configField = 'field';
    const additionalContext = 'context';

    final validationDelegate = _ValidationDelegateStub();
    final errorBuffer = StringBuffer();
    final configValidator = _ConfigValidatorFake(
      validationDelegate,
      errorBuffer,
    );

    tearDown(() {
      configValidator.reset();
    });

    test(
      "throws an ArgumentError if the given validation delegate is null",
      () {
        expect(
          () => _ConfigValidatorFake(null, errorBuffer),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given error buffer is null",
      () {
        expect(
          () => _ConfigValidatorFake(validationDelegate, null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given validation delegate and error buffer",
      () {
        final configValidator = _ConfigValidatorFake(
          validationDelegate,
          errorBuffer,
        );

        expect(configValidator.errorBuffer, equals(errorBuffer));
        expect(
          configValidator.validationDelegate,
          equals(validationDelegate),
        );
      },
    );

    test(
      ".addError() adds an error message to the error buffer",
      () {
        configValidator.addErrorMessage(configField, additionalContext);

        expect(errorBuffer, isNotEmpty);
      },
    );

    test(
      ".addError() adds an error message with the information about the config field to the error buffer",
      () {
        configValidator.addErrorMessage(configField, additionalContext);

        final message = errorBuffer.toString();

        expect(message, contains(configField));
      },
    );

    test(
      ".addError() does not add the additional context if the given one is null",
      () {
        configValidator.addErrorMessage(configField, null);

        final message = errorBuffer.toString();
        final containsAdditionalContext = message.contains(
          'Additional context',
        );

        expect(containsAdditionalContext, isFalse);
      },
    );

    test(
      ".addError() adds the additional context if the given one is not null",
      () {
        configValidator.addErrorMessage(configField, additionalContext);

        final message = errorBuffer.toString();

        expect(message, contains(additionalContext));
      },
    );
  });
}

/// A stub class for a [ValidationDelegate] abstract class providing
/// a test implementation.
class _ValidationDelegateStub implements ValidationDelegate {
  @override
  Future<InteractionResult> validateAuth(AuthorizationBase auth) {
    return Future.value();
  }
}

/// A fake implementation of a [ConfigValidator] abstract class that is used
/// for testing.
class _ConfigValidatorFake extends ConfigValidator {
  /// Creates a new instance of this fake class with the given
  /// [validationDelegate] and [errorBuffer].
  _ConfigValidatorFake(
    ValidationDelegate validationDelegate,
    StringBuffer errorBuffer,
  ) : super(validationDelegate, errorBuffer);

  @override
  Future<void> validate(Config config) async {}

  /// Resets this fake by clearing the [errorBuffer].
  void reset() {
    errorBuffer.clear();
  }
}
