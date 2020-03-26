import 'package:meta/meta.dart';

/// Represents the Jenkins CI config.
class JenkinsConfig {
  /// Jenkins building job name.
  final String jobName;

  /// The url to the Jenkins instance.
  final String url;

  /// The Jenkins account username.
  final String username;

  /// The Jenkins account password.
  final String password;

  /// Creates the [JenkinsConfig].
  ///
  /// Throws an [ArgumentError] is [url] or [jobName] is null.
  JenkinsConfig({
    @required this.url,
    @required this.jobName,
    this.username,
    this.password,
  }) {
    ArgumentError.checkNotNull(jobName, 'buildJobId');
    ArgumentError.checkNotNull(url, 'url');
  }

  /// Creates [JenkinsConfig] from JSON encodable [Map].
  factory JenkinsConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JenkinsConfig(
      url: json['url'] as String,
      jobName: json['job_name'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }
}
