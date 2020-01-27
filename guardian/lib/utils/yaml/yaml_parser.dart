import 'package:yaml/yaml.dart';

class YamlParser {
  Map<String, dynamic> parse(String yaml) {
    final yamlParsed = loadYaml(yaml);
    final parsed = _handleYaml(yamlParsed);
    if (parsed is Map) {
      return Map<String, dynamic>.from(parsed);
    } else {
      return null;
    }
  }

  dynamic _handleYaml(dynamic yaml) {
    if (yaml is YamlDocument) {
      return _handleYaml(yaml.contents);
    }

    if (yaml is YamlMap) {
      final result = {};

      yaml.value.forEach((key, node) {
        result[key] = _handleYaml(node);
      });

      return result;
    }

    if (yaml is YamlList) {
      return yaml.value.map((element) => _handleYaml(element)).toList();
    }

    if (yaml is YamlScalar) {
      return yaml.value;
    }

    if (yaml is YamlNode) {
      return {
        yaml.span: _handleYaml(yaml.value),
      };
    }

    return yaml;
  }
}
