import 'dart:io';

import 'package:guardian/jira/client/jira_issue_client.dart';
import 'package:guardian/jira/model/jira_config.dart';
import 'package:guardian/jira/model/jira_issue_transition.dart';
import 'package:guardian/runner/command/guardian_command.dart';

abstract class JiraCommand extends GuardianCommand {
  @override
  String get configurationsFilename => JiraConfig().filename;

  @override
  JiraConfig get config => JiraConfig()..readFromMap(loadConfigurations());

  Future<JiraIssueTransition> getIssueTransitionByCategoryKey(
    JiraIssueClient client,
    String issueKey,
    String key,
  ) async {
    final transitionsResponse = await client.getIssueTransitions(issueKey);
    if (transitionsResponse.isSuccess) {
      final transitions = transitionsResponse.result;

      return transitions.firstWhere(
        (transition) => transition.to.statusCategory.key == key,
        orElse: () => null,
      );
    } else {
      stderr.writeln(transitionsResponse.message);
      return null;
    }

    //      stdout.writeln('\nPlease select a transition:');
//      for (int i = 0; i < transitions.length; i++) {
//        stdout.writeln('\t${i + 1}. ${transitions[i].name}');
//      }
//
//      int transition;
//      while (transition == null) {
//        stdout.writeln('Transition (1-${transitions.length}): ');
//        final input = stdin.readLineSync();
//        transition = int.tryParse(input);
//        if (transition == null) {
//          stdout.writeln('Please input value in range from 1 to '
//              '${transitions.length}');
//        }
//      }
//
//      final result = await client.issueTransition(IssueTransitionRequest(
//        issueKey: issueKey,
//        transitionId: transitions[transition - 1].id,
//      ));
//
//      if (result.isSuccess) {
//        stdout.writeln('Issue successfully closed!');
//      } else {
//        stderr.writeln(result.message);
//      }
  }
}
