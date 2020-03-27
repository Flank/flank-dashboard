import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:meta/meta.dart';

/// Represents the ci integration configuration.
class CiIntegrationConfig {
  /// Configuration of source CI from which metrics will be loaded.
  final JenkinsConfig source;

  /// The configuration that defines where to store loaded metrics.
  final FirestoreConfig destination;

  /// Creates the [CiIntegrationConfig].
  ///
  /// If the [source] or [destination] is null -
  /// throws an [ArgumentError].
  CiIntegrationConfig({
    @required this.source,
    @required this.destination,
  }) {
    ArgumentError.checkNotNull(source, 'ciConfig');
    ArgumentError.checkNotNull(destination, 'firestoreConfig');
  }
}
