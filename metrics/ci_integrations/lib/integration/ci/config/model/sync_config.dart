import 'package:ci_integration/util/validator/number_validator.dart';
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
