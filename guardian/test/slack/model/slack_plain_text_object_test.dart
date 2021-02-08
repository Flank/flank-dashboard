// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/slack/model/slack_plain_text_object.dart';
import 'package:test/test.dart';

void main() {
  group('SlackPlainTextObject', () {
    const plainTextObject = SlackPlainTextObject(text: 'test');
    const plainTextObjectMap = {'type': 'plain_text', 'text': 'test'};

    test(
      "toJson() returns a map with non-null properties of text object",
      () {
        final map = plainTextObject.toJson();

        expect(map, equals(plainTextObjectMap));
      },
    );

    test(
      "toJson() includes the emoji property to map if not null",
      () {
        const plainTextObject = SlackPlainTextObject(
          text: 'test',
          emoji: true,
        );
        final map = plainTextObject.toJson();

        expect(map, containsPair('emoji', true));
      },
    );

    test("fromJson() returns null if decoded map is null", () {
      final result = SlackPlainTextObject.fromJson(null);

      expect(result, isNull);
    });

    test("fromJson() converts a map to text object", () {
      final result = SlackPlainTextObject.fromJson(plainTextObjectMap);

      expect(result, equals(plainTextObject));
    });
  });
}
