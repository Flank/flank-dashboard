// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/models/firebase_auth_credentials.dart';
import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:equatable/equatable.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class representing the [TargetValidationResult]s of a [FirebaseAuthCredentials].
class FirestoreDestinationAuthValidationResult extends Equatable {
  /// A [TargetValidationResult] of the [FirebaseAuthCredentials.apiKey]
  /// validation.
  final TargetValidationResult apiKeyValidationResult;

  /// A [TargetValidationResult] of the [FirebaseAuthCredentials.email]
  /// validation.
  final TargetValidationResult emailValidationResult;

  /// A [TargetValidationResult] of the [FirebaseAuthCredentials.password]
  /// validation.
  final TargetValidationResult passwordValidationResult;

  @override
  List<Object> get props => [
        apiKeyValidationResult,
        emailValidationResult,
        passwordValidationResult,
      ];

  /// Creates a new instance of the [FirestoreDestinationAuthValidationResult] with
  /// the given [apiKeyValidationResult], [emailValidationResult]
  /// and [passwordValidationResult].
  ///
  /// Throws an [ArgumentError] if the given [apiKeyValidationResult] is `null`.
  /// Throws an [ArgumentError] if the given [emailValidationResult] is `null`.
  /// Throws an [ArgumentError] if the given [passwordValidationResult] is `null`.
  FirestoreDestinationAuthValidationResult({
    this.apiKeyValidationResult,
    this.emailValidationResult,
    this.passwordValidationResult,
  }) {
    ArgumentError.checkNotNull(
      apiKeyValidationResult,
      'apiKeyValidationResult',
    );
    ArgumentError.checkNotNull(emailValidationResult, 'emailValidationResult');
    ArgumentError.checkNotNull(
      passwordValidationResult,
      'passwordValidationResult',
    );
  }

  factory FirestoreDestinationAuthValidationResult.success(
      [String description]) {
    const validConclusion = ConfigFieldValidationConclusion.valid;

    final usernameValidationResult = TargetValidationResult(
      target: JenkinsSourceValidationTarget.username,
      conclusion: validConclusion,
      description: description,
    );

    final apiKeyValidationResult = TargetValidationResult(
      target: JenkinsSourceValidationTarget.apiKey,
      conclusion: validConclusion,
      description: description,
    );

    return JenkinsSourceAuthValidationResult(
      usernameValidationResult: usernameValidationResult,
      apiKeyValidationResult: apiKeyValidationResult,
    );
  }
}
