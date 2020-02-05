import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

import 'xml_string_parse_util.dart';

void xmlElementTextParserGroup<T>(
  String description,
  String elementName,
  XmlElementParser<T> Function() parserFactory,
  T Function(String text) junitObjectFactory, [
  void Function(XmlElementParser<T> parser) body,
]) {
  group(description, () {
    final parser = parserFactory();

    test('parse() should parse <$elementName> node text', () {
      final xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <$elementName>Random text</$elementName>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = parser.parse(xmlElement);

      final expected = junitObjectFactory('Random text');
      expect(result, equals(expected));
    });

    test(
      'parse() should parse empty <$elementName> node text as empty',
      () {
        final xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <$elementName/>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        final result = parser.parse(xmlElement);

        final expected = junitObjectFactory('');
        expect(result, equals(expected));
      },
    );

    body?.call(parser);
  });
}
