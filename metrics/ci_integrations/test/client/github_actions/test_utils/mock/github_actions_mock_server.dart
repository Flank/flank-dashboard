import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:api_mock_server/api_mock_server.dart';
import 'package:ci_integration/client/github_actions/mappers/run_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/run_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/run_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_duration.dart';

/// A mock server for the Github Actions API.
class GithubActionsMockServer extends ApiMockServer {
  /// A path to emulate a download url.
  static const String _downloadPath = '/download';

  @override
  List<RequestHandler> get handlers => [
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '/repos/owner/name/actions/workflows/workflow_id/runs',
          ),
          dispatcher: _workflowRunsResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '/repos/owner/name/actions/workflows/test/runs',
          ),
          dispatcher: _notFoundResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '/repos/owner/name/actions/runs/1/artifacts',
          ),
          dispatcher: _workflowRunArtifactsResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '/repos/owner/name/actions/runs/test/artifacts',
          ),
          dispatcher: _notFoundResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '/repos/owner/name/actions/runs/1/timing',
          ),
          dispatcher: _workflowUsageResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '/repos/owner/name/actions/runs/test/timing',
          ),
          dispatcher: _notFoundResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '/repos/owner/name/actions/artifacts/artifact_id/zip',
          ),
          dispatcher: _downloadArtifactResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '/repos/owner/name/actions/artifacts/test/zip',
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

    final lastPageNumber = _getLastPageNumber(
      workflowRuns.length,
      runsPerPage,
    );

    final hasMorePages = pageNumber < lastPageNumber;

    workflowRuns = _paginate(
      workflowRuns,
      runsPerPage,
      pageNumber,
    );

    final _response = {
      'total_count': workflowRuns.length,
      'workflow_runs': workflowRuns.map((run) => run.toJson()).toList(),
    };

    _setNextPageUrlHeader(request, hasMorePages, pageNumber);

    request.response.write(jsonEncode(_response));

    await request.response.flush();
    await request.response.close();
  }

  /// Sets next page url header if the given [hasMorePages] parameter is `true`.
  void _setNextPageUrlHeader(
      HttpRequest request, bool hasMorePages, int pageNumber) {
    if (hasMorePages) {
      final requestUrl = request.requestedUri.toString();
      final indexOfPageParam = requestUrl.indexOf("&page=");
      final nextPageUrl = requestUrl.replaceRange(
          indexOfPageParam, requestUrl.length, "&page=${pageNumber + 1}");

      request.response.headers.set('link', '<$nextPageUrl> rel="next"');
    }
  }

  /// Responses with a list of artifacts for a specific workflow run.
  Future<void> _workflowRunArtifactsResponse(HttpRequest request) async {
    final runsPerPage = _extractPerPage(request);
    final pageNumber = _extractPage(request);
    List<WorkflowRunArtifact> artifacts = _generateArtifacts();

    artifacts = _paginate(
      artifacts,
      runsPerPage,
      pageNumber,
    );

    final lastPageNumber = _getLastPageNumber(
      artifacts.length,
      runsPerPage,
    );

    final hasMorePages = pageNumber < lastPageNumber;

    final _response = {
      'total_count': artifacts.length,
      'artifacts': artifacts.map((artifact) => artifact.toJson()).toList(),
    };

    _setNextPageUrlHeader(request, hasMorePages, pageNumber);
    request.response.write(jsonEncode(_response));

    await request.response.flush();
    await request.response.close();
  }

  /// Responses with the total run time for a specific workflow run.
  Future<void> _workflowUsageResponse(HttpRequest request) async {
    const workflowRunDuration = WorkflowRunDuration(
      duration: Duration(milliseconds: 500000),
    );

    request.response.write(jsonEncode(workflowRunDuration.toJson()));

    await request.response.flush();
    await request.response.close();
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

  /// Returns a json, containing a [Uint8List] to emulate download.
  Future<void> _downloadResponse(HttpRequest request) async {
    request.response.write(jsonEncode(<Uint8List>[]));

    await request.response.flush();
    await request.response.close();
  }

  /// Adds a [HttpStatus.notFound] status code to the [HttpRequest.response]
  /// and closes it.
  Future<void> _notFoundResponse(HttpRequest request) async {
    request.response.statusCode = HttpStatus.notFound;

    await request.response.close();
  }

  /// Chunk the given [items], limiting to the [limit],
  /// starting from the [offset] index.
  List<T> _paginate<T>(List<T> items, [int limit = 100, int offset = 0]) {
    if (limit != null && offset != null) {
      final from = (offset - 1) * limit;

      return items.skip(from).take(limit).toList();
    } else if (limit != null) {
      return items.take(limit).toList();
    }

    return items;
  }

  /// Generates a list of [WorkflowRun], filtered by the given [RunStatus].
  List<WorkflowRun> _generateWorkflowRuns(RunStatus status) {
    final random = Random();
    const statuses = RunStatus.values;
    const conclusions = RunConclusion.values;

    final runs = List.generate(100, (index) {
      final id = index + 1;

      return WorkflowRun(
        id: id,
        number: random.nextInt(100),
        url: 'url',
        status: statuses[random.nextInt(statuses.length)],
        conclusion: conclusions[random.nextInt(conclusions.length)],
        createdAt: DateTime.now().toUtc(),
      );
    });

    if (status == null) {
      return runs;
    }

    return runs.where((run) => run.status == status).toList();
  }

  /// Generates a list of [WorkflowRunArtifact].
  List<WorkflowRunArtifact> _generateArtifacts() {
    final artifacts = List.generate(
      100,
      (index) {
        final id = index + 1;

        return WorkflowRunArtifact(
          id: id,
          name: 'coverage$id.json',
          downloadUrl: 'https://api.github.com$_downloadPath',
        );
      },
    );

    return artifacts;
  }

  /// Provides the [RunStatus], based on the `status` query parameter
  /// in the given [request].
  RunStatus _extractRunStatus(HttpRequest request) {
    final status = request.uri.queryParameters['status'];

    return const RunStatusMapper().map(status);
  }

  /// Returns the `int` representation of the `per_page` query parameter
  /// of the given [request].
  int _extractPerPage(HttpRequest request) {
    return int.tryParse(request.uri.queryParameters['per_page']);
  }

  /// Returns the `int` representation of the `page` query parameter
  /// of the given [request].
  int _extractPage(HttpRequest request) {
    return int.tryParse(request.uri.queryParameters['page']);
  }

  /// Returns last page's number.
  int _getLastPageNumber(int total, int perPage) {
    if (perPage == null || total == null) return 1;

    return max((total / perPage).ceil(), 1);
  }
}
