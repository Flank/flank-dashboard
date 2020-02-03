part of junit_xml;

typedef XmlAttributeValueParseCallback<T> = T Function(String);

/// An attribute value parser abstract class that defines parse method for
/// specified type [T].
///
/// May be used by [XmlElementParser] implementations in order to parse
/// attribute values.
abstract class XmlAttributeValueParser<T> {
  /// A parser for required values of type [T].
  ///
  /// Usually throws if parsing fails.
  final XmlAttributeValueParseCallback<T> parseCallback;

  /// A parser for optional values of type [T].
  ///
  /// Usually returns null if parsing fails.
  final XmlAttributeValueParseCallback<T> tryParseCallback;

  XmlAttributeValueParser(this.parseCallback, this.tryParseCallback);

  /// Parses required value.
  T parse(String value) {
    return parseCallback?.call(value);
  }

  /// Parses optional value.
  T tryParse(String value) {
    return value != null ? tryParseCallback?.call(value) : null;
  }

  /// Validates whether value can be parsed or not.
  bool canParse(String value) {
    return tryParse(value) != null;
  }
}

/// An attribute value parser for [String] values.
class StringAttributeValueParser extends XmlAttributeValueParser<String> {
  StringAttributeValueParser() : super((value) => value, (value) => value);
}

/// An attribute value parser for [int] values.
class IntAttributeValueParser extends XmlAttributeValueParser<int> {
  IntAttributeValueParser() : super(int.parse, int.tryParse);
}

/// An attribute value parser for [double] values.
class DoubleAttributeValueParser extends XmlAttributeValueParser<double> {
  DoubleAttributeValueParser() : super(double.parse, double.tryParse);
}

/// An attribute value parser for [DateTime] values.
class DateTimeAttributeValueParser extends XmlAttributeValueParser<DateTime> {
  DateTimeAttributeValueParser() : super(DateTime.parse, DateTime.tryParse);
}
