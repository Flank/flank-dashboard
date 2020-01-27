import 'package:guardian/runner/command/guardian_command.dart';
import 'package:guardian/slack/model/slack_config.dart';

abstract class SlackCommand extends GuardianCommand {
  @override
  String get configurationsFilename => SlackConfig().filename;

  @override
  SlackConfig get config => SlackConfig()..readFromMap(loadConfigurations());
}
