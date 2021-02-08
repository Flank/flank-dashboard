// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/slack/model/slack_markdown_text_object.dart';
import 'package:guardian/slack/model/slack_plain_text_object.dart';
import 'package:guardian/slack/model/slack_section_block.dart';
import 'package:test/test.dart';

void main() {
  group('SlackSectionBlock', () {
    const sectionBlock = SlackSectionBlock(
      text: SlackPlainTextObject(text: 'test'),
      fields: [
        SlackMarkdownTextObject(text: 'test'),
        SlackMarkdownTextObject(text: 'test'),
      ],
    );
    const sectionBlockMap = {
      'type': 'section',
      'text': {
        'type': 'plain_text',
        'text': 'test',
      },
      'fields': [
        {
          'type': 'mrkdwn',
          'text': 'test',
        },
        {
          'type': 'mrkdwn',
          'text': 'test',
        }
      ],
    };

    test(
      "toJson() returns a map with non-null properties of section block",
      () {
        final map = sectionBlock.toJson();

        expect(map, equals(sectionBlockMap));
      },
    );

    test("fromJson() returns null if decoded map is null", () {
      final result = SlackSectionBlock.fromJson(null);

      expect(result, isNull);
    });

    test("fromJson() converts a map to section block", () {
      final result = SlackSectionBlock.fromJson(sectionBlockMap);

      expect(result, equals(sectionBlock));
    });

    test("listFromJson() maps an empty list as empty", () {
      final result = SlackSectionBlock.listFromJson([]);

      expect(result, isEmpty);
    });

    test(
      "listFromJson() maps a list of decoded JSON objects to list of section blocks",
      () {
        const list = [sectionBlockMap, sectionBlockMap];
        const expected = [sectionBlock, sectionBlock];
        final result = SlackSectionBlock.listFromJson(list);

        expect(result, equals(expected));
      },
    );

    test(
      "validate() returns false on both text and fields missing",
      () {
        const sectionBlock = SlackSectionBlock();
        final result = sectionBlock.validate();

        expect(result.isValid, isFalse);
      },
    );

    test(
      "validate() returns false on text with length out of limit",
      () {
        final sectionBlock = SlackSectionBlock(
          text: SlackPlainTextObject(text: '1' * 3001),
        );
        final result = sectionBlock.validate();

        expect(result.isValid, isFalse);
      },
    );

    test(
      "validate() returns false if there are more than 10 fields",
      () {
        final sectionBlock = SlackSectionBlock(
          fields: List.generate(
            11,
            (_) => const SlackPlainTextObject(text: 'test'),
          ),
        );
        final result = sectionBlock.validate();

        expect(result.isValid, isFalse);
      },
    );

    test(
      "validate() returns false if at least one field contains text with length out of limit",
      () {
        final sectionBlock = SlackSectionBlock(
          fields: [
            const SlackMarkdownTextObject(text: 'test'),
            SlackMarkdownTextObject(text: '1' * 2001),
          ],
        );
        final result = sectionBlock.validate();

        expect(result.isValid, isFalse);
      },
    );

    test(
      "validate() validates result with false if one of presented text and fields is invalid",
      () {
        const sectionBlock = SlackSectionBlock(
          text: SlackMarkdownTextObject(text: 'test'),
          fields: [
            SlackMarkdownTextObject(text: 'test'),
            SlackMarkdownTextObject(text: ''),
          ],
        );
        final result = sectionBlock.validate();

        expect(result.isValid, isFalse);
      },
    );

    test(
      "validate() validates section block",
      () {
        const sectionBlock = SlackSectionBlock(
          text: SlackMarkdownTextObject(text: 'test'),
          fields: [
            SlackMarkdownTextObject(text: '*Field*'),
            SlackPlainTextObject(text: 'Field'),
          ],
        );
        final result = sectionBlock.validate();

        expect(result.isValid, isTrue);
      },
    );
  });
}
