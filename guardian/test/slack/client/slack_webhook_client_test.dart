// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/slack/client/slack_webhook_client.dart';
import 'package:guardian/slack/model/slack_markdown_text_object.dart';
import 'package:guardian/slack/model/slack_message.dart';
import 'package:guardian/slack/model/slack_section_block.dart';
import 'package:test/test.dart';

import '../test_utils/mock_server/slack_mock_server.dart';

void main() {
  group('SlackWebhookClient', () {
    SlackWebhookClient slackClient;
    final slackMockServer = SlackMockServer();

    setUpAll(() async {
      await slackMockServer.init();
      slackClient = SlackWebhookClient(
        webhookUrl: '${slackMockServer.url}/services/test/test/test',
      );
    });

    tearDownAll(() async {
      await slackMockServer.close();
      slackClient.close();
    });

    test(
      "throws an ArgumentError if the given webhook URL is null",
      () {
        const String webhookUrl = null;

        expect(
          () => SlackWebhookClient(webhookUrl: webhookUrl),
          throwsArgumentError,
        );
      },
    );

    test("sendMessage() returns an error on null message", () {
      final result =
          slackClient.sendMessage(null).then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test("sendMessage() returns an error on empty message", () {
      const message = SlackMessage(text: '');
      final result =
          slackClient.sendMessage(message).then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test("sendMessage() returns an error on invalid blocks", () {
      const message = SlackMessage(text: 'test', blocks: [
        SlackSectionBlock(),
      ]);

      final result =
          slackClient.sendMessage(message).then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test("sendMessage() returns a success on valid message", () {
      const message = SlackMessage(text: 'test', blocks: [
        SlackSectionBlock(
          text: SlackMarkdownTextObject(text: 'test'),
        ),
      ]);
      final result =
          slackClient.sendMessage(message).then((result) => result.isSuccess);

      expect(result, completion(isTrue));
    });
  });
}
