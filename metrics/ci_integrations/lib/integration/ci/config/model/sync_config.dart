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

  /// A flag that indicates whether to fetch coverage data for builds or not.
  final bool coverage;

  @override
  List<Object> get props => [sourceProjectId, destinationProjectId, coverage];

  /// Creates an instance of this configuration.
  ///
  /// Throws an [ArgumentError], if one of the required parameters is `null`.
  SyncConfig({
    @required this.sourceProjectId,
    @required this.destinationProjectId,
    @required this.coverage,
  }) {
    ArgumentError.checkNotNull(sourceProjectId, 'sourceProjectId');
    ArgumentError.checkNotNull(destinationProjectId, 'destinationProjectId');
    ArgumentError.checkNotNull(coverage, 'coverage');
  }
}
