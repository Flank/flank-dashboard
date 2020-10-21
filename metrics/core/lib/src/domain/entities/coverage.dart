import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the code coverage entity.
class Coverage extends Equatable {
  /// The code coverage percent.
  final Percent percent;

  @override
  List<Object> get props => [percent];

  /// Creates the [Coverage] with the given [percent].
  ///
  /// Throws an [ArgumentError] if the [percent] is null.
  Coverage({
    @required this.percent,
  }) {
    ArgumentError.checkNotNull(percent, 'percent');
  }
}
