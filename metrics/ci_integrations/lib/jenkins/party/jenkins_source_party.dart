import 'package:ci_integration/common/party/source_party.dart';
import 'package:ci_integration/jenkins/adapter/jenkins_source_client_adapter.dart';
import 'package:ci_integration/jenkins/client_factory/jenkins_source_client_factory.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_source_config.dart';
import 'package:ci_integration/jenkins/config/parser/jenkins_source_config_parser.dart';

/// An integration party for the Jenkins source integration.
class JenkinsSourceParty
    implements SourceParty<JenkinsSourceConfig, JenkinsSourceClientAdapter> {
  @override
  final JenkinsSourceClientFactory clientFactory =
      const JenkinsSourceClientFactory();

  @override
  final JenkinsSourceConfigParser configParser = const JenkinsSourceConfigParser();
}
