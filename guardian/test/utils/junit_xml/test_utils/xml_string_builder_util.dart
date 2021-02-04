// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// A class that provides methods for building test XML strings.
class XmlStringBuilderUtil {
  /// Builds XML string with element with given [name] that contains only [text].
  static String textNodeXml(String name, String text) {
    return '''
      <?xml version='1.0' encoding='UTF-8'?>
      <$name>$text</$name>
    ''';
  }

  /// Builds XML string with empty self-closing root element with given [name].
  static String emptyNodeXml(String name) {
    return '''
      <?xml version='1.0' encoding='UTF-8'?>
      <$name/>
    ''';
  }

  /// Builds XML string with duplicates of element with given [name] within root
  /// element with name [rootName].
  static String duplicateNodeXml(
    String rootName,
    String name, [
    String rootAttributes = '',
  ]) {
    return '''
      <?xml version='1.0' encoding='UTF-8'?>
      <$rootName $rootAttributes>
        <$name/>
        <$name/>
      </$rootName>
    ''';
  }
}
