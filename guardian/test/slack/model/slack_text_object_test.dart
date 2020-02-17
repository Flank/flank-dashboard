import 'package:guardian/slack/model/slack_text_object.dart';
import 'package:test/test.dart';

void main() {
  group('SlackTextObject', () {
    test('fromJson() should return null if decoded map is null', () {
      final result = SlackTextObject.fromJson(null);

      expect(result, isNull);
    });

    test(
      'fromJson() should map decoded JSON as SlackPlainTextObject '
      'if type property is plain_text',
      () {
        const map = {'type': 'plain_text'};
        final result = SlackTextObject.fromJson(map);

        expect(result, isA<SlackPlainTextObject>());
      },
    );

    test(
      'fromJson() should map decoded JSON as SlackMarkdownTextObject '
      'if type property is markdwn',
      () {
        const map = {'type': 'mrkdwn'};
        final result = SlackTextObject.fromJson(map);

        expect(result, isA<SlackMarkdownTextObject>());
      },
    );

    test('listFromJson() should map empty list as empty', () {
      final result = SlackTextObject.listFromJson([]);

      expect(result, isEmpty);
    });

    test(
      'listFromJson() should map list of decoded JSON objects to list '
      'of section blocks',
      () {
        const list = [
          {'type': 'plain_text', 'text': 'test'},
          {'type': 'mrkdwn', 'text': 'test'}
        ];
        const expected = [
          SlackPlainTextObject(text: 'test'),
          SlackMarkdownTextObject(text: 'test'),
        ];
        final result = SlackTextObject.listFromJson(list);

        expect(result, equals(expected));
      },
    );
  });

  group('SlackPlainTextObject', () {
    const plainTextObject = SlackPlainTextObject(text: 'test');
    const plainTextObjectMap = {'type': 'plain_text', 'text': 'test'};

    test(
      'toJson() should return map with non-null properties of text object',
      () {
        final map = plainTextObject.toJson();

        expect(map, equals(plainTextObjectMap));
      },
    );

    test('fromJson() should return null if decoded map is null', () {
      final result = SlackPlainTextObject.fromJson(null);

      expect(result, isNull);
    });

    test('fromJson() should convert map to text object', () {
      final result = SlackPlainTextObject.fromJson(plainTextObjectMap);

      expect(result, equals(plainTextObject));
    });
  });

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
