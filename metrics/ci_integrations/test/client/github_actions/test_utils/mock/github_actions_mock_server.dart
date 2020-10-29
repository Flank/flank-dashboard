import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:api_mock_server/api_mock_server.dart';
import 'package:ci_integration/client/github_actions/mappers/github_action_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';

/// A mock server for the Github Actions API.
class GithubActionsMockServer extends ApiMockServer {
  /// A path to emulate a download url.
  static const String _downloadPath = '/download';

  /// Returns a base path of the Github Actions API.
  String get basePath => '/repos/owner/name/actions';

  @override
  List<RequestHandler> get handlers => [
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/workflows/workflow_id/runs',
          ),
          dispatcher: _workflowRunsResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/workflows/test/runs',
          ),
          dispatcher: _notFoundResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/runs/1/jobs',
          ),
          dispatcher: _workflowRunJobsResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/runs/test/jobs',
          ),
          dispatcher: _notFoundResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/runs/1/artifacts',
          ),
          dispatcher: _workflowRunArtifactsResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/runs/test/artifacts',
          ),
          dispatcher: _notFoundResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/artifacts/artifact_id/zip',
          ),
          dispatcher: _downloadArtifactResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/artifacts/test/zip',
          ),
          dispatcher: _notFoundResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(_downloadPath),
          dispatcher: _downloadResponse,
        ),
      ];

  /// Responses with a list of all workflow runs for a specific workflow.
  Future<void> _workflowRunsResponse(HttpRequest request) async {
    final status = _extractRunStatus(request);
    final runsPerPage = _extractPerPage(request);
    final pageNumber = _extractPage(request);

    List<WorkflowRun> workflowRuns = _generateWorkflowRuns(status);

    final lastPageNumber = _getLastPageNumber(workflowRuns.length, runsPerPage);

    final hasMorePages = pageNumber < lastPageNumber;
    _setNextPageUrlHeader(request, hasMorePages, pageNumber);

    workflowRuns = _paginate(workflowRuns, runsPerPage, pageNumber);

    final _response = {
      'total_count': workflowRuns.length,
      'workflow_runs': workflowRuns.map((run) => run.toJson()).toList(),
    };

    await _writeResponse(request, _response);
  }

  /// Responses with a list of all workflow run jobs for a specific workflow run.
  Future<void> _workflowRunJobsResponse(HttpRequest request) async {
    final status = _extractRunStatus(request);
    final runsPerPage = _extractPerPage(request);
    final pageNumber = _extractPage(request);

    List<WorkflowRunJob> workflowRunJobs = _generateWorkflowRunJobs(status);

    final lastPageNumber = _getLastPageNumber(
      workflowRunJobs.length,
      runsPerPage,
    );

    final hasMorePages = pageNumber < lastPageNumber;
    _setNextPageUrlHeader(request, hasMorePages, pageNumber);

    workflowRunJobs = _paginate(workflowRunJobs, runsPerPage, pageNumber);

    final _response = {
      'total_count': workflowRunJobs.length,
      'jobs': workflowRunJobs.map((run) => run.toJson()).toList(),
    };

    await _writeResponse(request, _response);
  }

  /// Responses with a list of artifacts for a specific workflow run.
  Future<void> _workflowRunArtifactsResponse(HttpRequest request) async {
    final runsPerPage = _extractPerPage(request);
    final pageNumber = _extractPage(request);
    List<WorkflowRunArtifact> artifacts = _generateArtifacts();

    final lastPageNumber = _getLastPageNumber(artifacts.length, runsPerPage);

    final hasMorePages = pageNumber < lastPageNumber;
    _setNextPageUrlHeader(request, hasMorePages, pageNumber);

    artifacts = _paginate(artifacts, runsPerPage, pageNumber);

    final _response = {
      'total_count': artifacts.length,
      'artifacts': artifacts.map((artifact) => artifact.toJson()).toList(),
    };

    await _writeResponse(request, _response);
  }

  /// Redirects to the URL to download an archive for a repository.
  Future<void> _downloadArtifactResponse(HttpRequest request) async {
    final uri = Uri.parse(url);

    await request.response.redirect(
      Uri(host: uri.host, port: uri.port, path: _downloadPath),
      status: HttpStatus.found,
    );

    await request.response.close();
  }

  /// Returns a [Uint8List] to emulate download.
  Future<void> _downloadResponse(HttpRequest request) async {
    await _writeResponse(request, Uint8List.fromList([]));
  }

  /// Adds a [HttpStatus.notFound] status code to the [HttpRequest.response]
  /// and closes it.
  Future<void> _notFoundResponse(HttpRequest request) async {
    request.response.statusCode = HttpStatus.notFound;

    await request.response.close();
  }

  /// Chunks the given [items], limiting to the [limit],
  /// starting from the [pageIndex].
  List<T> _paginate<T>(List<T> items, [int limit, int pageIndex]) {
    if (limit != null && pageIndex != null) {
      final from = (pageIndex - 1) * limit;

      return items.skip(from).take(limit).toList();
    } else if (limit != null) {
      return items.take(limit).toList();
    }

    return items;
  }

  /// Generates a list of [WorkflowRun], filtered by the given [status].
  List<WorkflowRun> _generateWorkflowRuns(GithubActionStatus status) {
    final runs = List.generate(100, (index) {
      final runNumber = index + 1;

      return WorkflowRun(
        id: runNumber,
        number: runNumber,
        url: 'url',
        status: status ?? GithubActionStatus.completed,
        createdAt: DateTime.now().toUtc(),
      );
    });

    return runs;
  }

  /// Generates a list of [WorkflowRunJob]s, filtered by the given [status].
  List<WorkflowRunJob> _generateWorkflowRunJobs(GithubActionStatus status) {
    final jobs = List.generate(100, (index) {
      final id = index + 1;

      return WorkflowRunJob(
        id: id,
        runId: 1,
        name: 'name',
        url: 'url',
        status: status ?? GithubActionStatus.completed,
        conclusion: GithubActionConclusion.success,
        startedAt: DateTime(2019),
        completedAt: DateTime(2020),
      );
    });

    return jobs;
  }

  /// Generates a list of [WorkflowRunArtifact]s.
  List<WorkflowRunArtifact> _generateArtifacts() {
    final artifacts = List.generate(100, (index) {
      final id = index + 1;

      return WorkflowRunArtifact(
        id: id,
        name: 'coverage$id.json',
        downloadUrl: 'https://api.github.com$_downloadPath',
      );
    });

    return artifacts;
  }

  /// Provides the [RunStatus], based on the `status` query parameter
  /// in the given [request].
  GithubActionStatus _extractRunStatus(HttpRequest request) {
    final status = request.uri.queryParameters['status'];

    return const GithubActionStatusMapper().map(status);
  }

  /// Returns the `int` representation of the `per_page` query parameter
  /// of the given [request].
  ///
  /// Returns `null` if the [perPage] is `null`.
  int _extractPerPage(HttpRequest request) {
    final perPage = request.uri.queryParameters['per_page'];

    if (perPage == null) return null;

    return int.tryParse(perPage);
  }

  /// Returns the `int` representation of the `page` query parameter
  /// of the given [request].
  ///
  /// Returns `null` if the [page] is `null`.
  int _extractPage(HttpRequest request) {
    final page = request.uri.queryParameters['page'];

    if (page == null) return null;

    return int.tryParse(page);
  }

  /// Returns the last page's number.
  ///
  /// Returns `1` if the given [perPage] or [total] parameter is `null`.
  int _getLastPageNumber(int total, int perPage) {
    if (perPage == null || total == null) return 1;

    return max((total / perPage).ceil(), 1);
  }

  /// Sets the next page url header.
  void _setNextPageUrlHeader(
    HttpRequest request,
    bool hasMorePages,
    int pageNumber,
  ) {
    if (hasMorePages) {
      final requestUrl = request.requestedUri.toString();
      final indexOfPageParam = requestUrl.indexOf("&page=");
      final nextPageUrl = requestUrl.replaceRange(
        indexOfPageParam,
        requestUrl.length,
        "&page=${pageNumber + 1}",
      );

      request.response.headers.set('link', '<$nextPageUrl> rel="next"');
    }
  }

  /// Writes the given [response].
  Future<void> _writeResponse(HttpRequest request, dynamic response) async {
    request.response.write(jsonEncode(response));

    await request.response.flush();
    await request.response.close();
  }
}
