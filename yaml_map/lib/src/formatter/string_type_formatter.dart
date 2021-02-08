// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:yaml_map/src/formatter/type_formatter.dart';

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
