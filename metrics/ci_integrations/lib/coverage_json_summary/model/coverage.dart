import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// The class that represents the code coverage entity.
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

  /// Creates [Coverage] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory Coverage.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final coveragePercent = json['pct'] as int;

    return Coverage(
      percent: Percent(coveragePercent / 100),
    );
  }
}
