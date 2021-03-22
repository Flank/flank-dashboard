// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/models/firebase_auth_credentials.dart';
import 'package:ci_integration/destination/firestore/config/validation_delegate/firestore_destination_validation_delegate.dart';
import 'package:ci_integration/destination/firestore/factory/firebase_auth_factory.dart';
import 'package:ci_integration/destination/firestore/strings/firestore_strings.dart';
import 'package:firedart/firedart.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';
import '../../test_utils/mock/firebase_auth_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("FirestoreDestinationValidationDelegate", () {
    const apiKey = 'key';
    const email = 'stub@email.com';
    const password = 'stub_password';
    const message = 'message';

    const invalidApiKeyAuthException = FirebaseAuthException(
      FirebaseAuthExceptionCode.invalidApiKey,
      message,
    );
    const emailNotFoundAuthException = FirebaseAuthException(
      FirebaseAuthExceptionCode.emailNotFound,
      message,
    );
    const invalidPasswordAuthException = FirebaseAuthException(
      FirebaseAuthExceptionCode.invalidPassword,
      message,
    );
    const passwordLoginDisabledAuthException = FirebaseAuthException(
      FirebaseAuthExceptionCode.passwordLoginDisabled,
      message,
    );
    const userDisabledAuthException = FirebaseAuthException(
      FirebaseAuthExceptionCode.userDisabled,
      message,
    );

    final credentials = FirebaseAuthCredentials(
      apiKey: apiKey,
      email: email,
      password: password,
    );

    final user = User.fromMap(const {});

    final authFactory = _FirebaseAuthFactoryMock();
    final firebaseAuth = FirebaseAuthMock();

    final delegate = FirestoreDestinationValidationDelegate(authFactory);

    PostExpectation<FirebaseAuth> whenCreateFirebaseAuth() {
      return when(authFactory.create(apiKey));
    }

    PostExpectation<Future<User>> whenSignIn({
      String withEmail = email,
      String withPassword = password,
    }) {
      whenCreateFirebaseAuth().thenReturn(firebaseAuth);

      return when(firebaseAuth.signIn(withEmail, withPassword));
    }

    tearDown(() {
      reset(authFactory);
      reset(firebaseAuth);
    });

    test(
      "throws an ArgumentError if the given auth factory is null",
      () {
        expect(
          () => FirestoreDestinationValidationDelegate(null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final validationDelegate = FirestoreDestinationValidationDelegate(
          authFactory,
        );

        expect(validationDelegate.authFactory, equals(authFactory));
      },
    );

    test(
      ".validatePublicApiKey() creates a firebase auth using the firebase auth factory",
      () {
        whenCreateFirebaseAuth().thenReturn(firebaseAuth);

        delegate.validatePublicApiKey(apiKey);

        verify(authFactory.create(apiKey)).called(once);
      },
    );

    test(
      ".validatePublicApiKey() signs in using the created firebase auth",
      () {
        whenCreateFirebaseAuth().thenReturn(firebaseAuth);

        delegate.validatePublicApiKey(apiKey);

        verify(firebaseAuth.signIn(any, any)).called(once);
      },
    );

    test(
      ".validatePublicApiKey() returns a failure field validation result if the auth throws a firebase auth exception with the 'invalid api key' code",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validatePublicApiKey(apiKey);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validatePublicApiKey() returns a result with the 'api key invalid' additional context if the auth throws a firebase auth exception with the 'invalid api key' code",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validatePublicApiKey(apiKey);

        expect(
          result.additionalContext,
          equals(FirestoreStrings.apiKeyInvalid),
        );
      },
    );

    test(
      ".validatePublicApiKey() returns a successful field validation result if the auth throws a firebase auth exception with the code does not indicate that the api key is invalid",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer((_) => Future.error(emailNotFoundAuthException));

        final result = await delegate.validatePublicApiKey(apiKey);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validatePublicApiKey() returns a successful field validation result if the sign-in process finishes successfully",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer((_) => Future.value(user));

        final result = await delegate.validatePublicApiKey(apiKey);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateAuth() creates a firebase auth with the firebase auth factory",
      () {
        whenCreateFirebaseAuth().thenReturn(firebaseAuth);

        delegate.validateAuth(credentials);

        verify(authFactory.create(apiKey)).called(once);
      },
    );

    test(
      ".validateAuth() signs in using the created firebase auth and the given credentials",
      () {
        final expectedEmail = credentials.email;
        final expectedPassword = credentials.password;
        whenCreateFirebaseAuth().thenReturn(firebaseAuth);

        delegate.validateAuth(credentials);

        verify(
          firebaseAuth.signIn(expectedEmail, expectedPassword),
        ).called(once);
      },
    );

    test(
      ".validateAuth() returns a failure field validation result if the auth throws a firebase auth exception with the 'email not found' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result containing the exception message if the auth throws a firebase auth exception with the 'email not found' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.additionalContext, equals(message));
      },
    );

    test(
      ".validateAuth() returns a failure field validation result if the auth throws a firebase auth exception with the 'invalid password' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidPasswordAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result containing the exception message if the auth throws a firebase auth exception with the 'invalid password' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidPasswordAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.additionalContext, equals(message));
      },
    );

    test(
      ".validateAuth() returns a failure field validation result if the auth throws a firebase auth exception with the 'password login disabled' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(passwordLoginDisabledAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result containing the exception message if the auth throws a firebase auth exception with the 'password login disabled' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(passwordLoginDisabledAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.additionalContext, equals(message));
      },
    );

    test(
      ".validateAuth() returns a failure field validation result if the auth throws a firebase auth exception with the 'user disabled' code",
      () async {
        whenSignIn().thenAnswer((_) => Future.error(userDisabledAuthException));

        final result = await delegate.validateAuth(credentials);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result containing the exception message if the auth throws a firebase auth exception with the 'user disabled' code",
      () async {
        whenSignIn().thenAnswer((_) => Future.error(userDisabledAuthException));

        final result = await delegate.validateAuth(credentials);

        expect(result.additionalContext, equals(message));
      },
    );

    test(
      ".validateAuth() returns an unknown field validation result if the auth throws a firebase auth exception with the code does not indicate that the auth is invalid",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.isUnknown, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'auth validation failed' additional context containing the exception code and message if the auth throws a firebase auth exception with the code does not indicate that the auth is invalid",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );
        final expectedAdditionalContext =
            FirestoreStrings.authValidationFailedMessage(
          '${invalidApiKeyAuthException.code}',
          invalidApiKeyAuthException.message,
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.additionalContext, equals(expectedAdditionalContext));
      },
    );

    test(
      ".validateAuth() returns a successful field validation result if the sign-in process finishes successfully",
      () async {
        whenSignIn().thenAnswer((_) => Future.value(user));

        final result = await delegate.validateAuth(credentials);

        expect(result.isSuccess, isTrue);
      },
    );
  });
}

class _FirebaseAuthFactoryMock extends Mock implements FirebaseAuthFactory {}
