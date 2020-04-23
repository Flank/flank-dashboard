import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';

/// A class containig a test data for the [JenkinsConfig].
class JenkinsConfigTestData {
  static const String url = 'url';
  static const String username = 'username';
  static const String apiKey = 'apiKey';
  static const String jobName = 'jobName';

  static const Map<String, dynamic> jenkinsConfigMap = {
    'url': url,
    'username': username,
    'api_key': apiKey,
    'job_name': jobName,
  };

  static final JenkinsConfig jenkinsConfig = JenkinsConfig(
    url: url,
    jobName: jobName,
    username: username,
    apiKey: apiKey,
  );
}
