import 'package:xml/xml.dart';

class XmlStringParseUtil {
  static XmlElement parseXml(String xmlString) {
    return parse(xmlString).rootElement;
  }
}
