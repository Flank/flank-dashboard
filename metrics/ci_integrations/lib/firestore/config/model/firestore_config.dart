import 'package:meta/meta.dart';

/// Represents the firestore destination configuration.
class FirestoreConfig {
  /// The firestore metrics project identifier that defines where to save metrics,
  /// loaded from the CI.
  final String metricsProjectId;

  /// The firebase project identifier that defines which instance of
  /// firebase used to store loaded metrics.
  final String firestoreProjectId;

  /// Creates the [FirestoreConfig] with the given [metricsProjectId].
  ///
  /// Throws the [ArgumentError] is the [metricsProjectId]
  /// or [firestoreProjectId] is null.
  FirestoreConfig({
    @required this.metricsProjectId,
    @required this.firestoreProjectId,
  }) {
    ArgumentError.checkNotNull(metricsProjectId, 'metriccs_project_id');
    ArgumentError.checkNotNull(firestoreProjectId, 'firestore_project_id');
  }

  factory FirestoreConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return FirestoreConfig(
      metricsProjectId: json['metrics_project_id'] as String,
      firestoreProjectId: json['firestore_project_id'] as String,
    );
  }
}
