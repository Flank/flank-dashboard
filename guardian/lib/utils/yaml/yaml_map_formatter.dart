import 'package:guardian/utils/yaml/formatter/date_time_type_formatter.dart';
import 'package:guardian/utils/yaml/formatter/list_type_formatter.dart';
import 'package:guardian/utils/yaml/formatter/map_type_formatter.dart';
import 'package:guardian/utils/yaml/formatter/num_type_formatter.dart';
import 'package:guardian/utils/yaml/formatter/string_type_formatter.dart';
import 'package:guardian/utils/yaml/formatter/type_formatter.dart';

class YamlMapFormatter {
  static const int defaultSpacesPerIndentationLevel = 2;

  final int spacesPerIndentationLevel;

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
