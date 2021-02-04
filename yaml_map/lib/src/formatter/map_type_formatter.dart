// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.


import 'package:yaml_map/src/formatter/type_formatter.dart';

class MapTypeFormatter extends IterableTypeFormatter<Map<String, dynamic>> {
  MapTypeFormatter(int spacesPerIndentationLevel,
      void Function(dynamic, StringBuffer, int) delegateCallback)
      : super(
          spacesPerIndentationLevel,
          delegateCallback,
        );

  /// Formats [Map] into the YAML format.
  @override
  void format(
    Map<String, dynamic> value,
    StringBuffer buffer,
    int indentationLevel,
  ) {
    if (indentationLevel > 0) {
      buffer.write('\n');
    }

    for (var i = 0; i < value.length; i++) {
      final _key = value.keys.elementAt(i);
      final _value = value.values.elementAt(i);
      if (indentationLevel > 0) {
        buffer.write(' ' * spacesPerIndentationLevel * indentationLevel);
      }

      buffer.write('$_key: ');
      delegateCallback(_value, buffer, indentationLevel + 1);

      if (i != value.length - 1) {
        buffer.write('\n');
      }
    }
  }
}
