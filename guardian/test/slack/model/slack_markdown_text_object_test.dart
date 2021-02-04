// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/slack/model/slack_markdown_text_object.dart';
import 'package:test/test.dart';

void main() {
  group('SlackMarkdownTextObject', () {
    const markdownTextObject = SlackMarkdownTextObject(text: 'test');
    const markdownTextObjectMap = {'type': 'mrkdwn', 'text': 'test'};

    test(
      "toJson() returns a map with non-null properties of text object",
      () {
        final map = markdownTextObject.toJson();

        expect(map, equals(markdownTextObjectMap));
      },
    );

    test(
      "toJson() includes the verbatim property to the map if not null",
      () {
        const markdownTextObject = SlackMarkdownTextObject(
          text: 'test',
          verbatim: true,
        );
        final map = markdownTextObject.toJson();

        expect(map, containsPair('verbatim', true));
      },
    );

    test("fromJson() returns null if decoded map is null", () {
      final result = SlackMarkdownTextObject.fromJson(null);

      expect(result, isNull);
    });

    test("fromJson() converts a map to the text object", () {
      final result = SlackMarkdownTextObject.fromJson(markdownTextObjectMap);

      expect(result, equals(markdownTextObject));
    });
  });
}
