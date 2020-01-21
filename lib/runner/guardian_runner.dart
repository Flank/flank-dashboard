import 'package:args/command_runner.dart';
import 'package:guardian/slack/runner/slack_runner.dart';

class GuardianRunner extends CommandRunner {
  GuardianRunner() : super('guardian', 'Guardian CLI') {
    addCommand(SlackRunner());
  }
}
