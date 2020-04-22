import 'package:ci_integration/common/config/parser/source_config_parser.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';

/// A configuration parser for the Jenkins source integration.
class JenkinsConfigParser implements SourceConfigParser<JenkinsConfig> {
  const JenkinsConfigParser();

  @override
  bool canParse(Map<String, dynamic> map) {
    return map['jenkins'] != null;
  }

  @override
  JenkinsConfig parse(Map<String, dynamic> map) {
    final jenkinsConfigMap = map['jenkins'] as Map<String, dynamic>;
    return JenkinsConfig.fromJson(jenkinsConfigMap);
  }
}
