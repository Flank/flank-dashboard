import 'package:guardian/slack/model/slack_markdown_text_object.dart';
import 'package:guardian/slack/model/slack_plain_text_object.dart';
import 'package:guardian/slack/model/slack_text_object.dart';
import 'package:meta/meta.dart';
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

    test('validate() should result with false if text is null', () {
      const textObject = SlackTextObjectTestbed(null);
      final result = textObject.validate();

      expect(result.isValid, isFalse);
    });

    test('validate() should result with false if text is empty', () {
      const textObject = SlackTextObjectTestbed('');
      final result = textObject.validate();

      expect(result.isValid, isFalse);
    });

    test(
      'validate() should result with true on valid text, but with maxLength is null',
          () {
        const textObject = SlackTextObjectTestbed('test');
        final result = textObject.validate();

        expect(result.isValid, isTrue);
      },
    );

    test(
      'validate() should result with false if text length is out of limits',
      () {
        const textObject = SlackTextObjectTestbed('test message');
        final result = textObject.validate(4);

        expect(result.isValid, isFalse);
      },
    );

    test(
      'validate() should result with true on valid text',
      () {
        const textObject = SlackTextObjectTestbed('test');
        final result = textObject.validate(10);

        expect(result.isValid, isTrue);
      },
    );

    test("Two identical instances of SlackTextObject are equals", () {
      const map = {'type': 'mrkdwn'};
      final firstTextObject = SlackTextObject.fromJson(map);
      final secondTextObject = SlackTextObject.fromJson(map);

      expect(firstTextObject, equals(secondTextObject));
    });
  });
}

/// A testbed class for abstract [SlackTextObject]. Allows to test [nonVirtual]
/// validation.
class SlackTextObjectTestbed extends SlackTextObject {
  const SlackTextObjectTestbed(String text) : super(text);
}
