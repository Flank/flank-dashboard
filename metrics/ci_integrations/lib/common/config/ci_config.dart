import 'package:meta/meta.dart';

/// A class representing configurations for a project within CI
/// and builds storage context.
@immutable
class CiConfig {
  /// Used to identify a project in CI this config belongs to.
  final String ciProjectId;

  /// Used to identify a project in a builds storage.
  final String storageProjectId;

  /// Creates an instance of the CI configuration.
  ///
  /// Both [ciProjectId] and [storageProjectId] is required. If one of these
  /// values is `null`, throws [ArgumentError].
  CiConfig({
    @required this.ciProjectId,
    @required this.storageProjectId,
  }) {
    ArgumentError.checkNotNull(ciProjectId, 'ciProjectId');
    ArgumentError.checkNotNull(storageProjectId, 'storageProjectId');
  }
}
