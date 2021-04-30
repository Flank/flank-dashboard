// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A class providing deserialization methods for a [BuildData] model.
class BuildDataDeserializer {
  /// Creates the [BuildData] using the [json] and it's [id].
  static BuildData fromJson(Map<String, dynamic> json, String id) {
    if (json == null) return null;

    final buildResultValue = json['buildStatus'] as String;
    final durationMilliseconds = json['duration'] as int;
    final duration = durationMilliseconds == null
        ? null
        : Duration(milliseconds: durationMilliseconds);
    final coveragePercent = json['coverage'] as double;
    final buildStatus = BuildStatus.values.firstWhere(
      (element) => '$element' == buildResultValue,
      orElse: () => null,
    );

    return BuildData(
      id: id,
      projectId: json['projectId'] as String,
      duration: duration,
      coverage: coveragePercent == null ? null : Percent(coveragePercent),
      startedAt: json['startedAt'] as DateTime,
      apiUrl: json['apiUrl'] as String,
      url: json['url'] as String,
      buildNumber: json['buildNumber'] as int,
      buildStatus: buildStatus,
      workflowName: json['workflowName'] as String,
    );
  }
}
