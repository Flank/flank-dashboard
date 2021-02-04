// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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
