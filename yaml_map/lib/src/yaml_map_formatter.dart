// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:yaml_map/src/formatter/date_time_type_formatter.dart';
import 'package:yaml_map/src/formatter/list_type_formatter.dart';
import 'package:yaml_map/src/formatter/map_type_formatter.dart';
import 'package:yaml_map/src/formatter/num_type_formatter.dart';
import 'package:yaml_map/src/formatter/string_type_formatter.dart';
import 'package:yaml_map/src/formatter/type_formatter.dart';

/// A utility class providing methods for formatting Dart [Map] and its content
/// to YAML dictionary.
///
/// Supported Dart types:
/// - [num],
/// - [String] (must to not contain ' and " simultaneously),
/// - [DateTime] (converted to ISO 8601 string in UTC),
/// - [List],
/// - [Map] (only keys of type String are allowed so the resulting type is
///   Map<String, dynamic>)
///
/// Example:
/// ```dart
///   const formatter = YamlMapFormatter();
///   final map = <String, dynamic>{'field': 'value'};
///   final yamlString = formatter.format(map);
///   assert(yamlString == "field: 'value'\n");
/// ```
class YamlMapFormatter {
  static const int defaultSpacesPerIndentationLevel = 2;

  /// The one-level YAML block indents within resulting string.
  ///
  /// Defaults to [defaultSpacesPerIndentationLevel].
  final int spacesPerIndentationLevel;

  /// Formatters for supported types.
  final List<TypeFormatter> _formatters = [
    NumTypeFormatter(),
    StringTypeFormatter(),
    DateTimeTypeFormatter(),
  ];

  YamlMapFormatter({
    this.spacesPerIndentationLevel = defaultSpacesPerIndentationLevel,
  }) {
    _formatters.addAll([
      ListTypeFormatter(spacesPerIndentationLevel, _format),
      MapTypeFormatter(spacesPerIndentationLevel, _format),
    ]);
  }

  /// Formats [map] to the YAML format.
  String format(Map<String, dynamic> map) {
    if (map == null) {
      throw ArgumentError('Map is not allowed to be null');
    }

    final buffer = StringBuffer();
    if (map.isNotEmpty) {
      _format(map, buffer, 0);
      buffer.write('\n');
    }
    return buffer.toString();
  }

  /// Delegates formatting to specialized formatters depending on [value]'s type.
  void _format(dynamic value, StringBuffer buffer, int indentationLevel) {
    final formatter = _formatters.firstWhere(
      (formatter) => formatter.canFormat(value),
      orElse: () => null,
    );

    if (formatter == null) {
      throw FormatException('Unsupported value type: ${value.runtimeType}');
    } else {
      formatter.format(value, buffer, indentationLevel);
    }
  }
}
