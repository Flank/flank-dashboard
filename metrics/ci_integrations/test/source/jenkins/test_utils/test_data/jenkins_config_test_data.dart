// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';

/// A class containing a test data for the [JenkinsSourceConfig].
class JenkinsConfigTestData {
  static const String url = 'url';
  static const String username = 'username';
  static const String apiKey = 'apiKey';
  static const String jobName = 'jobName';

  static const Map<String, dynamic> jenkinsSourceConfigMap = {
    'url': url,
    'username': username,
    'api_key': apiKey,
    'job_name': jobName,
  };

  static final JenkinsSourceConfig jenkinsSourceConfig = JenkinsSourceConfig(
    url: url,
    jobName: jobName,
    username: username,
    apiKey: apiKey,
  );
}
