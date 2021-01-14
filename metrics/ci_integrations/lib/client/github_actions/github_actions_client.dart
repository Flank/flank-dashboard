import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:ci_integration/cli/logger/logger.dart';
import 'package:ci_integration/client/github_actions/constants/github_actions_constants.dart';
import 'package:ci_integration/client/github_actions/mappers/github_action_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifacts_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:ci_integration/integration/interface/base/client/model/page.dart';
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

/// A callback for fetching a new page that is used in requests for pagination.
///
/// A [url] is a URL to perform an HTTP request and fetch a new page.
///
/// A [perPage] is used for limiting the number of runs and pagination in pair
/// with the [page] parameter.
///
/// A [page] is used for pagination and defines a page of runs to fetch.
typedef PageFetchingCallback<T extends Page> = Future<InteractionResult<T>>
    Function(String url, int page, int perPage);

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
  /// If the [page] is `null`, less than or equals to zero,
  /// the first page is fetched.
  Future<InteractionResult<WorkflowRunsPage>> fetchWorkflowRuns(
    String workflowIdentifier, {
    GithubActionStatus status,
    int perPage = 10,
    int page,
  }) async {
    const statusMapper = GithubActionStatusMapper();
    final _page = _getValidPageNumber(page);

    final queryParameters = {
      if (status != null) 'status': statusMapper.unmap(status),
      if (perPage != null) 'per_page': '$perPage',
      'page': '$_page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'workflows/$workflowIdentifier/runs',
      queryParameters: queryParameters,
    );

    return _fetchWorkflowRunsPage(url, _page, perPage);
  }

  /// Fetches the next [WorkflowRunsPage] of the given [currentPage].
  FutureOr<InteractionResult<WorkflowRunsPage>> fetchWorkflowRunsNext(
    WorkflowRunsPage currentPage,
  ) {
    return _processPage(currentPage, _fetchWorkflowRunsPage);
  }

  /// Fetches a [WorkflowRunsPage] by the given parameters.
  /// A [PageFetchingCallback] for the [WorkflowRunsPage]s.
  Future<InteractionResult<WorkflowRunsPage>> _fetchWorkflowRunsPage(
    String url,
    int page,
    int perPage,
  ) {
    Logger.printLog(
      'Github Actions: fetching workflow runs from the url: $url',
    );

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

  /// Fetches a [WorkflowRunJobsPage] with a list of [WorkflowRunJob] by the
  /// given [runId]. A [runId] is a unique identifier of the [WorkflowRun] the
  /// [WorkflowRunJob]s belong to.
  ///
  /// A [status] is used as a filter query parameter to define the
  /// [WorkflowRunJob.status] of jobs to fetch.
  ///
  /// A [perPage] is used for limiting the number of jobs and pagination in pair
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
  ///   final fetchResult = await client.fetchRunJobs(
  ///     1,
  ///     status: RunStatus.completed,
  ///     page: 3,
  ///     perPage: 1000,
  ///   );
  ///
  ///   final jobs = fetchResult.result;
  ///   print(jobs.perPage); // prints 1000
  ///   print(jobs.page); // prints 3
  ///   print(jobs.values.length); // prints 25
  /// ```
  ///
  /// In the case of `null` status query:
  /// ```dart
  ///   // initialize client
  ///   final fetchResult = await client.fetchRunJobs(
  ///     1,
  ///     page: 3,
  ///     perPage: 1000,
  ///   );
  ///
  ///   final jobs = fetchResult.result;
  ///   print(jobs.perPage); // prints 1000
  ///   print(jobs.page); // prints 3
  ///   print(jobs.values.length); // prints 100
  /// ```
  ///
  /// A [page] is used for pagination and defines a page of jobs to fetch.
  /// If the [page] is `null`, less than or equals to zero,
  /// the first page is fetched.
  Future<InteractionResult<WorkflowRunJobsPage>> fetchRunJobs(
    int runId, {
    GithubActionStatus status,
    int perPage = 10,
    int page,
  }) {
    const statusMapper = GithubActionStatusMapper();

    final _page = _getValidPageNumber(page);

    final queryParameters = {
      if (status != null) 'status': statusMapper.unmap(status),
      if (perPage != null) 'per_page': '$perPage',
      'page': '$_page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'runs/$runId/jobs',
      queryParameters: queryParameters,
    );

    return _fetchRunJobsPage(url, _page, perPage);
  }

  /// Fetches the next [WorkflowRunJobsPage] of the given [currentPage].
  FutureOr<InteractionResult<WorkflowRunJobsPage>> fetchRunJobsNext(
    WorkflowRunJobsPage currentPage,
  ) {
    return _processPage(currentPage, _fetchRunJobsPage);
  }

  /// Fetches a [WorkflowRunJobsPage] by the given parameters.
  /// A [PageFetchingCallback] for the [WorkflowRunJobsPage]s.
  Future<InteractionResult<WorkflowRunJobsPage>> _fetchRunJobsPage(
    String url,
    int page,
    int perPage,
  ) {
    Logger.printLog('Github Actions: fetching run jobs from the url: $url');

    return _handleResponse(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json, Map<String, String> headers) {
        final nextPageUrl = _parseNextPageUrl(headers);

        if (json == null) return const InteractionResult.success();

        final jobsList = json['jobs'] as List<dynamic>;
        final jobs = WorkflowRunJob.listFromJson(jobsList);

        return InteractionResult.success(
          result: WorkflowRunJobsPage(
            totalCount: json['total_count'] as int,
            page: page,
            perPage: perPage,
            nextPageUrl: nextPageUrl,
            values: jobs,
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
  /// If the [page] is `null`, less than or equals to zero,
  /// the first page is fetched.
  Future<InteractionResult<WorkflowRunArtifactsPage>> fetchRunArtifacts(
    int runId, {
    int perPage = 10,
    int page,
  }) {
    final _page = _getValidPageNumber(page);

    final queryParameters = {
      if (perPage != null) 'per_page': '$perPage',
      'page': '$_page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'runs/$runId/artifacts',
      queryParameters: queryParameters,
    );

    return _fetchRunArtifactsPage(url, _page, perPage);
  }

  /// Fetches the next [WorkflowRunArtifactsPage] of the given [currentPage].
  FutureOr<InteractionResult<WorkflowRunArtifactsPage>> fetchRunArtifactsNext(
    WorkflowRunArtifactsPage currentPage,
  ) {
    return _processPage(currentPage, _fetchRunArtifactsPage);
  }

  /// Fetches [WorkflowRunArtifactsPage] by the given [url].
  /// A [PageFetchingCallback] for the [WorkflowRunArtifactsPage]s.
  Future<InteractionResult<WorkflowRunArtifactsPage>> _fetchRunArtifactsPage(
    String url,
    int page,
    int perPage,
  ) {
    Logger.printLog(
      'Github Actions: fetching run artifacts from the url: $url',
    );

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
      Logger.printLog(
        'Github Actions: downloading run artifact from the url: $url',
      );
      final response = await _client.get(url, headers: headers);

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

  /// Processes the given [currentPage] and delegates fetching to the given
  /// [pageFetchingCallback].
  ///
  /// If the given [currentPage] does not [Page.hasNextPage], returns an
  /// [InteractionResult.error]. Otherwise, increments the current page number
  /// and calls the given [pageFetchingCallback].
  FutureOr<InteractionResult<T>> _processPage<T extends Page>(
    T currentPage,
    PageFetchingCallback<T> pageFetchingCallback,
  ) {
    if (!currentPage.hasNextPage) {
      return const InteractionResult.error(
        message: 'The last page is reached, '
            'there are no more elements to fetch!',
      );
    }

    final nextPageNumber =
        currentPage.page == null ? null : currentPage.page + 1;

    return pageFetchingCallback(
      currentPage.nextPageUrl,
      nextPageNumber,
      currentPage.perPage,
    );
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

  /// Returns a valid page number based on the given [pageNumber].
  ///
  /// If the given [pageNumber] is `null` or less than zero, returns `1`,
  /// otherwise, returns [pageNumber].
  int _getValidPageNumber(int pageNumber) {
    if (pageNumber == null || pageNumber <= 0) return 1;
    return pageNumber;
  }

  /// Closes the client and cleans up any resources associated with it.
  void close() {
    _client.close();
  }
}
