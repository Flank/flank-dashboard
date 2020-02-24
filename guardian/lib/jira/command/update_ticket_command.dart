import 'dart:io';

import 'package:guardian/jira/client/jira_issue_client.dart';
import 'package:guardian/jira/command/jira_command.dart';
import 'package:guardian/jira/model/issue_transition_request.dart';
import 'package:guardian/jira/model/jira_config.dart';

class UpdateTicketCommand extends JiraCommand {
  @override
  String get name => 'update';

  @override
  String get description => 'Updates Jira issue';

  UpdateTicketCommand() {
    addConfigOptionByNames(JiraConfig().toMap().keys.toList());
    argParser.addOption('issueKey', help: 'Key of issue to close');
  }

  @override
  Future<void> run() async {
    final config = JiraConfig()..readFromArgs(argResults);
    final issueKey = argResults['issueKey'] as String;

    if (config == null) {
      stdout.writeln('Jira configurations are missing');
      return;
    } else if (config.nullFields.isNotEmpty) {
      stdout.writeln(
          'Missing required configurations for Jira: ${config.nullFields}');
      return;
    } else if (issueKey == null) {
      stdout.writeln('Key of issue to close is missing');
      return;
    }

    final client = JiraIssueClient.fromConfig(config);

    final transition =
        await getIssueTransitionByCategoryKey(client, issueKey, 'new');
    if (transition == null) {
      stderr.writeln('Reopening transition is not defined');
    } else {
      final result = await client.issueTransition(IssueTransitionRequest(
        issueKey: issueKey,
        transitionId: transition.id,
      ));

      if (result.isSuccess) {
        stdout.writeln('Issue has been reopened successfully!');
      } else {
        stderr.writeln(result.message);
      }
    }

    client.close();
  }
}
