part of junit_xml;

/// A [JUnitTestCaseSkipped] node parser.
class TestCaseSkippedParser extends XmlElementParser<JUnitTestCaseSkipped> {
  @override
  String get elementName => 'skipped';

  @override
  JUnitTestCaseSkipped mapElement(xml.XmlElement xmlElement) {
    return JUnitTestCaseSkipped(text: xmlElement.text);
  }
}
