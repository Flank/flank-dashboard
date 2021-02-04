// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/jenkins_client.dart';
import 'package:ci_integration/integration/interface/source/client_factory/source_client_factory.dart';
import 'package:ci_integration/source/jenkins/adapter/jenkins_source_client_adapter.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';
import 'package:ci_integration/util/authorization/authorization.dart';

/// A client factory for the Jenkins source integration.
///
/// Used to create instances of the [JenkinsSourceClientAdapter]
/// using [JenkinsSourceConfig].
class JenkinsSourceClientFactory
    implements
        SourceClientFactory<JenkinsSourceConfig, JenkinsSourceClientAdapter> {
  /// Creates a new instance of the [JenkinsSourceClientFactory].
  const JenkinsSourceClientFactory();

  @override
  JenkinsSourceClientAdapter create(JenkinsSourceConfig config) {
    ArgumentError.checkNotNull(config, 'config');

    BasicAuthorization authorization;
    if (config.username != null && config.apiKey != null) {
      authorization = BasicAuthorization(config.username, config.apiKey);
    }

    final jenkinsClient = JenkinsClient(
      jenkinsUrl: config.url,
      authorization: authorization,
    );

    return JenkinsSourceClientAdapter(jenkinsClient);
  }
}
