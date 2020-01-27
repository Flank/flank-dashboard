import 'package:guardian/jira/model/jira_config.dart';
import 'package:guardian/runner/command/guardian_command.dart';

abstract class JiraCommand extends GuardianCommand {
  @override
  String get configurationsFilename => JiraConfig().filename;

  @override
  JiraConfig get config => JiraConfig()..readFromMap(loadConfigurations());
}
