// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/config/update_config.dart';
import 'package:yaml_map/yaml_map.dart';

/// A class providing methods for parsing [UpdateConfig] from YAML string.
class UpdateConfigParser {
  /// The YAML parser used to convert YAML string to the JSON-encodable [Map].
  final YamlMapParser _parser;

  /// Create a new instance of the [UpdateConfigParser].
  ///
  /// If the given [parser] is `null`, an instance of the [YamlMapParser]
  /// is used.
  const UpdateConfigParser({YamlMapParser parser})
      : _parser = parser ?? const YamlMapParser();

  /// Parses the given [configYaml] into the [UpdateConfig] instance.
  ///
  /// Throws an [ArgumentError] if the [configYaml] is `null`.
  UpdateConfig parse(String configYaml) {
    ArgumentError.checkNotNull(configYaml, 'configYaml');

    final json = _parser.parse(configYaml);

    return UpdateConfig.fromJson(json);
  }
}
