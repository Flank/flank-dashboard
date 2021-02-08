// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/jira/client/jira_client.dart';
import 'package:guardian/jira/command/jira_command.dart';
import 'package:guardian/jira/model/jira_config.dart';
import 'package:guardian/jira/model/ticket_manage_request.dart';

class OpenTicketCommand extends JiraCommand {
  @override
  String get name => 'open';

  @override
  String get description => 'Opens Jira issue';

  OpenTicketCommand() {
    addConfigOptionByNames(JiraConfig().toMap().keys.toList());
  }

  @override
  void run() {
    final config = JiraConfig()..readFromArgs(argResults);

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
