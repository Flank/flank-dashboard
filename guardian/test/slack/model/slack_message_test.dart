import 'package:guardian/slack/model/slack_message.dart';
import 'package:test/test.dart';

void main() {
  group('SlackMessage', () {
    test(
      'toJson() should return map with non-null properties of slack message',
      () {
        const message = SlackMessage(text: 'text');
        const expected = {'text': 'text'};
        final map = message.toJson();

        expect(map, equals(expected));
      },
    );

    test('fromJson() should return null if decoded map is null', () {
      final result = SlackMessage.fromJson(null);

      expect(result, isNull);
    });

    test('fromJson() should convert map to Slack message', () {
      const map = {'text': 'text'};
      const expected = SlackMessage(text: 'text');
      final result = SlackMessage.fromJson(map);

      expect(result, equals(expected));
    });
  });
}
