import 'package:guardian/config/model/config.dart';
import 'package:guardian/config/runner/config_runner.dart';
import 'package:guardian/slack/model/slack_config.dart';

class SlackConfigCommand extends ConfigRunner {
  @override
  String get description => 'Manages Slack configs stored locally';

  @override
  Config configFactory() {
    return SlackConfig();
  }
}
