// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [JenkinsSourceConfig]'s fields.
class JenkinsSourceValidationTarget {
  /// A url field of the [JenkinsSourceConfig].
  static const url = ValidationTarget(name: 'url');

  /// A job name field of the [JenkinsSourceConfig].
  static const jobName = ValidationTarget(name: 'job_name');

  /// A username field of the [JenkinsSourceConfig].
  static const username = ValidationTarget(name: 'username');

  /// An api key field of the [JenkinsSourceConfig].
  static const apiKey = ValidationTarget(name: 'api_key');

  /// A list containing all [JenkinsSourceValidationTarget]s of
  /// the [JenkinsSourceConfig].
  static final List<ValidationTarget> values = UnmodifiableListView([
    url,
    jobName,
    username,
    apiKey,
  ]);
}
