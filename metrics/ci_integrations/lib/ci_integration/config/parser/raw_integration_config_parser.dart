import 'package:ci_integration/ci_integration/config/model/raw_integration_config.dart';
import 'package:yaml_map/yaml_map.dart';

/// The class needed to parse the CI integrations configuration YAML.
class RawIntegrationConfigParser {
  static const YamlMapParser _parser = YamlMapParser();

  const RawIntegrationConfigParser();

  /// Creates the [RawIntegrationConfig] from the given [configYaml].
  ///
  /// If the [configYaml] is required. 
  /// Throws an [ArgumentError] if [configYaml] is `null`.
  RawIntegrationConfig parse(String configYaml) {
    ArgumentError.checkNotNull(configYaml, 'configYaml');

    final configMap = _parser.parse(configYaml);
    final sourceMap = configMap['source'] as Map<String, dynamic>;
    final destinationMap = configMap['destination'] as Map<String, dynamic>;

    return RawIntegrationConfig(
      sourceConfigMap: sourceMap,
      destinationConfigMap: destinationMap,
    );
  }
}
