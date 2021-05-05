// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class providing deserialization methods for a [BuildData] model.
class BuildDataDeserializer {
  /// Creates the [BuildData] instance from the [json] and it's [id].
  static BuildData fromJson(Map<String, dynamic> json, {String id}) {
    if (json == null) return null;

    final projectId = json['projectId'] as String;
    final buildResultValue = json['buildStatus'] as String;
    final durationMilliseconds = json['duration'] as int;
    final duration = Duration(milliseconds: durationMilliseconds ?? 0);
    final buildStatus = BuildStatus.values.firstWhere(
      (element) => '$element' == buildResultValue,
      orElse: () => BuildStatus.unknown,
    );
    final startedAtTimestamp = json['startedAt'] as Timestamp;
    final startedAt = startedAtTimestamp.toDateTime();
    final coveragePercent = json['coverage'] as double;

    return BuildData(
      id: id,
      projectId: projectId,
      buildNumber: json['buildNumber'] as int,
      startedAt: startedAt,
      buildStatus: buildStatus,
      duration: duration,
      workflowName: json['workflowName'] as String,
      url: json['url'] as String,
      apiUrl: json['apiUrl'] as String,
      coverage: coveragePercent == null ? null : Percent(coveragePercent),
    );
  }
}
