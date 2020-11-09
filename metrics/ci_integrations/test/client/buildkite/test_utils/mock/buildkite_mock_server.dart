import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:api_mock_server/api_mock_server.dart';
import 'package:ci_integration/client/buildkite/mappers/buildkite_build_state_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifact.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';

import '../../../test_utils/mock_server_utils.dart';

/// A mock server for the Buildkite API.
class BuildkiteMockServer extends ApiMockServer {
  /// A path to emulate a download url.
  static const String _downloadPath = '/download';

  /// Returns a base path of the Buildkite API.
  String get basePath => '/organizations/organization_slug';

  @override
  List<RequestHandler> get handlers => [
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/pipelines/pipeline_slug/builds',
          ),
          dispatcher: _pipelineBuildsResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/pipelines/not_found/builds',
          ),
          dispatcher: MockServerUtils.notFoundResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/pipelines/pipeline_slug/builds/1/artifacts',
          ),
          dispatcher: _pipelineBuildArtifactsResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/pipelines/pipeline_slug/builds/not_found/artifacts',
          ),
          dispatcher: MockServerUtils.notFoundResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/pipelines/pipeline_slug/builds/1/artifacts/artifact_id/download',
          ),
          dispatcher: _downloadArtifactResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(
            '$basePath/pipelines/pipeline_slug/builds/1/artifacts/not_found/download',
          ),
          dispatcher: MockServerUtils.notFoundResponse,
        ),
        RequestHandler.get(
          pathMatcher: ExactPathMatcher(_downloadPath),
          dispatcher: _downloadResponse,
        ),
      ];

  @override
  List<AuthCredentials> get authCredentials => const [
        AuthCredentials(token: 'token'),
      ];

  /// Responses with a list of [BuildkiteBuild]s having the build state
  /// specified in the [request] parameters.
  ///
  /// Takes the per page and the page number parameters from the [request]
  /// and returns the per page number of [BuildkiteBuild]s from the page with
  /// the page number.
  Future<void> _pipelineBuildsResponse(HttpRequest request) async {
    final state = _extractBuildState(request);
    final perPage = _extractPerPage(request);
    final pageNumber = _extractPage(request);

    List<BuildkiteBuild> builds = _generateBuilds(state);

    _setNextPageUrlHeader(request, builds.length, perPage, pageNumber);

    builds = MockServerUtils.paginate(builds, perPage, pageNumber);

    final _response = builds.map((build) => build.toJson()).toList();

    await MockServerUtils.writeResponse(request, _response);
  }

  /// Responses with a list of [BuildkiteArtifact]s.
  ///
  /// Takes the per page and the page number parameters from the [request]
  /// and returns the per page number of [BuildkiteArtifact]s from the page with
  /// the page number.
  Future<void> _pipelineBuildArtifactsResponse(HttpRequest request) async {
    final perPage = _extractPerPage(request);
    final pageNumber = _extractPage(request);

    List<BuildkiteArtifact> artifacts = _generateArtifacts();

    _setNextPageUrlHeader(request, artifacts.length, perPage, pageNumber);

    artifacts = MockServerUtils.paginate(artifacts, perPage, pageNumber);

    final _response = artifacts.map((artifact) => artifact.toJson()).toList();

    await MockServerUtils.writeResponse(request, _response);
  }

  /// Redirects to the artifact download URL.
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
    await MockServerUtils.writeResponse(request, Uint8List.fromList([]));
  }

  /// Returns the [BuildkiteBuildState], based on the `state` query parameter
  /// of the given [request].
  BuildkiteBuildState _extractBuildState(HttpRequest request) {
    final state = request.uri.queryParameters['state'];

    return const BuildkiteBuildStateMapper().map(state);
  }

  /// Generates a list of [BuildkiteBuild]s with the given [state].
  ///
  /// If the given [state] is null, the [BuildkiteBuildState.finished] is used.
  List<BuildkiteBuild> _generateBuilds(BuildkiteBuildState state) {
    return List.generate(
      100,
      (index) => BuildkiteBuild(
        id: 'id',
        number: index,
        blocked: false,
        state: state ?? BuildkiteBuildState.finished,
        webUrl: 'url',
        startedAt: DateTime(2020),
        finishedAt: DateTime(2021),
      ),
    );
  }

  /// Generates a list of [BuildkiteArtifact]s.
  List<BuildkiteArtifact> _generateArtifacts() {
    return List.generate(
      100,
      (index) => BuildkiteArtifact(
        id: 'id',
        filename: 'coverage$index',
        downloadUrl: 'url',
        mimeType: 'json',
      ),
    );
  }

  /// Returns the `per_page` query parameter of the given [request].
  ///
  /// Returns `null` if the `perPage` is `null`.
  int _extractPerPage(HttpRequest request) {
    final perPage = request.uri.queryParameters['per_page'];

    if (perPage == null) return null;

    return int.tryParse(perPage);
  }

  /// Returns the `page` query parameter of the given [request].
  ///
  /// Returns `null` if the `page` is `null`.
  int _extractPage(HttpRequest request) {
    final page = request.uri.queryParameters['page'];

    if (page == null) return null;

    return int.tryParse(page);
  }

  /// Sets the next page url header using the given [request], [itemsCount],
  /// [perPage] and [pageNumber].
  void _setNextPageUrlHeader(
    HttpRequest request,
    int itemsCount,
    int perPage,
    int pageNumber,
  ) {
    final lastPageNumber = _getLastPageNumber(itemsCount, perPage);

    if (pageNumber >= lastPageNumber) return;

    final requestUrl = request.requestedUri.toString();
    final indexOfPageParam = requestUrl.indexOf("&page=");
    final nextPageUrl = requestUrl.replaceRange(
      indexOfPageParam,
      requestUrl.length,
      "&page=${pageNumber + 1}",
    );

    request.response.headers.set('link', '<$nextPageUrl> rel="next"');
  }

  /// Returns the last page number.
  ///
  /// Returns `1` if the given [perPage] or [total] parameter is `null`
  /// or the given [perPage] is less than zero.
  int _getLastPageNumber(int total, int perPage) {
    if (perPage == null || perPage <= 0 || total == null) return 1;

    return max((total / perPage).ceil(), 1);
  }
}
