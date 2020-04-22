import 'package:ci_integration/common/party/source_party.dart';
import 'package:ci_integration/jenkins/adapter/jenkins_source_client_adapter.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:ci_integration/jenkins/config/parser/jenkins_config_parser.dart';
import 'package:ci_integration/jenkins/client_factory/jenkins_source_client_factory.dart';

/// An integration party for the Jenkins source integration.
class JenkinsSourceParty
    implements SourceParty<JenkinsConfig, JenkinsSourceClientAdapter> {
  @override
  final JenkinsSourceClientFactory clientFactory =
      const JenkinsSourceClientFactory();

  @override
  final JenkinsConfigParser configParser = const JenkinsConfigParser();
}
