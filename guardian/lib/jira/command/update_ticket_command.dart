import 'package:guardian/jira/command/jira_command.dart';

class UpdateTicketCommand extends JiraCommand {
  @override
  String get name => 'update';

  @override
  String get description => 'Updates Jira issue';
}
