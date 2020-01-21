import 'package:args/command_runner.dart';

class CloseTicketCommand extends Command {
  @override
  String get name => 'close';

  @override
  String get description => 'Closes Jira issue';
}
