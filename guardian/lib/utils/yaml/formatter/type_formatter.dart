abstract class TypeFormatter<T> {
  void format(
    T value,
    StringBuffer buffer,
    int indentationLevel,
  );

  bool canFormat(dynamic value) {
    return value is T;
  }
}

abstract class IterableTypeFormatter<T> extends TypeFormatter<T> {
  final int spacesPerIndentationLevel;

  final void Function(dynamic, StringBuffer, int) delegateCallback;

  IterableTypeFormatter(this.spacesPerIndentationLevel, this.delegateCallback) {
    if (spacesPerIndentationLevel == null || delegateCallback == null) {
      throw AssertionError(
        'spacesPerIndentationLevel and itemFormatCallback cannot be null',
      );
    }
  }
}
