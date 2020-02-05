import 'package:guardian/utils/junit_xml/junit_xml.dart';

import '../test_utils/xml_element_text_parser_group.dart';

void main() {
  xmlElementTextParserGroup<JUnitTestCaseSkipped>(
    'TestCaseSkippedParser',
    'skipped',
    () => TestCaseSkippedParser(),
    (text) => JUnitTestCaseSkipped(text: text),
  );
}
