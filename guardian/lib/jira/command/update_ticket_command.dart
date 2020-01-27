import 'package:args/command_runner.dart';

class UpdateTicketCommand extends Command {
  @override
  String get name => 'update';

  @override
  String get description => 'Updates Jira issue';
}
