// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:yaml/yaml.dart';

/// Wraps Dart yaml package functions to map parsing results to core Dart types.
///
/// Parses YAML dictionaries only.
/// Supported Dart types:
/// - [num],
/// - [String],
/// - [List],
/// - [Map]
///
/// Example:
/// ```dart
///   const parser = YamlMapParser();
///   const yamlString = "field: 'value'";
///   final map = parser.parse(yamlString);
///   assert(_map['field'] == 'value');
/// ```
class YamlMapParser {
  const YamlMapParser();

  /// Parses YAML string into [Map].
  ///
  /// Throws [ArgumentError] if [yaml] is null or is not YAML dictionary.
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

  /// Delegates mapping of [yaml] to specific methods depending on it's type.
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

  /// Maps [YamlMap] to [Map].
  ///
  /// Throws [FormatException] if dictionary contains at least one key not of
  /// type [String].
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

  /// Maps [YamlList] to [List].
  List<dynamic> _handleYamlList(YamlList yamlList) {
    return yamlList.value.map((element) => _handle(element)).toList();
  }

  /// Maps [YamlNode] to [Map].
  ///
  /// Should be invoked if and only if [yamlNode] is not a [YamlMap] and
  /// [YamlList] since they have no useful [YamlNode.span] to be used as key
  Map<String, dynamic> _handleYamlNode(YamlNode yamlNode) {
    return {
      yamlNode.span.text: _handle(yamlNode.value),
    };
  }
}
