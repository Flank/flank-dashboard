// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:yaml_map/src/formatter/type_formatter.dart';

class DateTimeTypeFormatter extends TypeFormatter<DateTime> {
  /// Formats [DateTime] into the YAML format. Converts
  ///
  /// Converts [value] to ISO 8601 string in UTC.
  @override
  void format(DateTime value, StringBuffer buffer, int indentationLevel) {
    buffer.write("'${value?.toUtc()?.toIso8601String()}'");
  }
}
