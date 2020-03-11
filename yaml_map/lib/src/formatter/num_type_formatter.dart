import 'package:yaml_map/src/formatter/type_formatter.dart';

class NumTypeFormatter extends TypeFormatter<num> {
  /// Formats [num] into the YAML format.
  @override
  void format(num value, StringBuffer buffer, int indentationLevel) {
    buffer.write('$value');
  }
}
