import 'package:args/command_runner.dart';
import 'package:guardian/slack/model/slack_message.dart';
import 'package:slack/io/slack.dart';

class MessageCommand extends Command {
  @override
  String get name => 'message';

  @override
  String get description => 'Sends message to the Slack';

  MessageCommand() {
    argParser.addOption('body');
    argParser.addOption('url');
  }

  @override
  void run() {
    final message = SlackMessage.fromArgs(argResults);
    if (message == null || message.url == null) {
      print('Webhook URL is required');
      return;
    }

    final slack = Slack(message.url);
    slack.send(Message(
      message.body,
      username: 'Guardian',
    ));
  }
}
