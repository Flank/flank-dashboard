import 'dart:io';

import 'package:guardian/slack/client/slack_webhook_client.dart';
import 'package:guardian/slack/command/slack_command.dart';
import 'package:guardian/slack/model/slack_message.dart';

class MessageCommand extends SlackCommand {
  @override
  String get name => 'message';

  @override
  String get description => 'Sends message to the Slack';

  MessageCommand() {
    addConfigOptionByNames(['webhookUrl']);
  }

  @override
  Future<void> run() async {
    final url = argResults['webhookUrl'] as String;

    if (url == null || url.isEmpty) {
      print('Webhook URL is required');
      return;
    }

    stdout.writeln('\nMessage body: ');
    final body = stdin.readLineSync();

    final slack = SlackWebhookClient(webhookUrl: url);

    final message = SlackMessage(text: body);

    final result = await slack.sendMessage(message);

    stdout.writeln(result.message);

    slack.close();
  }
}
