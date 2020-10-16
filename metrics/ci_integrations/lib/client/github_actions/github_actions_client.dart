import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:ci_integration/client/github_actions/constants/github_actions_constants.dart';
import 'package:ci_integration/client/github_actions/mappers/github_action_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:ci_integration/util/url/url_utils.dart';
import 'package:ci_integration/util/validator/string_validator.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// A callback for processing HTTP responses, using their [body] and [headers].
typedef ResponseProcessingCallback<T> = InteractionResult<T> Function(
  Map<String, dynamic> body,
  Map<String, String> headers,
);

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

  /// A [RegExp] needed to parse next page URLs in [HttpResponse] headers.
  final RegExp _nextUrlRegexp = RegExp('(?<=<)(.*)(?=>)');

  /// An HTTP client for making requests to the Github Actions API.
  final Client _client = Client();

  /// Creates a new instance of the [GithubActionsClient].
  ///
  /// The [githubApiUrl] defaults to the [GithubActionsConstants.githubApiUrl].
  ///
  /// Throws an [ArgumentError] if either [githubApiUrl], [repositoryOwner] or
  /// [repositoryName] is `null` or empty.
  GithubActionsClient({
    @required this.repositoryOwner,
    @required this.repositoryName,
    this.githubApiUrl = GithubActionsConstants.githubApiUrl,
    this.authorization,
  }) {
    StringValidator.checkNotNullOrEmpty(githubApiUrl, name: 'githubApiUrl');
    StringValidator.checkNotNullOrEmpty(
      repositoryOwner,
      name: 'repositoryOwner',
    );
    StringValidator.checkNotNullOrEmpty(repositoryName, name: 'repositoryName');
  }

  /// Returns a base path to the API to use in HTTP requests.
  String get basePath {
    return '$githubApiUrl/repos/$repositoryOwner/$repositoryName/actions/';
  }

  /// Creates basic [Map] with headers for HTTP requests.
  ///
  /// If the given [authorization] method is not `null`, then adds the result
  /// of [AuthorizationBase.toMap] method to headers.
  Map<String, String> get headers {
    return <String, String>{
      HttpHeaders.acceptHeader: GithubActionsConstants.acceptHeader,
      if (authorization != null) ...authorization.toMap(),
    };
  }

  /// A method for handling Github-specific HTTP responses.
  ///
  /// Awaits [responseFuture] and handles the result. If either
  /// the given [responseFuture] throws or the [HttpResponse.statusCode] is not
  /// equal to [HttpStatus.ok] this method results
  /// with [InteractionResult.error]. Otherwise, delegates
  /// processing the response to the given [responseProcessor] callback.
  Future<InteractionResult<T>> _handleResponse<T>(
    Future<Response> responseFuture,
    ResponseProcessingCallback<T> responseProcessor,
  ) async {
    try {
      final response = await responseFuture;

      if (response.statusCode == HttpStatus.ok) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final headers = response.headers;
        return responseProcessor(body, headers);
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

  /// Fetches a [WorkflowRunsPage] with a list of [WorkflowRun] by the
  /// given [workflowIdentifier]. A [workflowIdentifier] is either a workflow
  /// id or a name of the file that defines the workflow.
  ///
  /// A [status] is used as a filter query parameter to define the
  /// [WorkflowRun.status] of runs to fetch.
  ///
  /// A [perPage] is used for limiting the number of runs and pagination in pair
  /// with the [page] parameter. It defaults to `10` and satisfies the following
  /// statements:
  /// - if the given [status] is `null`, the [perPage] is limited to `100`;
  /// - if the given [status] is not `null`, the [perPage] is limited to `25`.
  /// If the given value of [perPage] is greater than its limit,
  /// the upper bound is used.
  ///
  /// For example, performing requests with non-`null` status query:
  /// ```dart
  ///   // initialize client
  ///   final fetchResult = await client.fetchWorkflowRuns(
  ///     'id',
  ///     status: RunStatus.completed,
  ///     page: 3,
  ///     perPage: 1000,
  ///   );
  ///
  ///   final runs = fetchResult.result;
  ///   print(runs.perPage); // prints 1000
  ///   print(runs.page); // prints 3
  ///   print(runs.values.length); // prints 25
  /// ```
  ///
  /// In the case of `null` status query:
  /// ```dart
  ///   // initialize client
  ///   final fetchResult = await client.fetchWorkflowRuns(
  ///     'id',
  ///     page: 3,
  ///     perPage: 1000,
  ///   );
  ///
  ///   final runs = fetchResult.result;
  ///   print(runs.perPage); // prints 1000
  ///   print(runs.page); // prints 3
  ///   print(runs.values.length); // prints 100
  /// ```
  ///
  /// A [page] is used for pagination and defines a page of runs to fetch.
  /// If the [page] is `null` or omitted, the first page is fetched.
  Future<InteractionResult<WorkflowRunsPage>> fetchWorkflowRuns(
    String workflowIdentifier, {
    GithubActionStatus status,
    int perPage = 10,
    int page,
  }) async {
    const statusMapper = GithubActionStatusMapper();
    final _page = page ?? 1;

    final queryParameters = {
      'status': statusMapper.unmap(status),
      'per_page': '$perPage',
      'page': '$_page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'workflows/$workflowIdentifier/runs',
      queryParameters: queryParameters,
    );

    return _fetchWorkflowRuns(url, page: _page, perPage: perPage);
  }

  /// Fetches the next [WorkflowRunsPage] of the given [currentPage].
  ///
  /// If the given [currentPage] does not have the next page, the
  /// [InteractionResult.error] is returned.
  FutureOr<InteractionResult<WorkflowRunsPage>> fetchNextRunsPage(
    WorkflowRunsPage currentPage,
  ) {
    if (!currentPage.hasNextPage) {
      return const InteractionResult.error(
        message: 'The last page is reached, there are no more runs to fetch!',
      );
    }

    final nextPageNumber =
        currentPage.page == null ? null : currentPage.page + 1;

    return _fetchWorkflowRuns(
      currentPage.nextPageUrl,
      page: nextPageNumber,
      perPage: currentPage.perPage,
    );
  }

  /// Fetches a [WorkflowRunsPage] by the given [url].
  ///
  /// A [perPage] is used for limiting the number of runs and pagination in pair
  /// with the [page] parameter.
  ///
  /// A [page] is used for pagination and defines a page of runs to fetch.
  ///
  /// Both [fetchWorkflowRuns] and [fetchNextRunsPage] delegate retrieving
  /// [WorkflowRunsPage]s to this method.
  Future<InteractionResult<WorkflowRunsPage>> _fetchWorkflowRuns(
    String url, {
    int page,
    int perPage,
  }) {
    return _handleResponse<WorkflowRunsPage>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json, Map<String, String> headers) {
        final nextPageUrl = _parseNextPageUrl(headers);

        if (json == null) return const InteractionResult.success();

        final runsList = json['workflow_runs'] as List<dynamic>;
        final runs = WorkflowRun.listFromJson(runsList);

        return InteractionResult.success(
          result: WorkflowRunsPage(
            totalCount: json['total_count'] as int,
            page: page,
            perPage: perPage,
            nextPageUrl: nextPageUrl,
            values: runs,
          ),
        );
      },
    );
  }

  /// Fetches a [WorkflowRunArtifactsPage] with the given [runId].
  ///
  /// A [perPage] is used for limiting the number of artifacts and pagination
  /// in pair with the [page] parameter. It defaults to `10` and is limited
  /// to `100`. If the given value of [perPage] is greater than its limit,
  /// the upper bound is used.
  ///
  /// For example:
  /// ```dart
  ///   // initialize client
  ///   final fetchResult = await client.fetchRunArtifacts(
  ///     123,
  ///     page: 3,
  ///     perPage: 1000,
  ///   );
  ///
  ///   final artifacts = fetchResult.result;
  ///   print(artifacts.perPage); // prints 1000
  ///   print(artifacts.page); // prints 3
  ///   print(artifacts.values.length); // prints 100
  /// ```
  ///
  /// A [page] is used for pagination and defines a page of artifacts to fetch.
  /// If the [page] is `null` or omitted, the first page is fetched.
  Future<InteractionResult<WorkflowRunArtifactsPage>> fetchRunArtifacts(
    int runId, {
    int perPage = 10,
    int page,
  }) {
    final _page = page ?? 1;

    final queryParameters = {
      'per_page': '$perPage',
      'page': '$_page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'runs/$runId/artifacts',
      queryParameters: queryParameters,
    );

    return _fetchRunArtifacts(url, page: _page, perPage: perPage);
  }

  /// Fetches the next [WorkflowRunArtifactsPage] of the given [currentPage].
  ///
  /// If the given [currentPage] does not have the next page, the
  /// [InteractionResult.error] is returned.
  FutureOr<InteractionResult<WorkflowRunArtifactsPage>>
      fetchNextRunArtifactsPage(WorkflowRunArtifactsPage currentPage) {
    if (!currentPage.hasNextPage) {
      return const InteractionResult.error(
        message: 'The last page is reached, there are no more runs to fetch!',
      );
    }

    final nextPageNumber =
        currentPage.page == null ? null : currentPage.page + 1;

    return _fetchRunArtifacts(
      currentPage.nextPageUrl,
      page: nextPageNumber,
      perPage: currentPage.perPage,
    );
  }

  /// Fetches [WorkflowRunArtifactsPage] by the given [url].
  ///
  /// A [perPage] is used for limiting the number of runs and pagination in pair
  /// with the [page] parameter.
  ///
  /// A [page] is used for pagination and defines a page of runs to fetch.
  ///
  /// Both [fetchRunArtifacts] and [fetchNextRunArtifactsPage] delegate
  /// retrieving [WorkflowRunArtifactsPage]s to this method.
  Future<InteractionResult<WorkflowRunArtifactsPage>> _fetchRunArtifacts(
    String url, {
    int page,
    int perPage,
  }) {
    return _handleResponse<WorkflowRunArtifactsPage>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json, Map<String, String> headers) {
        final nextPageUrl = _parseNextPageUrl(headers);

        if (json == null) return const InteractionResult.success();

        final artifactsList = json['artifacts'] as List<dynamic>;
        final artifacts = WorkflowRunArtifact.listFromJson(artifactsList);

        return InteractionResult.success(
          result: WorkflowRunArtifactsPage(
            totalCount: json['total_count'] as int,
            page: page,
            perPage: perPage,
            nextPageUrl: nextPageUrl,
            values: artifacts,
          ),
        );
      },
    );
  }

  /// Downloads a workflow run artifact by the given download [url].
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

  /// Parses the next page URL from the given [headers].
  String _parseNextPageUrl(Map<String, String> headers) {
    final linkHeader = headers['link'];
    if (linkHeader == null) return null;

    final nextPageUrlString = linkHeader.split(',').firstWhere(
          (link) => link.contains('rel="next"'),
          orElse: () => '',
        );

    final nextPageUrl = _nextUrlRegexp.firstMatch(nextPageUrlString)?.group(0);

    return nextPageUrl;
  }

  /// Closes the client and cleans up any resources associated with it.
  void close() {
    _client.close();
  }
}
