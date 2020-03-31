import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:yaml_map/yaml_map.dart';

/// The class needed to parse the CI integrations configuration YAML.
class CiIntegrationConfigParser {
  static const YamlMapParser _parser = YamlMapParser();

  const CiIntegrationConfigParser();

  /// Creates the [CiIntegrationConfig] from the [ciConfigYaml].
  ///
  /// The [ciConfigYaml] must not be null.
  ///
  /// If the 'source' or 'destination' entities are missing -
  /// the [FormatException] will be thrown.
  CiIntegrationConfig parse(String ciConfigYaml) {
    ArgumentError.checkNotNull(ciConfigYaml, 'ciConfigYaml');

    final configMap = _parser.parse(ciConfigYaml);
    final sourceMap = configMap['source'] as Map<String, dynamic>;
    final destinationMap = configMap['destination'] as Map<String, dynamic>;

    if (sourceMap == null || destinationMap == null) {
      throw const FormatException(
        "The configuration file must contain 'source' and 'destination' entities.",
      );
    }

    final firestoreConfigMap =
        destinationMap['firestore'] as Map<String, dynamic>;
    final firestoreConfig = FirestoreConfig.fromJson(firestoreConfigMap);
    final jenkinsConfigMap = sourceMap['jenkins'] as Map<String, dynamic>;
    final jenkinsConfig = JenkinsConfig.fromJson(jenkinsConfigMap);

    return CiIntegrationConfig(
      source: jenkinsConfig,
      destination: firestoreConfig,
    );
  }
}
