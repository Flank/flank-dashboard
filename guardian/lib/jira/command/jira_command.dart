// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/jira/model/jira_config.dart';
import 'package:guardian/runner/command/guardian_command.dart';

abstract class JiraCommand extends GuardianCommand {
  @override
  String get configurationsFilename => JiraConfig().filename;

  @override
  JiraConfig get config => JiraConfig()..readFromMap(loadConfigurations());
}
