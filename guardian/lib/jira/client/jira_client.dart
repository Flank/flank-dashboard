import 'dart:convert';
import 'dart:io';

import 'package:guardian/jira/model/issue_transition_request.dart';
import 'package:guardian/jira/model/jira_config.dart';
import 'package:guardian/jira/model/jira_created_issue.dart';
import 'package:guardian/jira/model/jira_issue_transition.dart';
import 'package:guardian/jira/model/jira_result.dart';
import 'package:guardian/jira/model/open_ticket_request.dart';
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

  Future<JiraResult<List<JiraIssueTransition>>> getTransitions(
    String issueId,
  ) async {
    final path = '/rest/api/3/issue/$issueId/transitions';
    final response = await _client.get('$apiBasePath$path', headers: _headers);

    if (response.statusCode == HttpStatus.ok) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return JiraResult<List<JiraIssueTransition>>.success(
        result: JiraIssueTransition.listFromJson(
            body['transitions'] as List<dynamic>),
      );
    } else {
      final responseMessage = response.contentLength > 0
          ? 'Response: ${jsonDecode(response.body)}'
          : '';
      return JiraResult.error(
        message: 'Failed to retrieve transitions '
            'with code ${response.statusCode}. $responseMessage',
      );
    }
  }

  Future<JiraResult<JiraCreatedIssue>> openIssue(
    OpenTicketRequest request,
  ) async {
    const path = 'rest/api/3/issue';
    final response = await _client.post(
      '$apiBasePath$path',
      headers: _headers,
      body: jsonEncode({
        'fields': {
          'summary': 'Flaky tests detected',
          'project': {
            'key': request.projectId,
          },
          'issuetype': {
            'name': 'Task',
          },
        },
      }),
    );

    if (response.statusCode == HttpStatus.created) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return JiraResult<JiraCreatedIssue>.success(
        result: JiraCreatedIssue.fromJson(body),
      );
    } else {
      final responseMessage = response.contentLength > 0
          ? 'Response: ${jsonDecode(response.body)}'
          : '';
      return JiraResult.error(
        message: 'Failed to create issue '
            'with code ${response.statusCode}. $responseMessage',
      );
    }
  }

  Future<JiraResult> issueTransition(IssueTransitionRequest request) async {
    final path = '/rest/api/3/issue/${request.issueKey}/transitions';
    final response = await _client.post(
      '$apiBasePath$path',
      headers: _headers,
      body: jsonEncode({
        'transition': {
          'id': request.transitionId,
        },
      }),
    );

    if (response.statusCode == HttpStatus.noContent) {
      return JiraResult.success();
    } else {
      final responseMessage = response.contentLength > 0
          ? 'Response: ${jsonDecode(response.body)}'
          : '';
      return JiraResult.error(
        message: 'Failed to close issue '
            'with code ${response.statusCode}. $responseMessage',
      );
    }
  }

  void close() {
    _client.close();
  }
}
