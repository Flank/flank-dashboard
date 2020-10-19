import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:metrics_core/src/domain/entities/coverage.dart';

/// [DataModel] that represents the [Coverage] entity.
class CoverageModel extends Coverage implements DataModel {
  /// Creates a new instance of the [CoverageModel] with the given [percent].
  CoverageModel({@required Percent percent}) : super(percent: percent);

  //// Creates a new instance of the [CoverageModel] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory CoverageModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final coveragePercent = json['pct'] as int;

    return CoverageModel(
      percent: Percent(coveragePercent / 100),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'pct': percent.toString(),
    };
  }
}
