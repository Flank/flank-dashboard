// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/models/firebase_auth_credentials.dart';
import 'package:ci_integration/destination/firestore/factory/firebase_auth_factory.dart';
import 'package:ci_integration/destination/firestore/strings/firestore_strings.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:firedart/firedart.dart';

/// A [ValidationDelegate] for the Firestore destination integration.
class FirestoreDestinationValidationDelegate implements ValidationDelegate {
  /// A [List] of [FirebaseAuthExceptionCode]s of [FirebaseAuthException]s
  /// thrown when the given authentication credentials are not valid.
  static const List<FirebaseAuthExceptionCode> _invalidAuthExceptionCodes = [
    FirebaseAuthExceptionCode.emailNotFound,
    FirebaseAuthExceptionCode.invalidPassword,
    FirebaseAuthExceptionCode.passwordLoginDisabled,
    FirebaseAuthExceptionCode.userDisabled,
  ];

  /// A [FirebaseAuthFactory] this delegate uses to create [FirebaseAuth]
  /// instances.
  final FirebaseAuthFactory authFactory;

  /// Creates a new instance of the [FirestoreDestinationValidationDelegate]
  /// with the given [authFactory].
  ///
  /// Throws an [ArgumentError] if the given [authFactory] is `null`.
  FirestoreDestinationValidationDelegate(
    this.authFactory,
  ) {
    ArgumentError.checkNotNull(authFactory, 'authFactory');
  }

  /// Validates the given [firebaseApiKey].
  Future<FieldValidationResult> validatePublicApiKey(
    String firebaseApiKey,
  ) async {
    try {
      final auth = authFactory.create(firebaseApiKey);

      await auth.signIn('', '');
    } on FirebaseAuthException catch (e) {
      final exceptionCode = e.code;

      if (exceptionCode == FirebaseAuthExceptionCode.invalidApiKey) {
        return const FieldValidationResult.failure(
          additionalContext: FirestoreStrings.apiKeyInvalid,
        );
      }
    }

    return const FieldValidationResult.success();
  }

  /// Validates the given Firebase authentication [credentials].
  Future<FieldValidationResult> validateAuth(
    FirebaseAuthCredentials credentials,
  ) async {
    try {
      await _authenticate(credentials);
    } on FirebaseAuthException catch (e) {
      final exceptionCode = e.code;

      if (_invalidAuthExceptionCodes.contains(exceptionCode)) {
        final message = e.message;

        return FieldValidationResult.failure(additionalContext: message);
      }

      return FieldValidationResult.unknown(
        additionalContext: FirestoreStrings.authValidationFailedMessage(
          '${e.code}',
          e.message,
        ),
      );
    }

    return const FieldValidationResult.success();
  }

  /// Creates a new authenticated [FirebaseAuth] using the given [credentials].
  Future<FirebaseAuth> _authenticate(
      FirebaseAuthCredentials credentials) async {
    final auth = authFactory.create(credentials.apiKey);

    await auth.signIn(credentials.email, credentials.password);

    return auth;
  }
}
