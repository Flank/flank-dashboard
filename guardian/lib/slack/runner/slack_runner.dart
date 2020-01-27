import 'package:args/command_runner.dart';
import 'package:guardian/slack/command/message_command.dart';
import 'package:guardian/slack/command/slack_config_command.dart';

class SlackRunner extends Command {
  @override
  String get description => 'Slack integration';

  @override
  String get name => 'slack';

  SlackRunner() {
    addSubcommand(MessageCommand());
    addSubcommand(SlackConfigCommand());
  }
}
