import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ci_integration/client/buildkite/constants/buildkite_constants.dart';
import 'package:ci_integration/client/buildkite/mappers/buildkite_build_state_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifact.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifacts_page.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_builds_page.dart';
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
class BuildkiteClient {
  /// A base Buildkite API URL to use in HTTP requests for this client.
  final String buildkiteApiUrl;

  /// An organization name on Buildkite as used in URLs.
  final String organizationSlug;

  /// An authorization method used in HTTP requests for this client.
  final AuthorizationBase authorization;

  /// An HTTP client for making requests to the Buildkite API.
  final Client _client = Client();

  /// A [RegExp] needed to parse next page URLs in [HttpResponse] headers.
  final RegExp _nextUrlRegexp = RegExp('(?<=<)(.*)(?=>)');

  /// Creates a new instance of the [BuildkiteClient];
  ///
  /// The [buildkiteApiUrl] defaults to the [BuildkiteConstants.buildkiteApiUrl].
  ///
  /// Throws an [ArgumentError] if [authorization] is `null`.
  /// Throws an [ArgumentError] if either [organizationSlug] or
  /// [buildkiteApiUrl] is `null` or empty.
  BuildkiteClient({
    @required this.organizationSlug,
    @required this.authorization,
    this.buildkiteApiUrl = BuildkiteConstants.buildkiteApiUrl,
  }) {
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
      if (authorization != null) ...authorization.toMap(),
    };
  }

  /// Fetches a [BuildkiteBuildsPage] with a list of [BuildkiteBuild] by the
  /// given [pipelineSlug]. A [pipelineSlug] is a pipeline identifier.
  ///
  /// A [state] is used as a filter query parameter to define the
  /// [BuildkiteBuild.state] of builds to fetch.
  ///
  /// A [perPage] is used for limiting the number of builds and pagination
  /// in pair with the [page] parameter. It defaults to `10` and is limited
  /// to `100`.
  /// If the given value of [perPage] is greater than its limit,
  /// the upper bound is used.
  ///
  /// A [page] is used for pagination and defines a page of builds to fetch.
  /// If the [page] is `null` or omitted, the first page is fetched.
  Future<InteractionResult<BuildkiteBuildsPage>> fetchBuildkiteBuilds(
    String pipelineSlug, {
    BuildkiteBuildState state,
    int perPage = 10,
    int page,
  }) async {
    const stateMapper = BuildkiteBuildStateMapper();
    final _page = _getValidPageNumber(page);

    final queryParameters = {
      'state': stateMapper.unmap(state),
      'per_page': '$perPage',
      'page': '$_page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'pipelines/$pipelineSlug/builds',
      queryParameters: queryParameters,
    );

    return _fetchBuildkiteBuildsPage(url, _page, perPage);
  }

  /// Fetches the next [BuildkiteBuildsPage] of the given [currentPage].
  FutureOr<InteractionResult<BuildkiteBuildsPage>> fetchBuildkiteBuildsNext(
    BuildkiteBuildsPage currentPage,
  ) {
    return _processPage(currentPage, _fetchBuildkiteBuildsPage);
  }

  /// Fetches a [BuildkiteBuildsPage] by the given parameters.
  /// A [PageFetchingCallback] for the [BuildkiteBuildsPage]s.
  Future<InteractionResult<BuildkiteBuildsPage>> _fetchBuildkiteBuildsPage(
    String url,
    int page,
    int perPage,
  ) {
    return _handleResponse<BuildkiteBuildsPage>(
      _client.get(url, headers: headers),
      (json, Map<String, String> headers) {
        final nextPageUrl = _parseNextPageUrl(headers);

        if (json == null) return const InteractionResult.success();

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

  /// Fetches a [BuildkiteArtifactPage] with the given [pipelineSlug] and
  /// [buildNumber].
  ///
  /// A [perPage] is used for limiting the number of artifacts and pagination
  /// in pair with the [page] parameter. It defaults to `10` and is limited
  /// to `100`. If the given value of [perPage] is greater than its limit,
  /// the upper bound is used.
  ///
  /// A [page] is used for pagination and defines a page of artifacts to fetch.
  /// If the [page] is `null`, less than or equals to zero,
  /// the first page is fetched.
  Future<InteractionResult<BuildkiteArtifactsPage>> fetchBuildkiteArtifacts(
    String pipelineSlug,
    int buildNumber, {
    int perPage = 10,
    int page,
  }) async {
    final _page = _getValidPageNumber(page);

    final queryParameters = {
      'per_page': '$perPage',
      'page': '$_page',
    };

    final url = UrlUtils.buildUrl(
      basePath,
      path: 'pipelines/$pipelineSlug/builds/$buildNumber/artifacts',
      queryParameters: queryParameters,
    );

    return _fetchBuildkiteArtifactsPage(url, _page, perPage);
  }

  /// Fetches the next [BuildkiteArtifactsPage] of the given [currentPage].
  FutureOr<InteractionResult<BuildkiteArtifactsPage>>
      fetchBuildkiteArtifactsNext(BuildkiteArtifactsPage currentPage) {
    return _processPage(currentPage, _fetchBuildkiteArtifactsPage);
  }

  /// Fetches [BuildkiteArtifactsPage] by the given [url].
  /// A [PageFetchingCallback] for the [BuildkiteArtifactsPage]s.
  Future<InteractionResult<BuildkiteArtifactsPage>>
      _fetchBuildkiteArtifactsPage(String url, int page, int perPage) {
    return _handleResponse<BuildkiteArtifactsPage>(
      _client.get(url, headers: headers),
      (json, Map<String, String> headers) {
        final nextPageUrl = _parseNextPageUrl(headers);

        if (json == null) return const InteractionResult.success();

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
  Future<InteractionResult<Uint8List>> downloadBuildkiteArtifact(
    String url,
  ) async {
    final request = Request('GET', Uri.parse(url))
      ..headers.addAll(headers)
      ..followRedirects = false;

    try {
      final redirectionResponse = await _client.send(request);
      final redirectionStatusCode = redirectionResponse.statusCode;

      if (redirectionStatusCode != HttpStatus.found) {
        return InteractionResult.error(
          message: 'Failed to perform a redirection with code '
              '$redirectionStatusCode.',
        );
      }

      final response =
          await _client.get(redirectionResponse.headers['location']);

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

  /// Returns the valid page number based on the given [pageNumber]
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
