import 'package:guardian/utils/yaml/formatter/type_formatter.dart';

class MapTypeFormatter extends IterableTypeFormatter<Map<String, dynamic>> {
  MapTypeFormatter(int spacesPerIndentationLevel,
      void Function(dynamic, StringBuffer, int) delegateCallback)
      : super(
          spacesPerIndentationLevel,
          delegateCallback,
        );

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
