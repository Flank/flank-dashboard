// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/jira/command/jira_command.dart';

class CloseTicketCommand extends JiraCommand {
  @override
  String get name => 'close';

  @override
  String get description => 'Closes Jira issue';
}
