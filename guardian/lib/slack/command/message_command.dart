import 'dart:io';

import 'package:guardian/slack/command/slack_command.dart';
import 'package:slack/io/slack.dart';

class MessageCommand extends SlackCommand {
  @override
  String get name => 'message';

  @override
  String get description => 'Sends message to the Slack';

  MessageCommand() {
    addConfigOptionByNames([
      'webhookUrl',
    ]);
  }

  @override
  void run() {
    final url = argResults['webhookUrl'] as String;
    
    if (url == null || url.isEmpty) {
      print('Webhook URL is required');
      return;
    }

    stdout.writeln('\nMessage body: ');
    final body = stdin.readLineSync();

    final slack = Slack(url);
    slack.send(Message(
      body,
      username: 'Guardian',
    ));
  }
}
