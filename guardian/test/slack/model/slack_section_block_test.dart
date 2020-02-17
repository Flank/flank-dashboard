import 'package:guardian/slack/model/slack_section_block.dart';
import 'package:guardian/slack/model/slack_text_object.dart';
import 'package:test/test.dart';

void main() {
  group('SlackSectionBlock', () {
    const sectionBlock = SlackSectionBlock(
      text: SlackPlainTextObject(text: 'test'),
    );
    const sectionBlockMap = {
      'type': 'section',
      'text': {
        'type': 'plain_text',
        'text': 'test',
      },
    };

    test(
      'toJson() should return map with non-null properties of section block',
      () {
        final map = sectionBlock.toJson();

        expect(map, equals(sectionBlockMap));
      },
    );

    test('fromJson() should return null if decoded map is null', () {
      final result = SlackSectionBlock.fromJson(null);

      expect(result, isNull);
    });

    test('fromJson() should convert map to section block', () {
      final result = SlackSectionBlock.fromJson(sectionBlockMap);

      expect(result, equals(sectionBlock));
    });

    test('listFromJson() should map empty list as empty', () {
      final result = SlackSectionBlock.listFromJson([]);

      expect(result, isEmpty);
    });

    test(
      'listFromJson() should map list of decoded JSON objects to list '
      'of section blocks',
      () {
        const list = [sectionBlockMap, sectionBlockMap];
        const expected = [sectionBlock, sectionBlock];
        final result = SlackSectionBlock.listFromJson(list);

        expect(result, equals(expected));
      },
    );
  });
}
