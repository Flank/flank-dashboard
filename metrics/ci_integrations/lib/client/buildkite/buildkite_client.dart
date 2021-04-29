// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/client/buildkite/constants/buildkite_constants.dart';
import 'package:ci_integration/client/buildkite/mappers/buildkite_build_state_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifact.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifacts_page.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_builds_page.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_organization.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_pipeline.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/constants/http_constants.dart';
import 'package:ci_integration/integration/interface/base/client/model/page.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:ci_integration/util/url/url_utils.dart';
import 'package:ci_integration/util/validator/string_validator.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// A callback for processing HTTP responses, using their [body] and [headers].
typedef ResponseProcessingCallback<T> = InteractionResult<T> Function(
  dynamic body,
  Map<String, String> headers,
);

/// A callback for fetching a new page that is used in requests for pagination.
///
/// A [url] is a URL to perform an HTTP request and fetch a new page.
///
/// A [perPage] is used for limiting the number of objects and pagination
/// in pair with the [page] parameter.
///
/// A [page] is used for pagination and defines a page of objects to fetch.
typedef PageFetchingCallback<T extends Page> = Future<InteractionResult<T>>
    Function(String url, int page, int perPage);

/// A client for interaction with the Buildkite API.
class BuildkiteClient with LoggerMixin {
  /// A base Buildkite API URL to use in HTTP requests for this client.
  final String buildkiteApiUrl;

  /// A unique slug (identifier) of the organization in the scope of which
  /// this client should perform requests.
  final String organizationSlug;

  /// An authorization method used in HTTP requests for this client.
  final AuthorizationBase authorization;

  /// An HTTP client for making requests to the Buildkite API.
  final Client _client = Client();

  /// A [RegExp] needed to parse next page URLs in [HttpResponse] headers.
  final RegExp _nextUrlRegexp = RegExp('(?<=<)(.*)(?=>)');

  /// A [Map] with HTTP headers to add to the default [headers] of this client.
  final Map<String, String> _headers;

  /// Creates a new instance of the [BuildkiteClient].
  ///
  /// The [buildkiteApiUrl] defaults to the [BuildkiteConstants.buildkiteApiUrl].
  /// The [headers] defaults to the [HttpConstants.defaultHeaders].
  ///
  /// Throws an [ArgumentError] if [authorization] is `null`.
  /// Throws an [ArgumentError] if either [organizationSlug] or
  /// [buildkiteApiUrl] is `null` or empty.
  BuildkiteClient({
    @required this.organizationSlug,
    @required this.authorization,
    this.buildkiteApiUrl = BuildkiteConstants.buildkiteApiUrl,
    Map<String, String> headers = HttpConstants.defaultHeaders,
  }) : _headers = headers {
    ArgumentError.checkNotNull(authorization, 'authorization');
    StringValidator.checkNotNullOrEmpty(
      buildkiteApiUrl,
      name: 'buildkiteApiUrl',
    );
    StringValidator.checkNotNullOrEmpty(
      organizationSlug,
      name: 'organizationSlug',
    );
  }

  /// Returns a base path to the Buildkite API to use in HTTP requests.
  String get basePath {
    return '$buildkiteApiUrl/organizations/$organizationSlug/';
  }

