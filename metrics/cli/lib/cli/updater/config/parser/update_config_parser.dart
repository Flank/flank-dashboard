// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/updater/config/model/update_config.dart';
import 'package:yaml_map/yaml_map.dart';

/// A class providing methods for parsing [UpdateConfig] from YAML string.
class UpdateConfigParser {
  /// The YAML parser used to convert YAML string to the [Map] instance.
  static const YamlMapParser _parser = YamlMapParser();

  /// Create a new instance of the [UpdateConfigParser].
  const UpdateConfigParser();

  /// Parses the given [configYaml] into the [UpdateConfig] instance.
  ///
  /// Throws an [ArgumentError] if the [configYaml] is `null`.
  UpdateConfig parse(String configYaml) {
    ArgumentError.checkNotNull(configYaml, 'configYaml');

    final json = _parser.parse(configYaml);

    return UpdateConfig.fromJson(json);
  }
}
