import 'package:args/command_runner.dart';
import 'package:guardian/jira/command/close_ticket_command.dart';
import 'package:guardian/jira/command/jia_config_command.dart';
import 'package:guardian/jira/command/open_ticket_command.dart';
import 'package:guardian/jira/command/update_ticket_command.dart';

class JiraRunner extends Command {
  @override
  String get description => 'Jira integration';

  @override
  String get name => 'jira';

  JiraRunner() {
    addSubcommand(OpenTicketCommand());
    addSubcommand(UpdateTicketCommand());
    addSubcommand(CloseTicketCommand());
    addSubcommand(JiraConfigCommand());
  }
}
