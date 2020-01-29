import 'package:guardian/utils/yaml/formatter/type_formatter.dart';

class DateTimeTypeFormatter extends TypeFormatter<DateTime> {
  @override
  void format(DateTime value, StringBuffer buffer, int indentationLevel) {
    buffer.write("'${value?.toUtc()?.toIso8601String()}'");
  }
}
