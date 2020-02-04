import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('JUnitXmlParser', () {
    const parser = JUnitXmlParser();

    test('parse() should throw ArgumentError on null input', () {
      expect(() => parser.parse(null), throwsArgumentError);
    });

    test('parse() should throw XmlException on empty XML string', () {
      const emptyXml = '';
      expect(() => parser.parse(emptyXml), throwsA(isA<XmlException>()));
    });

    test(
      'parse() should throw XmlException on XML string with no root element',
      () {
        const noRootXml = "<?xml version='1.0' encoding='UTF-8' ?>";
        expect(() => parser.parse(noRootXml), throwsA(isA<XmlException>()));
      },
    );

    test(
      'parse() should throw XmlException on XML string with two root elements',
      () {
        const twoRootXml = '''
          <?xml version='1.0' encoding='UTF-8' ?>
          <node></node>
          <node></node>
        ''';
        expect(() => parser.parse(twoRootXml), throwsA(isA<XmlException>()));
      },
    );

    test('parse() should throw ArgumentError on not JUnitXML input', () {
      const randomXml = '''
        <?xml version='1.0' encoding='UTF-8' ?>
        <node></node>
      ''';
      expect(() => parser.parse(randomXml), throwsArgumentError);
    });

    test(
      'parse() should throw FormatException on '
      'invalid JUnitXML report',
      () {
        const missedTestSuiteAttributesXml = '''
          <?xml version='1.0' encoding='UTF-8' ?>
          <testsuite>
          </testsuite>
        ''';

        expect(
          () => parser.parse(missedTestSuiteAttributesXml),
          throwsFormatException,
        );
      },
    );
  });
}
