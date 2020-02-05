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
  final XmlAttributeValueParseCallback<T> _parseCallback;

  /// A parser for optional values of type [T].
  ///
  /// Usually returns `null` if parsing fails.
  final XmlAttributeValueParseCallback<T> _tryParseCallback;

  XmlAttributeValueParser(this._parseCallback, this._tryParseCallback);

  /// Parses required value.
  @nonVirtual
  T parse(String value) {
    return _parseCallback?.call(value);
  }

  /// Parses optional value.
  @nonVirtual
  T tryParse(String value) {
    return value != null ? _tryParseCallback?.call(value) : null;
  }

  /// Validates whether value can be parsed or not.
  @nonVirtual
  bool canParse(String value) {
    return tryParse(value) != null;
  }
}

/// An attribute value parser for [String] values.
class StringAttributeValueParser extends XmlAttributeValueParser<String> {
  StringAttributeValueParser() : super(parseString, (value) => value);

  /// Parses [value] into [String].
  ///
  /// This method allows to match [int.parse], [DateTime.parse], etc. behavior
  /// which throw [FormatException] on invalid input.
  /// `null` value is assumed to be invalid.
  @visibleForTesting
  static String parseString(String value) {
    if (value != null) {
      return value;
    } else {
      throw const FormatException('Cannot parse null String value');
    }
  }
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

/// An attribute value parser for [bool] values.
class BoolAttributeValueParser extends XmlAttributeValueParser<bool> {
  BoolAttributeValueParser() : super(parseBool, tryParseBool);

  /// Parses [value] into [bool].
  ///
  /// Throws [FormatException] if the source string cannot be parsed.
  @visibleForTesting
  static bool parseBool(String value) {
    if (value == null) {
      throw const FormatException('Cannot parse null string value to bool');
    }

    final _value = value.trim().toLowerCase();
    if (_value != 'true' && _value != 'false') {
      throw FormatException('Failed to parse $value into bool');
    }

    return _value == 'true';
  }

  /// Parses [value] into [bool].
  ///
  /// Works like [parseBool] except that this function returns `null`
  /// where [parseBool] would throw a [FormatException].
  @visibleForTesting
  static bool tryParseBool(String value) {
    try {
      return parseBool(value);
    } catch (e) {
      return null;
    }
  }
}
