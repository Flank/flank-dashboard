import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:ci_integration/common/client_factory/source_client_factory.dart';
import 'package:ci_integration/jenkins/adapter/jenkins_source_client_adapter.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';

class JenkinsSourceClientFactory
    implements SourceClientFactory<JenkinsConfig, JenkinsSourceClientAdapter> {
  const JenkinsSourceClientFactory();

  @override
  JenkinsSourceClientAdapter create(JenkinsConfig config) {
    final jenkinsClient = JenkinsClient(
      url: config.url,
      authorization: BasicAuthorization(
        config.username,
        config.apiKey,
      ),
    );

    return JenkinsSourceClientAdapter(jenkinsClient);
  }
}
