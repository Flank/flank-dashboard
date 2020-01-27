import 'package:guardian/jira/command/jira_command.dart';

class CloseTicketCommand extends JiraCommand {
  @override
  String get name => 'close';

  @override
  String get description => 'Closes Jira issue';
}
