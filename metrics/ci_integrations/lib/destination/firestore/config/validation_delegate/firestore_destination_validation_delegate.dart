// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/firestore.dart' as fs;
import 'package:ci_integration/client/firestore/mappers/firestore_exception_reason_mapper.dart';
import 'package:ci_integration/client/firestore/models/firebase_auth_credentials.dart';
import 'package:ci_integration/client/firestore/models/firestore_exception_reason.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_validation_target.dart';
import 'package:ci_integration/destination/firestore/factory/firebase_auth_factory.dart';
import 'package:ci_integration/destination/firestore/factory/firestore_factory.dart';
import 'package:ci_integration/destination/firestore/strings/firestore_strings.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:firedart/firedart.dart';
import 'package:metrics_core/metrics_core.dart';

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

  /// A [List] of [FirestoreExceptionReason]s of [FirestoreException]s thrown
  /// when the given Firebase project identifier is not valid.
  static const List<FirestoreExceptionReason>
      _invalidFirebaseProjectIdExceptionReasons = [
    FirestoreExceptionReason.consumerInvalid,
    FirestoreExceptionReason.notFound,
    FirestoreExceptionReason.projectDeleted,
    FirestoreExceptionReason.projectInvalid,
  ];

  /// A [FirestoreExceptionReasonMapper] this delegate uses for mapping the
  /// [FirestoreExceptionReason]s.
  static const FirestoreExceptionReasonMapper reasonMapper =
      FirestoreExceptionReasonMapper();

  /// A [FirebaseAuthFactory] this delegate uses to create [FirebaseAuth]
  /// instances.
  final FirebaseAuthFactory authFactory;

  /// A [FirebaseAuthFactory] this delegate uses to create [Firestore]
  /// instances.
  final FirestoreFactory firestoreFactory;

  /// Creates a new instance of the [FirestoreDestinationValidationDelegate]
  /// with the given [authFactory] and [firestoreFactory].
  ///
  /// Throws an [ArgumentError] if the given [authFactory] or [firestoreFactory]
  /// is `null`.
  FirestoreDestinationValidationDelegate(
    this.authFactory,
    this.firestoreFactory,
  ) {
    ArgumentError.checkNotNull(authFactory, 'authFactory');
    ArgumentError.checkNotNull(firestoreFactory, 'firestoreFactory');
  }

  /// Validates the given [firebaseApiKey].
  Future<TargetValidationResult> validatePublicApiKey(
    String firebaseApiKey,
  ) async {
    try {
      final auth = authFactory.create(firebaseApiKey);

      await auth.signIn('', '');
    } on FirebaseAuthException catch (e) {
      final exceptionCode = e.code;

      if (exceptionCode == FirebaseAuthExceptionCode.invalidApiKey) {
        return const TargetValidationResult(
          target: FirestoreDestinationValidationTarget.firebasePublicApiKey,
          conclusion: ConfigFieldValidationConclusion.invalid,
          description: FirestoreStrings.apiKeyInvalid,
        );
      }
    }

    return const TargetValidationResult(
      target: FirestoreDestinationValidationTarget.firebasePublicApiKey,
      conclusion: ConfigFieldValidationConclusion.valid,
    );
  }

  /// Validates the given Firebase authentication [credentials].
  Future<TargetValidationResult> validateAuth(
    FirebaseAuthCredentials credentials,
  ) async {
    try {
      await _authenticate(credentials);
    } on FirebaseAuthException catch (e) {
      final exceptionCode = e.code;

      if (_invalidAuthExceptionCodes.contains(exceptionCode)) {
        final message = e.message;

        return TargetValidationResult(
          target: FirestoreDestinationValidationTarget.firebaseUserEmail,
          conclusion: ConfigFieldValidationConclusion.invalid,
          description: message,
        );
      }

      return TargetValidationResult(
        target: FirestoreDestinationValidationTarget.firebaseUserEmail,
        conclusion: ConfigFieldValidationConclusion.unknown,
        description: FirestoreStrings.authValidationFailed(
          '${e.code}',
          e.message,
        ),
      );
    }

    return const TargetValidationResult(
      target: FirestoreDestinationValidationTarget.firebaseUserEmail,
      conclusion: ConfigFieldValidationConclusion.valid,
    );
  }

  /// Validates the given [firebaseProjectId].
  Future<TargetValidationResult> validateFirebaseProjectId(
    FirebaseAuthCredentials credentials,
    String firebaseProjectId,
  ) async {
    try {
      final firestore = await _createFirestore(
        credentials,
        firebaseProjectId,
      );

      await firestore.collection('projects').document('id').get();
    } on FirestoreException catch (e) {
      final reasons = e.reasons ?? [];

      final exceptionReasons = reasons
          ?.map((reason) => reasonMapper.map(reason))
          ?.where((reason) => reason != null);

      final isProjectIdInvalid = exceptionReasons.any(
        (reason) => _invalidFirebaseProjectIdExceptionReasons.contains(reason),
      );

      if (isProjectIdInvalid) {
        return const TargetValidationResult(
          target: FirestoreDestinationValidationTarget.firebaseProjectId,
          conclusion: ConfigFieldValidationConclusion.invalid,
          description: FirestoreStrings.projectIdInvalid,
        );
      }
    } on FirebaseAuthException {
      return const TargetValidationResult(
        target: FirestoreDestinationValidationTarget.firebaseProjectId,
        conclusion: ConfigFieldValidationConclusion.unknown,
        description: FirestoreStrings.unknownErrorWhenSigningIn,
      );
    }

    return const TargetValidationResult(
      target: FirestoreDestinationValidationTarget.firebaseProjectId,
      conclusion: ConfigFieldValidationConclusion.valid,
    );
  }

  /// Validates the given [metricsProjectId].
  Future<TargetValidationResult> validateMetricsProjectId(
    FirebaseAuthCredentials credentials,
    String firebaseProjectId,
    String metricsProjectId,
  ) async {
    try {
      final firestore = await _createFirestore(
        credentials,
        firebaseProjectId,
      );

      final metricsProject = await firestore
          .collection('projects')
          .document(metricsProjectId)
          .get();

      if (!metricsProject.exists) {
        return const TargetValidationResult(
          target: FirestoreDestinationValidationTarget.metricsProjectId,
          conclusion: ConfigFieldValidationConclusion.invalid,
          description: FirestoreStrings.metricsProjectIdDoesNotExist,
        );
      }
    } on FirestoreException catch (e) {
      return TargetValidationResult(
        target: FirestoreDestinationValidationTarget.metricsProjectId,
        conclusion: ConfigFieldValidationConclusion.unknown,
        description: FirestoreStrings.metricsProjectIdValidationFailed(
          '${e.code}',
          e.message,
        ),
      );
    } on FirebaseAuthException {
      return const TargetValidationResult(
        target: FirestoreDestinationValidationTarget.metricsProjectId,
        conclusion: ConfigFieldValidationConclusion.unknown,
        description: FirestoreStrings.unknownErrorWhenSigningIn,
      );
    }

    return const TargetValidationResult(
      target: FirestoreDestinationValidationTarget.metricsProjectId,
      conclusion: ConfigFieldValidationConclusion.valid,
    );
  }

  /// Creates a new authenticated [FirebaseAuth] using the given [credentials].
  Future<FirebaseAuth> _authenticate(
    FirebaseAuthCredentials credentials,
  ) async {
    final auth = authFactory.create(credentials.apiKey);

    await auth.signIn(credentials.email, credentials.password);

    return auth;
  }

  /// Creates a new authenticated [Firestore] instance using the given
  /// [credentials] and the [firebaseProjectId].
  Future<fs.Firestore> _createFirestore(
    FirebaseAuthCredentials credentials,
    String firebaseProjectId,
  ) async {
    final auth = await _authenticate(credentials);

    return firestoreFactory.create(firebaseProjectId, auth);
  }
}
