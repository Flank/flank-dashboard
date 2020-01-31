part of junit_xml;

class TestCaseErrorParser extends XmlElementParser<JUnitTestCaseError> {
  @override
  String get elementName => 'error';

  @override
  JUnitTestCaseError _parse(xml.XmlElement xmlElement) {
    return JUnitTestCaseError(
      text: xmlElement.text,
    );
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    return true;
  }
}

class TestCaseFailureParser extends XmlElementParser<JUnitTestCaseFailure> {
  @override
  String get elementName => 'failure';

  @override
  JUnitTestCaseFailure _parse(xml.XmlElement xmlElement) {
    return JUnitTestCaseFailure(
      text: xmlElement.text,
    );
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    return true;
  }
}

class TestCaseSkippedParser extends XmlElementParser<JUnitTestCaseSkipped> {
  @override
  String get elementName => 'skipped';

  @override
  JUnitTestCaseSkipped _parse(xml.XmlElement xmlElement) {
    return JUnitTestCaseSkipped(
      text: xmlElement.text,
    );
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    return true;
  }
}
