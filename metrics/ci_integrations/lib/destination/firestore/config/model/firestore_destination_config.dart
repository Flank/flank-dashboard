// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/destination/config/model/destination_config.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the Firestore destination configuration.
class FirestoreDestinationConfig extends Equatable
    implements DestinationConfig {
  /// The Firebase project identifier.
  final String firebaseProjectId;

  /// The Firestore metrics project identifier.
  final String metricsProjectId;

  /// The Firebase user email.
  final String firebaseUserEmail;

  /// The Firebase user password.
  final String firebaseUserPassword;

  /// The Firebase public API key.
  final String firebasePublicApiKey;

  @override
  List<Object> get props => [
        firebaseProjectId,
        metricsProjectId,
        firebaseUserEmail,
        firebaseUserPassword,
        firebasePublicApiKey,
      ];

  @override
  String get destinationProjectId => metricsProjectId;

  /// Creates the [FirestoreDestinationConfig] with the given [metricsProjectId].
  ///
  /// All the arguments are required. Throws an [ArgumentError]
  /// if any of them is `null`.
  FirestoreDestinationConfig({
    @required this.firebaseProjectId,
    @required this.firebaseUserEmail,
    @required this.firebaseUserPassword,
    @required this.firebasePublicApiKey,
    @required this.metricsProjectId,
  }) {
    ArgumentError.checkNotNull(firebaseProjectId, 'firebaseProjectId');
    ArgumentError.checkNotNull(firebaseUserEmail, 'firebaseUserEmail');
    ArgumentError.checkNotNull(firebaseUserPassword, 'firebaseUserPassword');
    ArgumentError.checkNotNull(firebasePublicApiKey, 'firebasePublicApiKey');
    ArgumentError.checkNotNull(metricsProjectId, 'metricsProjectId');
  }

  /// Creates [FirestoreDestinationConfig] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory FirestoreDestinationConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return FirestoreDestinationConfig(
      firebaseProjectId: json['firebase_project_id'] as String,
      firebaseUserPassword: json['firebase_user_pass'] as String,
      firebaseUserEmail: json['firebase_user_email'] as String,
      firebasePublicApiKey: json['firebase_public_api_key'] as String,
      metricsProjectId: json['metrics_project_id'] as String,
    );
  }
}
