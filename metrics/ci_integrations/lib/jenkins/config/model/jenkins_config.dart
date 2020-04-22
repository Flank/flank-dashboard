import 'package:ci_integration/common/config/model/source_config.dart';
import 'package:meta/meta.dart';

/// Represents the Jenkins source config.
class JenkinsConfig implements SourceConfig {
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

  /// Creates the [JenkinsConfig].
  ///
  /// Throws an [ArgumentError] if either [url] or [jobName] is null.
  JenkinsConfig({
    @required this.url,
    @required this.jobName,
    this.username,
    this.apiKey,
  }) {
    ArgumentError.checkNotNull(jobName, 'jobName');
    ArgumentError.checkNotNull(url, 'url');
  }

  /// Creates [JenkinsConfig] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory JenkinsConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JenkinsConfig(
      url: json['url'] as String,
      jobName: json['job_name'] as String,
      username: json['username'] as String,
      apiKey: json['apiKey'] as String,
    );
  }
}