  /// Creates basic [Map] with headers for HTTP requests.
  ///
  /// If the given [authorization] method is not `null`, then adds the result
  /// of [AuthorizationBase.toMap] method to headers.
  Map<String, String> get headers {
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
      if (_headers != null) ..._headers,
      if (authorization != null) ...authorization.toMap(),
    };
  }

  /// Fetches a [BuildkiteBuildsPage] with a list of [BuildkiteBuild] by the
  /// given [pipelineSlug]. A [pipelineSlug] is a pipeline identifier.
  ///
  /// A [finishedFrom] is used as a filter query parameter to define builds
  /// finished on or after the given [DateTime].
  ///
  /// A [states] parameter is used as a filter query parameter to define the
  /// [BuildkiteBuildState]s of builds to fetch.
  ///
  /// A [perPage] is used for limiting the number of builds and pagination
  /// in pair with the [page] parameter. It defaults to `10` and is limited
  /// to `100`.
  /// If the given value of [perPage] is greater than its limit,
  /// the upper bound is used.
  ///
  /// A [page] is used for pagination and defines a page of builds to fetch.
  /// If the [page] is `null`, non-positive or omitted,
  /// the first page is fetched.
  Future<InteractionResult<BuildkiteBuildsPage>> fetchBuilds(
    String pipelineSlug, {
    DateTime finishedFrom,
    List<BuildkiteBuildState> states,
    int perPage = 10,
    int page,
  }) async {
    logger.info('Fetching builds...');
    const stateMapper = BuildkiteBuildStateMapper();
    final _page = _getValidPageNumber(page);

    final requestStates = states?.map((state) => stateMapper.unmap(state));

    final queryParameters = {
      if (finishedFrom != null) 'finished_from': finishedFrom.toIso8601String(),
      if (requestStates != null) 'state[]': requestStates,
      if (perPage != null) 'per_page': '$perPage',
      'page': '$_page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'pipelines/$pipelineSlug/builds',
      queryParameters: queryParameters,
    );

    return _fetchBuildsPage(url, _page, perPage);
  }

  /// Fetches the next [BuildkiteBuildsPage] of the given [currentPage].
  FutureOr<InteractionResult<BuildkiteBuildsPage>> fetchBuildsNext(
    BuildkiteBuildsPage currentPage,
  ) {
    logger.info('Fetching next builds');

    return _processPage(currentPage, _fetchBuildsPage);
  }

  /// Fetches a [BuildkiteBuildsPage] by the given parameters.
  /// A [PageFetchingCallback] for the [BuildkiteBuildsPage]s.
  Future<InteractionResult<BuildkiteBuildsPage>> _fetchBuildsPage(
    String url,
    int page,
    int perPage,
  ) {
    logger.info('Fetching builds from the page number $page: $url');

    return _handleResponse<BuildkiteBuildsPage>(
      _client.get(url, headers: headers),
      (json, Map<String, String> headers) {
        final nextPageUrl = _parseNextPageUrl(headers);

        final buildsList = json as List<dynamic>;
        final builds = BuildkiteBuild.listFromJson(buildsList);

        return InteractionResult.success(
          result: BuildkiteBuildsPage(
            page: page,
            perPage: perPage,
            nextPageUrl: nextPageUrl,
            values: builds,
          ),
        );
      },
    );
  }

  /// Fetches a [BuildkiteBuild] of a pipeline with the given [pipelineSlug]
  /// and having the given [buildNumber].
  ///
  /// Throws an [AssertionError] if the given [pipelineSlug] or [buildNumber] is
  /// `null`.
  Future<InteractionResult<BuildkiteBuild>> fetchBuild(
    String pipelineSlug,
    int buildNumber,
  ) {
    logger.info('Fetching the build #$buildNumber...');

    assert(pipelineSlug != null);
    assert(buildNumber != null);

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'pipelines/$pipelineSlug/builds/$buildNumber',
    );

    return _handleResponse(
      _client.get(url, headers: headers),
      (body, headers) {
        final buildJson = body as Map<String, dynamic>;

        return InteractionResult.success(
          result: BuildkiteBuild.fromJson(buildJson),
        );
      },
    );
  }

  /// Fetches a [BuildkiteArtifactsPage] by the given [pipelineSlug] and
  /// [buildNumber].
  ///
  /// A [perPage] is used for limiting the number of artifacts and pagination
  /// in pair with the [page] parameter. It defaults to `10` and is limited
  /// to `100`. If the given value of [perPage] is greater than its limit,
  /// the upper bound is used.
  ///
  /// A [page] is used for pagination and defines a page of artifacts to fetch.
  /// If the [page] is `null`, non-positive, or omitted,
  /// the first page is fetched.
  Future<InteractionResult<BuildkiteArtifactsPage>> fetchArtifacts(
    String pipelineSlug,
    int buildNumber, {
    int perPage = 10,
    int page,
  }) async {
    logger.info('Fetching artifacts for build #$buildNumber...');

    final _page = _getValidPageNumber(page);

    final queryParameters = {
      if (perPage != null) 'per_page': '$perPage',
      'page': '$_page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'pipelines/$pipelineSlug/builds/$buildNumber/artifacts',
      queryParameters: queryParameters,
    );

    return _fetchArtifactsPage(url, _page, perPage);
  }

  /// Fetches the next [BuildkiteArtifactsPage] of the given [currentPage].
  FutureOr<InteractionResult<BuildkiteArtifactsPage>> fetchArtifactsNext(
    BuildkiteArtifactsPage currentPage,
  ) {
    logger.info('Fetching next artifacts...');

    return _processPage(currentPage, _fetchArtifactsPage);
  }

  /// Fetches [BuildkiteArtifactsPage] by the given [url].
  /// A [PageFetchingCallback] for the [BuildkiteArtifactsPage]s.
  Future<InteractionResult<BuildkiteArtifactsPage>> _fetchArtifactsPage(
    String url,
    int page,
    int perPage,
  ) {
    logger.info('Fetching artifacts from the page number $page: $url');

    return _handleResponse<BuildkiteArtifactsPage>(
      _client.get(url, headers: headers),
      (json, Map<String, String> headers) {
        final nextPageUrl = _parseNextPageUrl(headers);

        final artifactsList = json as List<dynamic>;
        final artifacts = BuildkiteArtifact.listFromJson(artifactsList);

        return InteractionResult.success(
          result: BuildkiteArtifactsPage(
            page: page,
            perPage: perPage,
            nextPageUrl: nextPageUrl,
            values: artifacts,
          ),
        );
      },
    );
  }

  /// Downloads a build artifact by the given download [url].
  ///
  /// The resulting [Uint8List] contains bytes of a desired artifact.
  Future<InteractionResult<Uint8List>> downloadArtifact(String url) async {
    if (url == null) return null;

    logger.info('Downloading artifact from the url: $url');

    final request = Request('GET', Uri.parse(url))
      ..headers.addAll(headers)
      ..followRedirects = false;

    try {
      final redirect = await _client.send(request);

      if (redirect.statusCode != HttpStatus.found) {
        return InteractionResult.error(
          message: 'Failed to perform a redirection with code '
              '${redirect.statusCode}.',
        );
      }

      final response = await _client.get(
        redirect.headers[HttpHeaders.locationHeader],
      );

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

  /// Fetches a [BuildkiteToken] by the given [auth].
  Future<InteractionResult<BuildkiteToken>> fetchToken(
    AuthorizationBase auth,
  ) {
    ArgumentError.checkNotNull(auth, 'auth');

    final url = UrlUtils.buildUrl(
      buildkiteApiUrl,
      path: 'access-token',
    );

    final requestHeaders = <String, String>{
      ...headers,
      ...auth.toMap(),
    };

    return _handleResponse(
      _client.get(url, headers: requestHeaders),
      (json, _) {
        final tokenJson = json as Map<String, dynamic>;

        final token = BuildkiteToken.fromJson(tokenJson);

        return InteractionResult.success(result: token);
      },
    );
  }

  /// Fetches a [BuildkiteOrganization] by the given [organizationSlug].
  Future<InteractionResult<BuildkiteOrganization>> fetchOrganization(
    String organizationSlug,
  ) {
    final url = UrlUtils.buildUrl(
      buildkiteApiUrl,
      path: 'organizations/$organizationSlug',
    );

    return _handleResponse(
      _client.get(url, headers: headers),
      (json, _) {
        final organizationJson = json as Map<String, dynamic>;

        final organization = BuildkiteOrganization.fromJson(organizationJson);

        return InteractionResult.success(result: organization);
      },
    );
  }

  /// Fetches a [BuildkitePipeline] by the given [pipelineSlug].
  Future<InteractionResult<BuildkitePipeline>> fetchPipeline(
    String pipelineSlug,
  ) {
    final url = UrlUtils.buildUrl(
      basePath,
      path: 'pipelines/$pipelineSlug',
    );

    return _handleResponse(
      _client.get(url, headers: headers),
      (json, _) {
        final pipelineJson = json as Map<String, dynamic>;

        final pipeline = BuildkitePipeline.fromJson(pipelineJson);

        return InteractionResult.success(result: pipeline);
      },
    );
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

  /// A method for handling Buildkite-specific HTTP responses.
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
        final body = jsonDecode(response.body);
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
