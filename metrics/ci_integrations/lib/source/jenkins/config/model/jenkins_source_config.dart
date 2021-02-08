// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the Jenkins source config.
class JenkinsSourceConfig extends Equatable implements SourceConfig {
  /// The URL to the Jenkins instance.
  final String url;

  /// The Jenkins building job name.
  final String jobName;

  /// The Jenkins account username.
  final String username;

  /// The Jenkins account API key.
  final String apiKey;

  @override
  String get sourceProjectId => jobName;

  @override
  List<Object> get props => [url, jobName, username, apiKey];

  /// Creates the [JenkinsSourceConfig].
  ///
  /// Throws an [ArgumentError] if either [url] or [jobName] is null.
  JenkinsSourceConfig({
    @required this.url,
    @required this.jobName,
    this.username,
    this.apiKey,
  }) {
    ArgumentError.checkNotNull(jobName, 'jobName');
    ArgumentError.checkNotNull(url, 'url');
  }

  /// Creates [JenkinsSourceConfig] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory JenkinsSourceConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JenkinsSourceConfig(
      url: json['url'] as String,
      jobName: json['job_name'] as String,
      username: json['username'] as String,
      apiKey: json['api_key'] as String,
    );
  }
}
