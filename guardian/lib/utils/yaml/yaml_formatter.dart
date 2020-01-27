class YamlFormatter {
  final int indentationLength;

  const YamlFormatter({
    this.indentationLength = 2,
  });

  String format(dynamic value) {
    final buffer = StringBuffer();
    _format(value, buffer, 0);
    return buffer.toString();
  }

  void _format(
    dynamic value,
    StringBuffer buffer,
    int indentationLevel, [
    bool forceNewRow = false,
  ]) {
    if (forceNewRow) {
      buffer.write('\n');
    }

    if (value is Map) {
      for (var i = 0; i < value.length; i++) {
        final _key = value.keys.elementAt(i);
        final _value = value.values.elementAt(i);
        if (forceNewRow) {
          buffer.write(' ' * indentationLength * indentationLevel);
        }

        buffer.write('$_key: ');
        _format(_value, buffer, indentationLevel + 1, _value is Map);
        if (i != value.length - 1) {
          buffer.write('\n');
        }
      }
    } else if (value is List) {
      buffer.write('\n');

      for (var i = 0; i < value.length; i++) {
        buffer.write(' ' * indentationLength * indentationLevel);
        buffer.write('- ');
        _format(value[i], buffer, indentationLevel + 1);

        if (i != value.length - 1) {
          buffer.write('\n');
        }
      }
    } else if (value is String) {
      buffer.write("'$value'");
    } else {
      buffer.write(value.toString());
    }
  }
}
