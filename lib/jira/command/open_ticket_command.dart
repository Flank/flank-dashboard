import 'package:args/command_runner.dart';
import 'package:guardian/jira/client/jira_client.dart';
import 'package:guardian/jira/model/jira_api_config.dart';
import 'package:guardian/jira/model/ticket_manage_request.dart';

class OpenTicketCommand extends Command {
  @override
  String get name => 'open';

  @override
  String get description => 'Opens Jira issue';

  OpenTicketCommand() {
    argParser
      ..addOption('userEmail')
      ..addOption('apiToken')
      ..addOption('basePath')
      ..addOption('projectId');
  }

  @override
  void run() {
    final config = JiraApiConfig.fromArgs(argResults);
    if (config == null) {
      print('Jira configurations are missing');
      return;
    } else if (config.nullFields.isNotEmpty) {
      print('Missing required configurations for Jira: ${config.nullFields}');
      return;
    }

    final client = JiraClient.fromConfig(config);
    final request = OpenTicketRequest.fromArgs(argResults);
    client.openIssue(request.projectId);
  }
}
