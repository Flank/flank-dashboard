import 'package:meta/meta.dart';

/// Represents the integration configuration.
class RawIntegrationConfig {
  /// Configuration of source CI from which metrics will be loaded.
  final Map<String, dynamic> sourceConfigMap;

  /// The configuration that defines where to store loaded metrics.
  final Map<String, dynamic> destinationConfigMap;

  /// Creates the [RawIntegrationConfig].
  ///
  /// If the [sourceConfigMap] or [destinationConfigMap] is null -
  /// throws an [ArgumentError].
  RawIntegrationConfig({
    @required this.sourceConfigMap,
    @required this.destinationConfigMap,
  }) {
    ArgumentError.checkNotNull(sourceConfigMap, 'sourceConfigMap');
    ArgumentError.checkNotNull(destinationConfigMap, 'destinationConfigMap');
  }
}
