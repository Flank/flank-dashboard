import 'dart:io';

import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:meta/meta.dart';
import 'package:yaml_map/yaml_map.dart';

/// The class needed to parse the Jenkins config YAML file.
class ConfigParser {
  static const YamlMapParser _parser = YamlMapParser();

  /// Path to the CI integration configuration YAML file.
  final String _configFilePath;

  /// Creates [ConfigParser] with the given [configFilePath].
  ///
  /// The [configFilePath] must not be null.
  /// Throws an [ArgumentError] if [configFilePath] is null.
  ConfigParser({
    @required String configFilePath,
  }) : _configFilePath = configFilePath {
    ArgumentError.checkNotNull(_configFilePath, 'configFilePath');
  }

  /// Creates the [CiIntegrationConfig] from the configuration YAML file.
  ///
  /// If the file does not exist - throws [FileSystemException].
  /// If the 'source' or 'destination' entities are missing
  /// in file - the [FormatException] will be thrown.
  CiIntegrationConfig parse() {
    final configFile = File('$_configFilePath');

    if (!configFile.existsSync()) {
      throw FileSystemException(
        "Could not find a file named '$_configFilePath'.",
        configFile.path,
      );
    }

    final configJson = _parser.parse(configFile.readAsStringSync());
    final sourceJson = configJson['source'] as Map<String, dynamic>;
    final destinationJson = configJson['destination'] as Map<String, dynamic>;

    if (sourceJson == null || destinationJson == null) {
      throw const FormatException(
        "The configuration file must contain 'source' and 'destination' entities.",
      );
    }

    final firebaseJson = destinationJson['firestore'] as Map<String, dynamic>;
    final firebaseConfig = FirestoreConfig.fromJson(firebaseJson);
    final jenkinsJson = sourceJson['jenkins'] as Map<String, dynamic>;
    final sourceConfig = JenkinsConfig.fromJson(jenkinsJson);

    return CiIntegrationConfig(
      source: sourceConfig,
      destination: firebaseConfig,
    );
  }
}
