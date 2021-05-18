// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents the [Build] entity.
class BuildDataModel extends Build implements DataModel {
  /// Creates a new instance of the [BuildDataModel].
  const BuildDataModel({
    String id,
    String projectId,
    int buildNumber,
    DateTime startedAt,
    BuildStatus buildStatus,
    Duration duration,
    String workflowName,
    String url,
    String apiUrl,
    Percent coverage,
  }) : super(
          id: id,
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'buildNumber': buildNumber,
      'startedAt': startedAt,
      'buildStatus': buildStatus?.toString(),
      'duration': duration?.inMilliseconds,
      'workflowName': workflowName,
      'url': url,
      'apiUrl': apiUrl,
      'coverage': coverage?.value,
    };
  }
}
