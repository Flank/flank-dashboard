import 'package:guardian/utils/yaml/formatter/type_formatter.dart';

class StringTypeFormatter extends TypeFormatter<String> {
  /// Formats [String] into the YAML format.
  ///
  /// Throws [FormatException] if [value] contains both ' and " quotes symbols.
  @override
  void format(String value, StringBuffer buffer, int indentationLevel) {
    final containsQuote = value?.contains('\'') ?? false;
    final containsDoubleQuote = value?.contains('\"') ?? false;

    if (containsQuote && containsDoubleQuote) {
      throw const FormatException(
        'String cannot contain \' and \" simultaneously',
      );
    } else if (containsQuote) {
      buffer.write('"$value"');
    } else {
      buffer.write("'$value'");
    }
  }
}
