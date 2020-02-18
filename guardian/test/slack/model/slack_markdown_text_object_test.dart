import 'package:guardian/slack/model/slack_markdown_text_object.dart';
import 'package:test/test.dart';

void main() {
  group('SlackMarkdownTextObject', () {
    const markdownTextObject = SlackMarkdownTextObject(text: 'test');
    const markdownTextObjectMap = {'type': 'mrkdwn', 'text': 'test'};

    test(
      'toJson() should return map with non-null properties of text object',
      () {
        final map = markdownTextObject.toJson();

        expect(map, equals(markdownTextObjectMap));
      },
    );

    test(
      'toJson() should include the verbatim property to map if not null',
      () {
        const markdownTextObject = SlackMarkdownTextObject(
          text: 'test',
          verbatim: true,
        );
        final map = markdownTextObject.toJson();

        expect(map, containsPair('verbatim', true));
      },
    );

    test('fromJson() should return null if decoded map is null', () {
      final result = SlackMarkdownTextObject.fromJson(null);

      expect(result, isNull);
    });

    test('fromJson() should convert map to text object', () {
      final result = SlackMarkdownTextObject.fromJson(markdownTextObjectMap);

      expect(result, equals(markdownTextObject));
    });
  });
}
