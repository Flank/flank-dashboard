// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:yaml_map/src/formatter/type_formatter.dart';

class NumTypeFormatter extends TypeFormatter<num> {
  /// Formats [num] into the YAML format.
  @override
  void format(num value, StringBuffer buffer, int indentationLevel) {
    buffer.write('$value');
  }
}
