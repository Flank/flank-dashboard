// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class providing deserialization methods for a [BuildData] model.
class BuildDataDeserializer {
  /// Creates the [BuildData] instance from the [json].
  static BuildData fromJson(Map<String, dynamic> json) {
    final projectId = json['projectId'] as String;
    final buildResultValue = json['buildStatus'] as String;
    final durationMilliseconds = json['duration'] as int;
    final duration = durationMilliseconds == null
        ? Duration.zero
        : Duration(milliseconds: durationMilliseconds);
    final buildStatus = BuildStatus.values.firstWhere(
      (element) => '$element' == buildResultValue,
      orElse: () => BuildStatus.unknown,
    );

    return BuildData(
      projectId: projectId,
      startedAt: (json['startedAt'] as Timestamp).toDateTime(),
      buildStatus: buildStatus,
      duration: duration,
    );
  }
}
