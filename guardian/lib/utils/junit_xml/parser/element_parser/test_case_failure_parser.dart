part of junit_xml;

/// A [JUnitTestCaseFailure] node parser.
class TestCaseFailureParser extends XmlElementParser<JUnitTestCaseFailure> {
  @override
  String get elementName => 'failure';

  @override
  JUnitTestCaseFailure mapElement(xml.XmlElement xmlElement) {
    return JUnitTestCaseFailure(text: xmlElement.text);
  }
}
