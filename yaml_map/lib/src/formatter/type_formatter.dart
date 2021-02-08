// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:yaml_map/src/yaml_map_formatter.dart';

/// A formatter abstract class that defines format method for specified type [T]
///
/// Used by [YamlMapFormatter] in order to delegate formatting.
abstract class TypeFormatter<T> {
  /// Formats value of type [T] into YAML.
  void format(
    T value,
    StringBuffer buffer,
    int indentationLevel,
  );

  /// Checks whether formatter is able to format [value].
  bool canFormat(dynamic value) {
    return value is T;
  }
}

/// A formatter abstract class that defines format method for
/// iterable-like type [T] (such as [Map] and [List]).
///
/// Both [spacesPerIndentationLevel] and [delegateCallback] cannot be null.
/// Otherwise, throws [AssertionError].
abstract class IterableTypeFormatter<T> extends TypeFormatter<T> {
  /// Similar to [YamlMapFormatter.spacesPerIndentationLevel].
  final int spacesPerIndentationLevel;

  /// The callback to invoke delegator for values of [T].
  final void Function(dynamic, StringBuffer, int) delegateCallback;

  IterableTypeFormatter(this.spacesPerIndentationLevel, this.delegateCallback) {
    if (spacesPerIndentationLevel == null || delegateCallback == null) {
      throw AssertionError(
        'spacesPerIndentationLevel and itemFormatCallback cannot be null',
      );
    }
  }
}
