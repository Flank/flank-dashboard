import 'package:meta/meta.dart';

/// A class representing configurations for a project within CI
/// and builds storage context.
@immutable
class SyncConfig {
  /// Used to identify a project in a source this config belongs to.
  final String sourceProjectId;

  /// Used to identify a project in a builds storage.
  final String destinationProjectId;

  /// Creates an instance of the CI configuration.
  ///
  /// Both [sourceProjectId] and [destinationProjectId] is required. If one of these
  /// values is `null`, throws an [ArgumentError].
  SyncConfig({
    @required this.sourceProjectId,
    @required this.destinationProjectId,
  }) {
    ArgumentError.checkNotNull(sourceProjectId, 'sourceProjectId');
    ArgumentError.checkNotNull(destinationProjectId, 'destinationProjectId');
  }
}
