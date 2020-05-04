import 'package:ci_integration/common/config/model/destination_config.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the Firestore destination configuration.
class FirestoreDestinationConfig extends Equatable
    implements DestinationConfig {
  /// The Firebase project identifier.
  final String firebaseProjectId;

  /// The Firestore metrics project identifier.
  final String metricsProjectId;

  @override
  List<Object> get props => [firebaseProjectId, metricsProjectId];

  @override
  String get destinationProjectId => metricsProjectId;

  /// Creates the [FirestoreDestinationConfig] with the given
  /// [metricsProjectId] and [firebaseProjectId].
  ///
  /// Throws an [ArgumentError] if either the [metricsProjectId]
  /// or [firebaseProjectId] is null.
  FirestoreDestinationConfig({
    @required this.firebaseProjectId,
    @required this.metricsProjectId,
  }) {
    ArgumentError.checkNotNull(firebaseProjectId, 'firebaseProjectId');
    ArgumentError.checkNotNull(metricsProjectId, 'metricsProjectId');
  }

  /// Creates [FirestoreDestinationConfig] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory FirestoreDestinationConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return FirestoreDestinationConfig(
      firebaseProjectId: json['firebase_project_id'] as String,
      metricsProjectId: json['metrics_project_id'] as String,
    );
  }
}
