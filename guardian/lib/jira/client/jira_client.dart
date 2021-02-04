// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:convert';

import 'package:guardian/jira/model/jira_config.dart';
import 'package:http/http.dart';

class JiraClient {
  final Client _client = Client();

  final String apiBasePath;
  final String userEmail;
  final String apiToken;

  JiraClient({
    this.apiBasePath,
    this.userEmail,
    this.apiToken,
  });

  factory JiraClient.fromConfig(JiraConfig apiConfig) {
    if (apiConfig == null) return null;

    return JiraClient(
      apiBasePath: apiConfig.apiBasePath,
      userEmail: apiConfig.userEmail,
      apiToken: apiConfig.apiToken,
    );
  }

  Map<String, String> get _headers {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$userEmail:$apiToken'))}',
    };
  }

  Future<void> openIssue(String projectId) async {
    const path = 'rest/api/3/issue';
    print(projectId);
    final response = await _client.post(
      '$apiBasePath$path',
      headers: _headers,
      body: jsonEncode({
        'fields': {
          'summary': 'Flaky tests detected',
          'project': {
            'key': projectId,
          },
          'issuetype': {
            'name': 'Bug',
          },
        },
      }),
    );
    print(response.body);
    print(response.statusCode);
  }
}
