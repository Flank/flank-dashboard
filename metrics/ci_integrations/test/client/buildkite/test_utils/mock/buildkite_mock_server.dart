import 'dart:io';
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
          dispatcher: _notFoundResponse,
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
          dispatcher: _notFoundResponse,
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
          dispatcher: _notFoundResponse,
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
  /// Takes the per page and the page number parameters from the [request] and
  /// returns the per page number of builds from the page with the page number.
  Future<void> _pipelineBuildsResponse(HttpRequest request) async {
    final state = _extractBuildState(request);
    final perPage = MockServerUtils.extractPerPage(request);
    final pageNumber = MockServerUtils.extractPage(request);

    List<BuildkiteBuild> builds = _generateBuilds(state);

    MockServerUtils.setNextPageUrlHeader(
      request,
      builds.length,
      perPage,
      pageNumber,
    );

    builds = MockServerUtils.paginate(builds, perPage, pageNumber);

    final _response = builds.map((build) => build.toJson()).toList();

    await MockServerUtils.writeResponse(request, _response);
  }

  /// Responses with a list of [BuildkiteArtifact]s.
  ///
  /// Takes the per page and the page number parameters from the [request] and
  /// returns the per page number of artifacts from the page with the page
  /// number.
  Future<void> _pipelineBuildArtifactsResponse(HttpRequest request) async {
    final perPage = MockServerUtils.extractPerPage(request);
    final pageNumber = MockServerUtils.extractPage(request);

    List<BuildkiteArtifact> artifacts = _generateArtifacts();

    MockServerUtils.setNextPageUrlHeader(
      request,
      artifacts.length,
      perPage,
      pageNumber,
    );

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

  /// Adds a [HttpStatus.notFound] status code to the [HttpRequest.response]
  /// and closes it.
  Future<void> _notFoundResponse(HttpRequest request) async {
    request.response.statusCode = HttpStatus.notFound;

    await request.response.close();
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
}
