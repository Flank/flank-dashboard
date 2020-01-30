import 'package:guardian/utils/yaml/formatter/type_formatter.dart';

class NumTypeFormatter extends TypeFormatter<num> {
  /// Formats [num] into the YAML format.
  @override
  void format(num value, StringBuffer buffer, int indentationLevel) {
    buffer.write('$value');
  }
}
