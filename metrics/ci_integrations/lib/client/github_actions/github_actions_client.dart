import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:ci_integration/client/github_actions/constants/github_actions_constants.dart';
import 'package:ci_integration/client/github_actions/mappers/run_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/run_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_duration.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_pagination.dart';
import 'package:ci_integration/client/jenkins/jenkins_client.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:ci_integration/util/url/url_utils.dart';
import 'package:ci_integration/util/validator/string_validator.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// A client for interaction with the Github Actions API.
class GithubActionsClient {
  /// A base Github API URL to use in HTTP requests for this client.
  final String githubApiUrl;

  /// An owner of the repository this client should perform requests to.
  final String repositoryOwner;

  /// A name of the repository this client should perform requests to.
  final String repositoryName;

  /// An authorization method used in HTTP requests for this client.
  final AuthorizationBase authorization;

  /// The HTTP client for making requests to the Github Actions API.
  final Client _client = Client();

  /// Creates a new instance of the [GithubActionsClient].
  ///
  /// Throws an [ArgumentError] if either [githubApiUrl], [repositoryOwner] or
  /// [repositoryName] is `null` or empty.
  GithubActionsClient({
    @required this.githubApiUrl,
    @required this.repositoryOwner,
    @required this.repositoryName,
    this.authorization,
  }) {
    StringValidator.checkNotNullOrEmpty(githubApiUrl, name: 'githubApiUrl');
    StringValidator.checkNotNullOrEmpty(repositoryOwner,
        name: 'repositoryOwner');
    StringValidator.checkNotNullOrEmpty(repositoryName, name: 'repositoryName');
  }

  /// Returns the API base path to use in HTTP requests.
  String get basePath {
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
  /// this method results with [InteractionResult.error]. Otherwise, delegates
  /// parsing [Response.body] JSON to the given [bodyParser] callback.
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

  /// Retrieves a list of [WorkflowRun]s by the given [workflowIdentifier].
  ///
  /// The [workflowIdentifier] is either a workflow id or a name of the file
  /// that defines the workflow.
  ///
  /// [status] is used as a filter query parameter to define the
  /// [WorkflowRun.status] of runs to fetch.
  ///
  /// [perPage] is used for limiting the number of runs and pagination in pair
  /// with the [page] parameter. It defaults to `10` and is limited to `100`.
  /// The greater values than `100` are ignored and considered as a maximum.
  ///
  /// [page] is used for pagination and defines a page of runs to fetch.
  /// If the [page] is `null` or omitted, the first page is fetched.
  Future<InteractionResult<WorkflowRunsPagination>> fetchWorkflowRuns(
    String workflowIdentifier, {
    RunStatus status,
    int perPage = 10,
    int page,
  }) {
    const statusMapper = RunStatusMapper();

    final queryParameters = {
      'status': statusMapper.unmap(status),
      'per_page': '$perPage',
      'page': '$page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'workflows/$workflowIdentifier/runs',
      queryParameters: queryParameters,
    );

    return _handleResponse<WorkflowRunsPagination>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) {
        return InteractionResult.success(
          result: WorkflowRunsPagination.fromJson(
            json,
            page: page,
            perPage: perPage,
          ),
        );
      },
    );
  }

  /// Fetches a [WorkflowRunDuration] for the run with the given [runId].
  Future<InteractionResult<WorkflowRunDuration>> fetchRunDuration(int runId) {
    final url = UrlUtils.buildUrl(
      basePath,
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

  /// Fetches a list of artifacts for a workflow run with the given [runId].
  ///
  /// [perPage] is used for limiting the number of artifacts and pagination in
  /// pair with the [page] parameter. It defaults to `10` and is limited to
  /// `100`. The greater values than `100` are ignored and considered as a
  /// maximum.
  ///
  /// [page] is used for pagination and defines a page of artifacts to fetch.
  /// If the [page] is `null` or omitted, the first page is fetched.
  Future<InteractionResult<List<WorkflowRunArtifact>>> fetchRunArtifacts(
    int runId, {
    int perPage = 10,
    int page,
  }) {
    final queryParameters = {
      'per_page': '$perPage',
      'page': '$page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
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

  /// Fetches a workflow run artifact by the given download [url].
  ///
  /// The resulting [Uint8List] contains bytes of a zip archive with the desired
  /// artifacts.
  Future<InteractionResult<Uint8List>> downloadRunArtifactZip(
    String url,
  ) async {
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
