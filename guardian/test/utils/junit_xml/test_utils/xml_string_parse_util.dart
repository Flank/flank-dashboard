import 'package:xml/xml.dart';

/// A class that provides method for parsing XML string into [XmlElement].
class XmlStringParseUtil {
  /// Parses [xmlString].
  ///
  /// Returns [XmlDocument.rootElement] of given XML document.
  static XmlElement parseXml(String xmlString) {
    return parse(xmlString).rootElement;
  }
}
