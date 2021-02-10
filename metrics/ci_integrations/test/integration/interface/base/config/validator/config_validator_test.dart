// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/builder/validation_result_builder.dart';
import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/model/validation_result.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ConfigValidator", () {
    final validationDelegate = _ValidationDelegateStub();
    final validationResultBuilder = _ValidationResultBuilderStub();

    test(
      "throws an ArgumentError if the given validation delegate is null",
      () {
        expect(
          () => _ConfigValidatorFake(null, validationResultBuilder),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given validation result builder is null",
      () {
        expect(
          () => _ConfigValidatorFake(validationDelegate, null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final configValidator = _ConfigValidatorFake(
          validationDelegate,
          validationResultBuilder,
        );

        expect(
          configValidator.validationDelegate,
          equals(validationDelegate),
        );
        expect(
          configValidator.validationResultBuilder,
          equals(validationResultBuilder),
        );
      },
    );
  });
}

/// A stub implementation of a [ValidationDelegate] abstract class providing
/// a test implementation.
class _ValidationDelegateStub implements ValidationDelegate {
  @override
  Future<InteractionResult> validateAuth(AuthorizationBase auth) {
    return Future.value();
  }
}

/// A stub implementation of a [ValidationResultBuilder] abstract class
/// providing a test implementation.
class _ValidationResultBuilderStub extends ValidationResultBuilder {
  @override
  ValidationResult build() => null;
}

/// A fake implementation of a [ConfigValidator] abstract class that is used
/// to test non-abstract methods.
class _ConfigValidatorFake extends ConfigValidator {
  /// Creates a new instance of this fake class with the given
  /// [validationDelegate].
  _ConfigValidatorFake(
    ValidationDelegate validationDelegate,
    ValidationResultBuilder validationResultBuilder,
  ) : super(validationDelegate, validationResultBuilder);

  @override
  Future<void> validate(Config config) async {}
}
