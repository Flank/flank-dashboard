// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:metrics_core/src/domain/entities/coverage.dart';

/// A [DataModel] that represents the [Coverage] entity.
class CoverageData extends Coverage implements DataModel {
  /// Creates a new instance of the [CoverageData] with the given [percent].
  const CoverageData({Percent percent}) : super(percent: percent);

  /// Creates a new instance of the [CoverageData] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory CoverageData.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final coveragePercent = json['pct'] as double;

    return CoverageData(
      percent: Percent(coveragePercent),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'pct': percent?.value,
    };
  }
}
