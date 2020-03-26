import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:yaml_map/yaml_map.dart';

/// The class needed to parse the CI configuration YAML.
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

    final configJson = _parser.parse(ciConfigYaml);
    final sourceJson = configJson['source'] as Map<String, dynamic>;
    final destinationJson = configJson['destination'] as Map<String, dynamic>;

    if (sourceJson == null || destinationJson == null) {
      throw const FormatException(
        "The configuration file must contain 'source' and 'destination' entities.",
      );
    }

    final firestoreConfigJson =
        destinationJson['firestore'] as Map<String, dynamic>;
    final firestoreConfig = FirestoreConfig.fromJson(firestoreConfigJson);
    final jenkinsConfigJson = sourceJson['jenkins'] as Map<String, dynamic>;
    final jenkinsConfig = JenkinsConfig.fromJson(jenkinsConfigJson);

    return CiIntegrationConfig(
      source: jenkinsConfig,
      destination: firestoreConfig,
    );
  }
}
