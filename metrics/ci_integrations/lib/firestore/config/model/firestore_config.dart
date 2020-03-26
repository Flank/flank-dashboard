import 'package:meta/meta.dart';

/// Represents the firestore destination configuration.
class FirestoreConfig {
  /// The firestore metrics project identifier that defines where to save metrics,
  /// loaded from the CI.
  final String metricsProjectId;

  /// The firebase project identifier that defines which instance of
  /// firebase used to store loaded metrics.
  final String firebaseProjectId;

  /// Creates the [FirestoreConfig] with the given [metricsProjectId].
  ///
  /// Throws the [ArgumentError] is the [metricsProjectId]
  /// or [firebaseProjectId] is null.
  FirestoreConfig({
    @required this.metricsProjectId,
    @required this.firebaseProjectId,
  }) {
    ArgumentError.checkNotNull(metricsProjectId, 'metriccs_project_id');
    ArgumentError.checkNotNull(firebaseProjectId, 'firebase_project_id');
  }

  /// Creates [FirestoreConfig] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory FirestoreConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return FirestoreConfig(
      metricsProjectId: json['metrics_project_id'] as String,
      firebaseProjectId: json['firebase_project_id'] as String,
    );
  }
}
