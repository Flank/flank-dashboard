// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class providing deserialization methods for a [BuildData] model.
class BuildDataDeserializer {
  /// Creates the [BuildData] instance from the [json] and it's [id].
  static BuildData fromJson(Map<String, dynamic> json, String id) {
    final buildResultValue = json['buildStatus'] as String;
    final durationMilliseconds = json['duration'] as int;
    final coverage = json['coverage'] as double;
    final buildStatus = BuildStatus.values.firstWhere(
      (element) => '$element' == buildResultValue,
      orElse: () => BuildStatus.unknown,
    );

    return BuildData(
      id: id,
      buildNumber: json['buildNumber'] as int,
      startedAt: (json['startedAt'] as Timestamp).toDate(),
      buildStatus: buildStatus,
      duration: Duration(milliseconds: durationMilliseconds),
      workflowName: json['workflowName'] as String,
      url: json['url'] as String,
      coverage: coverage != null ? Percent(coverage) : null,
    );
  }
}
