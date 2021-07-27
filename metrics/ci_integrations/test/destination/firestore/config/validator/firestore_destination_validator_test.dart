// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/models/firebase_auth_credentials.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config_field.dart';
import 'package:ci_integration/destination/firestore/config/validation_delegate/firestore_destination_validation_delegate.dart';
import 'package:ci_integration/destination/firestore/config/validator/firestore_destination_validator.dart';
import 'package:ci_integration/destination/firestore/strings/firestore_strings.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';
import '../../../../test_utils/mock/validation_result_builder_mock.dart';

void main() {
  group("FirestoreDestinationValidator", () {
    const firebaseApiKey = 'key';
    const firebaseUserEmail = 'email';
    const firebaseUserPassword = 'password';
    const firebaseProjectId = 'id';
    const metricsProjectId = 'metrics_id';
    const successResult = FieldValidationResult.success();
    const failureResult = FieldValidationResult.failure();
    const unknownResult = FieldValidationResult.unknown();

    final config = FirestoreDestinationConfig(
      firebaseProjectId: firebaseProjectId,
      firebaseUserEmail: firebaseUserEmail,
      firebaseUserPassword: firebaseUserPassword,
      firebasePublicApiKey: firebaseApiKey,
      metricsProjectId: metricsProjectId,
    );

    final firebaseAuthCredentials = FirebaseAuthCredentials(
      apiKey: firebaseApiKey,
      email: firebaseUserEmail,
      password: firebaseUserPassword,
    );

    final validationResult = ValidationResult(const {});

    final validationDelegate = _FirestoreDestinationValidationDelegateMock();
    final validationResultBuilder = ValidationResultBuilderMock();

    final validator = FirestoreDestinationValidator(
      validationDelegate,
      validationResultBuilder,
    );

    PostExpectation<Future<FieldValidationResult>> whenValidatePublicApiKey() {
      return when(validationDelegate.validatePublicApiKey(firebaseApiKey));
    }

    PostExpectation<Future<FieldValidationResult>> whenValidateAuth() {
      whenValidatePublicApiKey().thenAnswer(
        (_) => Future.value(successResult),
      );

      return when(validationDelegate.validateAuth(firebaseAuthCredentials));
    }

    PostExpectation<Future<FieldValidationResult>>
        whenValidateFirebaseProjectId() {
      whenValidateAuth().thenAnswer((_) => Future.value(successResult));

      return when(validationDelegate.validateFirebaseProjectId(
        firebaseAuthCredentials,
        firebaseProjectId,
      ));
    }

    PostExpectation<Future<FieldValidationResult>>
        whenValidateMetricsProjectId() {
      whenValidateFirebaseProjectId().thenAnswer(
        (_) => Future.value(successResult),
      );

      return when(validationDelegate.validateMetricsProjectId(
        firebaseAuthCredentials,
        firebaseProjectId,
        metricsProjectId,
      ));
    }

    tearDown(() {
      reset(validationDelegate);
      reset(validationResultBuilder);
    });

    test(
      "throws an ArgumentError if the given validation delegate is null",
      () {
        expect(
          () => FirestoreDestinationValidator(null, validationResultBuilder),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given validation result builder is null",
      () {
        expect(
          () => FirestoreDestinationValidator(validationDelegate, null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates a new instance with the given parameters",
      () {
        final validator = FirestoreDestinationValidator(
          validationDelegate,
          validationResultBuilder,
        );

        expect(validator.validationDelegate, equals(validationDelegate));
        expect(
          validator.validationResultBuilder,
          equals(validationResultBuilder),
        );
      },
    );

    test(
      ".validate() delegates the public api key validation to the validation delegate",
      () async {
        whenValidatePublicApiKey().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validatePublicApiKey(firebaseApiKey),
        ).called(once);
      },
    );

    test(
      ".validate() sets the public api key validation result returned by the validation delegate",
      () async {
        whenValidatePublicApiKey().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(validationResultBuilder.setResult(
          FirestoreDestinationConfigField.firebasePublicApiKey,
          failureResult,
        )).called(once);
      },
    );

    test(
      ".validate() sets empty result with the unknown field validation result with the 'firebase public api key invalid' additional context if the public api key validation result is failure",
      () async {
        const expectedResult = FieldValidationResult.unknown(
          additionalContext:
              FirestoreStrings.publicApiKeyInvalidInterruptReason,
        );
        whenValidatePublicApiKey().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the auth if the public api key validation result is failure",
      () async {
        whenValidatePublicApiKey().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateAuth(any));
      },
    );

    test(
      ".validate() does not validate the firebase project id if the public api key validation result is failure",
      () async {
        whenValidatePublicApiKey().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateFirebaseProjectId(any, any));
      },
    );

    test(
      ".validate() does not validate the metrics project id if the public api key validation result is failure",
      () async {
        whenValidatePublicApiKey().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateMetricsProjectId(any, any, any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the public api key validation result is failure",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidatePublicApiKey().thenAnswer(
          (_) => Future.value(failureResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates the auth validation to the validation delegate",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateAuth(firebaseAuthCredentials),
        ).called(once);
      },
    );

    test(
      ".validate() sets the firebase user email field validation result returned by the validation delegate",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(validationResultBuilder.setResult(
          FirestoreDestinationConfigField.firebaseUserEmail,
          failureResult,
        )).called(once);
      },
    );

    test(
      ".validate() sets the firebase user password field validation result returned by the validation delegate",
      () async {
        whenValidateAuth().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(validationResultBuilder.setResult(
          FirestoreDestinationConfigField.firebaseUserPassword,
          failureResult,
        )).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'auth invalid' additional context if the auth validation result is failure",
      () async {
        const expectedResult = FieldValidationResult.unknown(
          additionalContext: FirestoreStrings.authInvalidInterruptReason,
        );
        whenValidateAuth().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'auth validation failed' additional context if the auth validation result is unknown",
      () async {
        const expectedResult = FieldValidationResult.unknown(
          additionalContext:
              FirestoreStrings.authValidationFailedInterruptReason,
        );
        whenValidateAuth().thenAnswer((_) => Future.value(unknownResult));

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the firebase project id if the auth validation result is failure",
      () async {
        whenValidateAuth().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verifyNever(validationDelegate.validateFirebaseProjectId(any, any));
      },
    );

    test(
      ".validate() does not validate the metrics project id if the auth validation result is failure",
      () async {
        whenValidateAuth().thenAnswer((_) => Future.value(failureResult));

        await validator.validate(config);

        verifyNever(validationDelegate.validateMetricsProjectId(any, any, any));
      },
    );

    test(
      ".validate() does not validate the firebase project id if the auth validation result is unknown",
      () async {
        whenValidateAuth().thenAnswer((_) => Future.value(unknownResult));

        await validator.validate(config);

        verifyNever(validationDelegate.validateFirebaseProjectId(any, any));
      },
    );

    test(
      ".validate() does not validate the metrics project id if the auth validation result is unknown",
      () async {
        whenValidateAuth().thenAnswer((_) => Future.value(unknownResult));

        await validator.validate(config);

        verifyNever(validationDelegate.validateMetricsProjectId(any, any, any));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the auth validation result is failure",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateAuth().thenAnswer((_) => Future.value(failureResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() returns a validation result built by the validation result builder if the auth validation result is unknown",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateAuth().thenAnswer((_) => Future.value(unknownResult));

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates firebase project id validation to the validation delegate",
      () async {
        whenValidateFirebaseProjectId().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(
          validationDelegate.validateFirebaseProjectId(
            firebaseAuthCredentials,
            firebaseProjectId,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets the firebase project id field validation result returned by the validation delegate",
      () async {
        whenValidateFirebaseProjectId().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setResult(
            FirestoreDestinationConfigField.firebaseProjectId,
            failureResult,
          ),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'firebase project id validation failed' additional context if the firebase project id validation result is failure",
      () async {
        const expectedResult = FieldValidationResult.unknown(
          additionalContext:
              FirestoreStrings.firebaseProjectIdInvalidInterruptReason,
        );
        whenValidateFirebaseProjectId().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() sets empty results with the unknown field validation result with the 'firebase project id validation failed' additional context if the firebase project id validation result is unknown",
      () async {
        const expectedResult = FieldValidationResult.unknown(
          additionalContext:
              FirestoreStrings.firebaseProjectIdValidationFailedInterruptReason,
        );
        whenValidateFirebaseProjectId().thenAnswer(
          (_) => Future.value(unknownResult),
        );

        await validator.validate(config);

        verify(
          validationResultBuilder.setEmptyResults(expectedResult),
        ).called(once);
      },
    );

    test(
      ".validate() does not validate the metrics project id if the firebase project id validation result is failure",
      () async {
        whenValidateFirebaseProjectId().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateMetricsProjectId(any, any, any));
      },
    );

    test(
      ".validate() does not validate the metrics project id if the firebase project id validation result is unknown",
      () async {
        whenValidateFirebaseProjectId().thenAnswer(
          (_) => Future.value(unknownResult),
        );

        await validator.validate(config);

        verifyNever(validationDelegate.validateMetricsProjectId(any, any, any));
      },
    );

    test(
      ".validate() returns the validation result built by the validation result builder if the firebase project id validation result is failure",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateFirebaseProjectId().thenAnswer(
          (_) => Future.value(failureResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() returns the validation result built by the validation result builder if the firebase project id validation result is unknown",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateFirebaseProjectId().thenAnswer(
          (_) => Future.value(unknownResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() delegates metrics project id validation to the validation delegate",
      () async {
        whenValidateMetricsProjectId().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(validationDelegate.validateMetricsProjectId(
          firebaseAuthCredentials,
          firebaseProjectId,
          metricsProjectId,
        )).called(once);
      },
    );

    test(
      ".validate() sets the metrics project id field validation result returned by the validation delegate",
      () async {
        whenValidateMetricsProjectId().thenAnswer(
          (_) => Future.value(failureResult),
        );

        await validator.validate(config);

        verify(validationResultBuilder.setResult(
          FirestoreDestinationConfigField.metricsProjectId,
          failureResult,
        )).called(once);
      },
    );

    test(
      ".validate() returns the validation result built by the validation result builder if the metrics project id validation result is failure",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateMetricsProjectId().thenAnswer(
          (_) => Future.value(failureResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() returns the validation result built by the validation result builder if the metrics project id validation result is unknown",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateMetricsProjectId().thenAnswer(
          (_) => Future.value(failureResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );

    test(
      ".validate() returns the validation result built by the validation result builder if the config is valid",
      () async {
        when(validationResultBuilder.build()).thenReturn(validationResult);
        whenValidateMetricsProjectId().thenAnswer(
          (_) => Future.value(successResult),
        );

        final result = await validator.validate(config);

        expect(result, equals(validationResult));
      },
    );
  });
}

class _FirestoreDestinationValidationDelegateMock extends Mock
    implements FirestoreDestinationValidationDelegate {}
