import 'package:equatable/equatable.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the code coverage entity.
class Coverage extends Equatable {
  /// The code coverage percent.
  final Percent percent;

  @override
  List<Object> get props => [percent];

  /// Creates the [Coverage] with the given [percent].
  const Coverage({
    this.percent,
  });
}
