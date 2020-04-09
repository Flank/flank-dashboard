import 'package:meta/meta.dart';

/// Represents the firestore configuration.
class FirestoreConfig {
  /// The firebase project identifier.
  final String firebaseProjectId;

  /// The firestore metrics project identifier.
  final String metricsProjectId;

  /// The firebase user email.
  final String firebaseUserEmail;

  /// The firebase user password.
  final String firebaseUserPassword;

  /// The firebase Web API key.
  final String firebaseAuthApiKey;

  /// Creates the [FirestoreConfig] with the given [metricsProjectId].
  ///
  /// Throws the [ArgumentError] if the [metricsProjectId]
  /// or [firebaseProjectId] or [firebaseUserEmail]
  /// or [firebaseUserPassword] or [firebaseAuthApiKey] is null.
  FirestoreConfig({
    @required this.firebaseProjectId,
    @required this.metricsProjectId,
    @required this.firebaseUserEmail,
    @required this.firebaseUserPassword,
    @required this.firebaseAuthApiKey,
  }) {
    ArgumentError.checkNotNull(firebaseProjectId, 'firebaseProjectId');
    ArgumentError.checkNotNull(metricsProjectId, 'metricsProjectId');
    ArgumentError.checkNotNull(firebaseUserEmail, 'firebaseUserEmail');
    ArgumentError.checkNotNull(firebaseUserPassword, 'firebaseUserPassword');
    ArgumentError.checkNotNull(firebaseAuthApiKey, 'firebaseAuthApiKey');
  }

  /// Creates [FirestoreConfig] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory FirestoreConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return FirestoreConfig(
      firebaseProjectId: json['firebase_project_id'] as String,
      metricsProjectId: json['metrics_project_id'] as String,
      firebaseUserPassword: json['firebase_user_pass'] as String,
      firebaseUserEmail: json['firebase_user_email'] as String,
      firebaseAuthApiKey: json['firebase_api_key'] as String,
    );
  }
}
