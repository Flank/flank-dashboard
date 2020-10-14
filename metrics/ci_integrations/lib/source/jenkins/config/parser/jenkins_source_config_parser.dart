import 'package:ci_integration/integration/interface/source/config/parser/source_config_parser.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';

/// A configuration parser for the Jenkins source integration.
class JenkinsSourceConfigParser
    implements SourceConfigParser<JenkinsSourceConfig> {
  /// Creates a new instance of the [JenkinsSourceConfigParser].
  const JenkinsSourceConfigParser();

  @override
  bool canParse(Map<String, dynamic> map) {
    return map != null && map['jenkins'] != null;
  }

  @override
  JenkinsSourceConfig parse(Map<String, dynamic> map) {
    if (map == null) return null;

    final jenkinsConfigMap = map['jenkins'] as Map<String, dynamic>;
    return JenkinsSourceConfig.fromJson(jenkinsConfigMap);
  }
}
