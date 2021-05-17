// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A class providing serialization method for a [BuildData] model.
class BuildDataSerializer {
  /// Converts a given [buildData] into the JSON-encodable map.
  static Map<String, dynamic> toJson(BuildData buildData) {
    if (buildData == null) return null;

    return {
      'id': buildData.id,
      'projectId': buildData.projectId,
      'buildNumber': buildData.buildNumber,
      'startedAt': buildData.startedAt,
      'buildStatus': buildData.buildStatus?.toString(),
      'duration': buildData.duration?.inMilliseconds,
      'workflowName': buildData.workflowName,
      'url': buildData.url,
      'apiUrl': buildData.apiUrl,
      'coverage': buildData.coverage?.value,
    };
  }
}
