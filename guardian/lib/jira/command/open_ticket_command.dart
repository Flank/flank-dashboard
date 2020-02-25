import 'dart:io';

import 'package:guardian/jira/client/jira_issue_client.dart';
import 'package:guardian/jira/command/jira_command.dart';
import 'package:guardian/jira/model/jira_config.dart';
import 'package:guardian/jira/model/open_ticket_request.dart';

class OpenTicketCommand extends JiraCommand {
  @override
  String get name => 'open';

  @override
  String get description => 'Opens Jira issue';

  OpenTicketCommand() {
    addConfigOptionByNames(JiraConfig().toMap().keys.toList());
    argParser.addOption('testcaseKey', help: 'Key of testcase');
  }

  @override
  Future<void> run() async {
    final config = JiraConfig()..readFromArgs(argResults);

    if (config == null) {
      stdout.writeln('Jira configurations are missing');
      return;
    } else if (config.nullFields.isNotEmpty) {
      stdout.writeln(
        'Missing required configurations for Jira: ${config.nullFields}',
      );
      return;
    } else if (argResults['testcaseKey'] == null) {
      stdout.writeln('Testcase key is missing');
      return;
    }

    final client = JiraIssueClient.fromConfig(config);

    final request = OpenTicketRequest(
      projectId: argResults['projectId'] as String,
      testcaseKey: argResults['testcaseKey'] as String,
    );
    final result = await client.openIssue(request);

    if (result.isSuccess) {
      stdout.writeln(
        'Issue created! View ${result.result.key} at ${result.result.self}',
      );
    } else {
      stderr.writeln(result.message);
    }

    client.close();
  }
}
