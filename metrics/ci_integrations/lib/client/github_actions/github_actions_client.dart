import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:ci_integration/client/github_actions/constants/github_actions_constants.dart';
import 'package:ci_integration/client/github_actions/mappers/run_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/run_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/jenkins/jenkins_client.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:ci_integration/util/url/url_utils.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import 'models/workflow_run_duration.dart';

/// A client for interaction with the Github Actions API.
class GithubActionsClient {
  /// The Github API URL to use in HTTP requests.
  final String githubApiUrl;

  /// An owner of the repository.
  final String repositoryOwner;

  /// A name of the repository.
  final String repositoryName;

  /// An authorization method used in HTTP requests.
  final AuthorizationBase authorization;

  /// The HTTP client for making requests to the Github Actions API.
  final Client _client = Client();

  /// Creates a new instance of the [GithubActionsClient] using [githubApiUrl],
  /// [repositoryOwner], [repositoryName] and the [authorization] method
  /// (see [AuthorizationBase] and implementers) provided.
  ///
  /// [githubApiUrl], [repositoryOwner], [repositoryName] are
  /// required parameters. If any of them is empty or equals to `null`, the
  /// [ArgumentError.value] is thrown.
  GithubActionsClient({
    @required this.githubApiUrl,
    @required this.repositoryOwner,
    @required this.repositoryName,
    this.authorization,
  }) {
    if (githubApiUrl == null || githubApiUrl.isEmpty) {
      throw ArgumentError.value(
        githubApiUrl,
        'githubApiUrl',
        'must not be null or empty',
      );
    }

    if (repositoryOwner == null || repositoryOwner.isEmpty) {
      throw ArgumentError.value(
        repositoryOwner,
        'repositoryOwner',
        'must not be null or empty',
      );
    }

    if (repositoryName == null || repositoryName.isEmpty) {
      throw ArgumentError.value(
        repositoryName,
        'repositoryName',
        'must not be null or empty',
      );
    }
  }

  /// Returns the base API url for making HTTP requests.
  String get baseUrl {
    return '$githubApiUrl/repos/$repositoryOwner/$repositoryName/actions/';
  }

  /// Creates basic [Map] with headers for HTTP requests.
  ///
  /// If provided authorization method is not `null` then adds the result
  /// of [AuthorizationBase.toMap] method to headers.
  Map<String, String> get headers {
    return <String, String>{
      HttpHeaders.acceptHeader: GithubActionsConstants.acceptHeader,
      if (authorization != null) ...authorization.toMap(),
    };
  }

  /// A method for handling Github-specific HTTP responses.
  ///
  /// Awaits [responseFuture] and handles the result. If either the provided
  /// future throws or [HttpResponse.statusCode] is not equal to [HttpStatus.ok]
  /// this method will result with [InteractionResult.error]. Otherwise,
  /// delegates parsing [Response.body] JSON to the [bodyParser] method.
  Future<InteractionResult<T>> _handleResponse<T>(
    Future<Response> responseFuture,
    BodyParserCallback<T> bodyParser,
  ) async {
    try {
      final response = await responseFuture;

      if (response.statusCode == HttpStatus.ok) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return bodyParser(body);
      } else {
        final reason = response.body == null || response.body.isEmpty
            ? response.reasonPhrase
            : response.body;
        return InteractionResult.error(
          message: 'Failed to perform an operation with code '
              '${response.statusCode}. Reason: $reason',
        );
      }
    } catch (error) {
      return InteractionResult.error(
        message: 'Failed to perform an operation. Error details: $error',
      );
    }
  }

  /// Retrieves a list of workflow runs by the given [workflowFileName].
  ///
  /// Results with a [List] of [WorkflowRun]s.
  ///
  /// [status] can be used to set the status of workflow runs to retrieve.
  /// [status] defaults to [RunStatus.completed].
  ///
  /// [perPage] can be used to set the number of runs per page.
  /// [perPage] defaults to `100` runs per page.
  /// The maximum value of [perPage] is 100 runs per page.
  ///
  /// [page] can be used to set the number of a page to retrieve.
  /// [page] defaults to the `1`st page.
  Future<InteractionResult<List<WorkflowRun>>> fetchWorkflowRuns(
    String workflowFileName, {
    RunStatus status = RunStatus.completed,
    int perPage = 100,
    int page = 1,
  }) {
    const statusMapper = RunStatusMapper();

    final queryParameters = {
      'status': statusMapper.unmap(status),
      'per_page': '$perPage',
      'page': '$page',
    };

    final url = UrlUtils.buildUrl(
      baseUrl,
      path: 'workflows/$workflowFileName/runs',
      queryParameters: queryParameters,
    );

    return _handleResponse<List<WorkflowRun>>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) {
        final runList =
            json == null ? null : json['workflow_runs'] as List<dynamic>;

        return InteractionResult.success(
          result: WorkflowRun.listFromJson(runList),
        );
      },
    );
  }

  /// Retrieves a workflow run duration by the given [runId].
  ///
  /// Results with a [WorkflowRunDuration].
  Future<InteractionResult<WorkflowRunDuration>> fetchRunDuration(int runId) {
    final url = UrlUtils.buildUrl(
      baseUrl,
      path: 'runs/$runId/timing',
    );

    return _handleResponse<WorkflowRunDuration>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) {
        return InteractionResult.success(
          result: WorkflowRunDuration.fromJson(json),
        );
      },
    );
  }

  /// Retrieves a list of workflow run artifacts by the given [runId].
  ///
  /// Results with a [List] of [WorkflowRunArtifact]s.
  ///
  /// [perPage] can be used to set the number of artifacts per page.
  /// [perPage] defaults to `100` artifacts per page.
  /// The maximum value of [perPage] is 100.
  ///
  /// [page] can be used to set the number of a page to retrieve.
  /// [page] defaults to the `1`st page.
  Future<InteractionResult<List<WorkflowRunArtifact>>> fetchRunArtifacts(
    int runId, {
    int perPage = 100,
    int page = 1,
  }) {
    final queryParameters = {
      'per_page': '$perPage',
      'page': '$page',
    };

    final url = UrlUtils.buildUrl(
      baseUrl,
      path: 'runs/$runId/artifacts',
      queryParameters: queryParameters,
    );

    return _handleResponse<List<WorkflowRunArtifact>>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) {
        final artifactList =
            json == null ? null : json['artifacts'] as List<dynamic>;

        return InteractionResult.success(
          result: WorkflowRunArtifact.listFromJson(artifactList),
        );
      },
    );
  }

  /// Retrieves a workflow run artifact by the given download [url].
  ///
  /// Results with a [Uint8List] that contains the artifact's bytes.
  Future<InteractionResult<Uint8List>> downloadRunArtifact(String url) async {
    try {
      final response = await _client.get(url);

      if (response.statusCode == HttpStatus.ok) {
        return InteractionResult.success(result: response.bodyBytes);
      } else {
        final reason = response.body == null || response.body.isEmpty
            ? response.reasonPhrase
            : response.body;
        return InteractionResult.error(
          message: 'Failed to perform an operation with code '
              '${response.statusCode}. Reason: $reason',
        );
      }
    } catch (error) {
      return InteractionResult.error(
        message: 'Failed to perform an operation. Error details: $error',
      );
    }
  }

  /// Closes the client and cleans up any resources associated with it.
  void close() {
    _client.close();
  }
}
