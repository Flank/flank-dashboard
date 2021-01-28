import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a configuration to use in sync.
@immutable
class SyncConfig extends Equatable {
  /// A uniquie ID of the source project to load the project metrics from.
  final String sourceProjectId;

  /// A unique ID of the destination project to save the loaded metrics.
  final String destinationProjectId;

  /// A number of builds to fetch from the source during project's
  /// initial synchronization.
  final int initialFetchLimit;

  /// A flag that indicates whether to fetch coverage data for builds or not.
  final bool coverage;

  @override
  List<Object> get props => [
        sourceProjectId,
        destinationProjectId,
        initialFetchLimit,
        coverage,
      ];

  /// Creates an instance of the [SyncConfig] with the given parameters.
  ///
  /// All parameters are required.
  ///
  /// Throws an [ArgumentError] if any of the given parameters is `null`.
  ///
  /// Throws an [ArgumentError] if the given [initialFetchLimit] is not
  /// greater than `0`.
  SyncConfig({
    @required this.sourceProjectId,
    @required this.destinationProjectId,
    @required this.coverage,
    @required this.initialFetchLimit,
  }) {
    ArgumentError.checkNotNull(sourceProjectId, 'sourceProjectId');
    ArgumentError.checkNotNull(destinationProjectId, 'destinationProjectId');
    ArgumentError.checkNotNull(coverage, 'coverage');

    if (initialFetchLimit == null || initialFetchLimit <= 0) {
      throw ArgumentError(
        'The initial fetch limit must be an integer value grater than 0',
      );
    }
  }
}
