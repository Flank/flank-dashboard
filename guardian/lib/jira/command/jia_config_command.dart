import 'package:guardian/config/model/config.dart';
import 'package:guardian/config/runner/config_runner.dart';
import 'package:guardian/jira/model/jira_config.dart';

class JiraConfigCommand extends ConfigRunner {
  @override
  String get description => 'Manages Jira configs stored locally';

  @override
  Config configFactory() {
    return JiraConfig();
  }
}
