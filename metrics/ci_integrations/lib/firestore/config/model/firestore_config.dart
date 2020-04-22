import 'package:ci_integration/common/config/model/destination_config.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the Firestore configuration.
class FirestoreConfig extends Equatable implements DestinationConfig {
  /// The Firebase project identifier.
  final String firebaseProjectId;

  /// The Firestore metrics project identifier.
  final String metricsProjectId;

  @override
  List<Object> get props => [firebaseProjectId, metricsProjectId];

  @override
  String get destinationProjectId => metricsProjectId;

  /// Creates the [FirestoreConfig] with the given
  /// [metricsProjectId] and [firebaseProjectId].
  ///
  /// Throws an [ArgumentError] if either the [metricsProjectId]
  /// or [firebaseProjectId] is null.
  FirestoreConfig({
    @required this.firebaseProjectId,
    @required this.metricsProjectId,
  }) {
    ArgumentError.checkNotNull(firebaseProjectId, 'firebaseProjectId');
    ArgumentError.checkNotNull(metricsProjectId, 'metricsProjectId');
  }

  /// Creates [FirestoreConfig] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory FirestoreConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return FirestoreConfig(
      firebaseProjectId: json['firebase_project_id'] as String,
      metricsProjectId: json['metrics_project_id'] as String,
    );
  }
}
