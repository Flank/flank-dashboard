// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/slack/model/slack_markdown_text_object.dart';
import 'package:guardian/slack/model/slack_plain_text_object.dart';
import 'package:guardian/slack/model/slack_text_object.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void main() {
  group('SlackTextObject', () {
    test("fromJson() returns null if decoded map is null", () {
      final result = SlackTextObject.fromJson(null);

      expect(result, isNull);
    });

    test(
      "fromJson() maps decoded JSON as SlackPlainTextObject if type property is plain_text",
      () {
        const map = {'type': 'plain_text'};
        final result = SlackTextObject.fromJson(map);

        expect(result, isA<SlackPlainTextObject>());
      },
    );

    test(
      "fromJson() maps decoded JSON as SlackMarkdownTextObject if type property is mrkdwn",
      () {
        const map = {'type': 'mrkdwn'};
        final result = SlackTextObject.fromJson(map);

        expect(result, isA<SlackMarkdownTextObject>());
      },
    );

    test("listFromJson() maps an empty list as empty", () {
      final result = SlackTextObject.listFromJson([]);

      expect(result, isEmpty);
    });

    test(
      "listFromJson() maps a list of decoded JSON objects to list of section blocks",
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

    test("validate() returns false if text is null", () {
      const textObject = SlackTextObjectTestbed(null);
      final result = textObject.validate();

      expect(result.isValid, isFalse);
    });

    test("validate() returns false if text is empty", () {
      const textObject = SlackTextObjectTestbed('');
      final result = textObject.validate();

      expect(result.isValid, isFalse);
    });

    test(
      "validate() returns false if text length is out of limits",
      () {
        const textObject = SlackTextObjectTestbed('test message');
        final result = textObject.validate(4);

        expect(result.isValid, isFalse);
      },
    );

    test(
      "validate() returns true on non-null text when maxLength is null",
      () {
        const textObject = SlackTextObjectTestbed('test');
        final result = textObject.validate();

        expect(result.isValid, isTrue);
      },
    );

    test(
      "validate() returns true on valid text",
      () {
        const textObject = SlackTextObjectTestbed('test');
        final result = textObject.validate(10);

        expect(result.isValid, isTrue);
      },
    );

    test("two instances with equal fields are identical", () {
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
