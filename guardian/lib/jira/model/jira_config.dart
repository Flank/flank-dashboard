// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:guardian/config/model/config.dart';

class JiraConfig extends Config {
  JiraConfig({
    this.userEmail,
    this.apiToken,
    this.apiBasePath,
    this.projectId,
  }) : super('jira.yaml');

  String userEmail;
  String apiToken;
  String apiBasePath;
  String projectId;

  @override
  Config copy() {
    return JiraConfig(
      userEmail: userEmail,
      apiToken: apiToken,
      apiBasePath: apiBasePath,
      projectId: projectId,
    );
  }

  @override
  List<ConfigField> get fields => [
        ConfigField<String>(
          name: 'userEmail',
          description: 'Jira user email',
          setter: (value) => userEmail = value,
          value: userEmail,
        ),
        ConfigField<String>(
          name: 'apiToken',
          description: 'Jira API token',
          setter: (value) => apiToken = value,
          value: apiToken,
        ),
        ConfigField<String>(
          name: 'apiBasePath',
          description: 'Jira API base path',
          setter: (value) => apiBasePath = value,
          value: apiBasePath,
        ),
        ConfigField<String>(
          name: 'projectId',
          description: 'Jira project id',
          setter: (value) => projectId = value,
          value: projectId,
        ),
      ];

  List<String> get nullFields {
    final result = <String>[];

    toMap().forEach((key, value) {
      if (value == null) {
        result.add(key);
      }
    });

    return result;
  }

  @override
  void readFromMap(Map<String, dynamic> map) {
    if (map != null) {
      userEmail = map['userEmail'] as String;
      apiToken = map['apiToken'] as String;
      apiBasePath = map['apiBasePath'] as String;
      projectId = map['projectId'] as String;
    }
  }

  @override
  void readFromArgs(ArgResults argResults) {
    if (argResults != null) {
      userEmail = argResults['userEmail'] as String;
      apiToken = argResults['apiToken'] as String;
      apiBasePath = argResults['apiBasePath'] as String;
      projectId = argResults['projectId'] as String;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'apiToken': apiToken,
      'apiBasePath': apiBasePath,
      'projectId': projectId,
    };
  }
}
