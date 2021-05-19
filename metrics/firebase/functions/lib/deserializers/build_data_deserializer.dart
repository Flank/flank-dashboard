// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class providing deserialization methods for a [BuildData] model.
class BuildDataDeserializer {
  /// Creates a new instance of the [BuildData] from the given [json].
  ///
  /// Returns `null` if the given [json] is `null`.
  static BuildData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final projectId = json['projectId'] as String;
    final buildNumber = json['buildNumber'] as int;
    final startedAtTimestamp = json['startedAt'] as Timestamp;
    final startedAt = startedAtTimestamp.toDateTime();
    final buildStatusValue = json['buildStatus'] as String;
    final buildStatus = BuildStatus.values.firstWhere(
      (element) => '$element' == buildStatusValue,
      orElse: () => BuildStatus.unknown,
    );
    final durationMilliseconds = json['duration'] as int;
    final duration = Duration(milliseconds: durationMilliseconds ?? 0);
    final workflowName = json['workflowName'] as String;
    final url = json['url'] as String;
    final apiUrl = json['apiUrl'] as String;
    final coveragePercent = json['coverage'] as double;
    final coverage = coveragePercent == null ? null : Percent(coveragePercent);

    return BuildData(
      projectId: projectId,
      buildNumber: buildNumber,
      startedAt: startedAt,
      buildStatus: buildStatus,
      duration: duration,
      workflowName: workflowName,
      url: url,
      apiUrl: apiUrl,
      coverage: coverage,
    );
  }
}
