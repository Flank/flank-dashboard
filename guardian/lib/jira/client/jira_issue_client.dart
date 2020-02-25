import 'dart:convert';
import 'dart:io';

import 'package:guardian/jira/model/create_field_request.dart';
import 'package:guardian/jira/model/issue_transition_request.dart';
import 'package:guardian/jira/model/jira_config.dart';
import 'package:guardian/jira/model/jira_created_issue.dart';
import 'package:guardian/jira/model/jira_field_details.dart';
import 'package:guardian/jira/model/jira_issue_transition.dart';
import 'package:guardian/jira/model/jira_result.dart';
import 'package:guardian/jira/model/jira_search_results.dart';
import 'package:guardian/jira/model/open_ticket_request.dart';
import 'package:guardian/jira/model/search_tickets_request.dart';
import 'package:http/http.dart';

class JiraIssueClient {
  static const String _issueApiPath = '/rest/api/3/issue/';
  static const String _fieldApiPath = '/rest/api/3/field/';

  final Client _client = Client();

  final String apiBasePath;
  final String userEmail;
  final String apiToken;

  String get _issueBaseUrl => '$apiBasePath$_issueApiPath';

  String get _fieldBaseUrl => '$apiBasePath$_fieldApiPath';

  JiraIssueClient({
    this.apiBasePath,
    this.userEmail,
    this.apiToken,
  });

  factory JiraIssueClient.fromConfig(JiraConfig apiConfig) {
    if (apiConfig == null) return null;

    return JiraIssueClient(
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

  Future<JiraResult<JiraFieldDetails>> createCustomField(
    FieldRequest request,
  ) async {
    final response = await _client.post(
      _fieldBaseUrl,
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.created) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      print(body);
      return JiraResult<JiraFieldDetails>.success(
        result: JiraFieldDetails.fromJson(body),
      );
    } else {
      final responseMessage = response.contentLength > 0
          ? 'Response: ${jsonDecode(response.body)}'
          : '';
      return JiraResult.error(
        message: 'Failed to create custom field '
            'with code ${response.statusCode}. $responseMessage',
      );
    }
  }

  Future<JiraResult<void>> addCustomFieldToScreen(String fieldId) async {
    final response = await _client.post(
      '$apiBasePath/rest/api/3/screens/addToDefault/$fieldId',
      headers: _headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final body = jsonDecode(response.body);
      print(body);
      return JiraResult.success();
    } else {
      final responseMessage = response.contentLength > 0
          ? 'Response: ${jsonDecode(response.body)}'
          : '';
      return JiraResult.error(
        message: 'Failed to add custom field '
            'with code ${response.statusCode}. $responseMessage',
      );
    }
  }

//  Future<JiraResult<List<JiraFieldDetails>>> getFields({
//    String projectKey,
//  }) async {
//    final response = await _client.get(_fieldBaseUrl, headers: _headers);
//
//    print(response.body);
//  }

  Future<JiraResult<JiraCreatedIssue>> openIssue(
    OpenTicketRequest request,
  ) async {
    final response = await _client.post(
      _issueBaseUrl,
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
          'customfield_10027': request.testcaseKey,
        },
        if (request.properties != null && request.properties.isNotEmpty)
          'properties':
              request.properties.map((property) => property.toJson()).toList(),
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

  Future<JiraResult<JiraSearchResults>> getIssues(
    SearchTicketsRequest request,
  ) async {
    const path = '/rest/api/3/search';
    print(request.toJql());
    final response = await _client.post(
      '$apiBasePath$path',
      headers: _headers,
      body: jsonEncode({
        'jql': request.toJql(),
        'properties': ['testcaseKey'],
      }),
    );

    if (response.statusCode == HttpStatus.ok) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      print(body);
      return JiraResult<JiraSearchResults>.success(
        result: JiraSearchResults.fromJson(body),
      );
    } else {
      final responseMessage = response.contentLength > 0
          ? 'Response: ${jsonDecode(response.body)}'
          : '';
      return JiraResult.error(
        message: 'Failed to retrieve issues '
            'with code ${response.statusCode}. $responseMessage',
      );
    }
  }

  Future<JiraResult<List<JiraIssueTransition>>> getIssueTransitions(
    String issueKey,
  ) async {
    final path = '$issueKey/transitions';
    final response =
        await _client.get('$_issueBaseUrl$path', headers: _headers);

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

  Future<JiraResult> issueTransition(IssueTransitionRequest request) async {
    final path = '${request.issueKey}/transitions';
    final response = await _client.post(
      '$_issueBaseUrl$path',
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
