// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/jira/command/jira_command.dart';

class UpdateTicketCommand extends JiraCommand {
  @override
  String get name => 'update';

  @override
  String get description => 'Updates Jira issue';
}
