import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class representing configurations for a project within a source
/// and destination context.
@immutable
class SyncConfig extends Equatable {
  /// Used to identify a project in a source the metrics will be loaded from.
  final String sourceProjectId;

  /// Used to identify a project in a destination storage
  /// the loaded metrics will be saved to.
  final String destinationProjectId;

  @override
  List<Object> get props => [sourceProjectId, destinationProjectId];

  /// Creates an instance of this configuration.
  ///
  /// Both [sourceProjectId] and [destinationProjectId] are required.
  /// If one of these values is `null`, throws an [ArgumentError].
  SyncConfig({
    @required this.sourceProjectId,
    @required this.destinationProjectId,
  }) {
    ArgumentError.checkNotNull(sourceProjectId, 'sourceProjectId');
    ArgumentError.checkNotNull(destinationProjectId, 'destinationProjectId');
  }
}
