import 'package:yaml/yaml.dart';

class YamlMapParser {
  const YamlMapParser();

  Map<String, dynamic> parse(String yaml) {
    if (yaml == null) {
      throw ArgumentError('YAML content is not allowed to be null');
    }

    if (yaml.isEmpty) return {};

    final yamlParsed = loadYamlNode(yaml);
    if (yamlParsed is YamlMap) {
      final result = _handleYamlMap(yamlParsed);
      return result;
    } else {
      throw ArgumentError(
        'Provided YAML contents expected to be a dictonary',
      );
    }
  }

  dynamic _handle(dynamic yaml) {
    if (yaml is YamlMap) {
      return _handleYamlMap(yaml);
    }

    if (yaml is YamlList) {
      return _handleYamlList(yaml);
    }

    if (yaml is YamlNode) {
      return _handleYamlNode(yaml);
    }

    return yaml;
  }

  Map<String, dynamic> _handleYamlMap(YamlMap yamlMap) {
    final result = <String, dynamic>{};

    yamlMap.value.forEach((key, node) {
      if (key is! String && key is! num) {
        throw FormatException(
          'YAML dictionary keys are expected to be of type String: '
          '$key is of type ${key.runtimeType}',
        );
      }

      result[key.toString()] = _handle(node);
    });

    return result;
  }

  List<dynamic> _handleYamlList(YamlList yamlList) {
    return yamlList.value.map((element) => _handle(element)).toList();
  }

  Map<String, dynamic> _handleYamlNode(YamlNode yamlNode) {
    return {
      yamlNode.span.text: _handle(yamlNode.value),
    };
  }
}
