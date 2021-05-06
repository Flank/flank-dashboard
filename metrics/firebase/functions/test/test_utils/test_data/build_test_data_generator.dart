// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that contains method for generating Build test data
/// to use in tests.
class BuildTestDataGenerator {
  /// A project id to use in this test data generator.
  final String projectId;

  /// Creates a new instance of the [BuildTestDataGenerator].
  BuildTestDataGenerator({
    this.projectId,
  });

  /// Generates a build [Map].
  Map<String, dynamic> generateBuildJson({
    int buildNumber,
    DateTime startedAt,
    BuildStatus buildStatus = BuildStatus.successful,
    Duration duration = const Duration(milliseconds: 100),
    String workflowName,
    String url,
    String apiUrl,
    Percent coverage,
  }) {
    final startedAtDateTime = startedAt ?? DateTime.now();

    return {
      'projectId': projectId,
      'buildNumber': buildNumber,
      'startedAt': Timestamp.fromDateTime(startedAtDateTime),
      'buildStatus': buildStatus?.toString(),
      'duration': duration?.inMilliseconds,
      'workflowName': workflowName,
      'url': url,
      'apiUrl': apiUrl,
      'coverage': coverage?.value,
    };
  }
}
