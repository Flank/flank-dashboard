import 'dart:convert';
import 'dart:io';

import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:ci_integration/jenkins/client/config/tree_query.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_building_job.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_job.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_multi_branch_job.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_query_limits.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_result.dart';
import 'package:ci_integration/jenkins/client/util/url_utils.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// A callback for parsing Jenkins API response body.
typedef BodyParserCallback<T> = JenkinsResult<T> Function(Map<String, dynamic>);

/// A client for interactions with the Jenkins API.
class JenkinsClient {
  /// A Jenkins JSON API path.
  static const String jsonApiPath = '/api/json';

  /// The HTTP client for making requests to the Jenkins API.
  final Client _client = Client();

  /// The authorization method used within HTTP requests.
  final AuthorizationBase _authorization;

  /// The base URL of the Jenkins instance.
  final String _jenkinsUrl;

  /// Creates an instance of [JenkinsClient] using [url] and
  /// [authorization] method (see [AuthorizationBase] and implementers)
  /// provided.
  ///
  /// [url] is required. Throws [ArgumentError] if it is `null` or empty.
  JenkinsClient({
    @required String url,
    AuthorizationBase authorization,
  })  : _authorization = authorization,
        _jenkinsUrl = url {
    if (_jenkinsUrl == null || _jenkinsUrl.isEmpty) {
      throw ArgumentError.value(
        _jenkinsUrl,
        'jenkinsUrl',
        'must not be null or empty',
      );
    }
  }

  /// Creates basic [Map] with headers for HTTP requests.
  ///
  /// If provided authorization method is not `null` then adds the result
  /// of [AuthorizationBase.toMap] method to headers.
  Map<String, String> get headers {
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
      if (_authorization != null) ..._authorization.toMap(),
    };
  }

  /// Builds URL to the Jenkins API using the parts provided. Delegates
  /// building URL to the [UrlUtils.buildUrl] method.
  ///
  /// The [url] can be either a link to the Jenkins instance or link to an
  /// object from Jenkins (such as [JenkinsBuild.url], [JenkinsJob.url] and
  /// so on). The [path] defaults to Jenkins JSON API path. The [treeQuery]
  /// stands for the `tree` query parameter used to specify objects' properties
  /// API should return and defaults to an empty string.
  String _buildJenkinsApiUrl(
    String url, {
    String path = jsonApiPath,
    String treeQuery = '',
  }) {
    return UrlUtils.buildUrl(
      url,
      path: path,
      queryParameters:
          treeQuery == null || treeQuery.isEmpty ? null : {'tree': treeQuery},
    );
  }

  /// A generic method for handling HTTP responses.
  ///
  /// Awaits [responseFuture] and handles the result. If either the provided
  /// future throws or [HttpResponse.statusCode] is not equal to
  /// [successStatusCode] (defaults to [HttpStatus.ok]) this method will
  /// result with [JenkinsResult.error]. Otherwise, delegates parsing
  /// [Response.body] JSON to the [bodyParser] method.
  Future<JenkinsResult<T>> _handleResponse<T>(
    Future<Response> responseFuture,
    BodyParserCallback<T> bodyParser, [
    int successStatusCode = HttpStatus.ok,
  ]) async {
    try {
      final response = await responseFuture;

      if (response.statusCode == successStatusCode) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return bodyParser(body);
      } else {
        final reason = response.body == null || response.body.isEmpty
            ? response.reasonPhrase
            : response.body;
        return JenkinsResult.error(
          message: 'Failed to perform an operation with code '
              '${response.statusCode}. Reason: $reason',
        );
      }
    } catch (error) {
      return JenkinsResult.error(
        message: 'Failed to perform an operation. Error details: $error',
      );
    }
  }

  /// Retrieves [JenkinsJob] by provided [name].
  ///
  /// If the desired job is a part of another job then the top-level job's name
  /// should be included to the [topLevelPipelines] list.
  /// [topLevelPipelines] is optional and defaults to an empty list.
  ///
  /// If the desired job's full name is known, consider to use
  /// [fetchPipelineByFullName] method instead.
  Future<JenkinsResult<JenkinsJob>> fetchPipeline(
    String name, {
    List<String> topLevelPipelines = const [],
  }) {
    final jobs = (topLevelPipelines ?? []).toList()..add(name);
    return _fetchPipeline('job/${jobs?.join('/job/')}');
  }

  /// Retrieves [JenkinsJob] by provided [fullName].
  ///
  /// A Jenkins job's full name contains all top-level jobs' names in the
  /// following form: `<top-...-top-job>/.../<top-job>/<job>`. Unlike the
  /// [fetchPipeline] method, this one will parse [fullName] to detect top-level
  /// jobs and build a path to the desired job.
  Future<JenkinsResult<JenkinsJob>> fetchPipelineByFullName(String fullName) {
    final path = fullName.splitMapJoin('/', onMatch: (_) => '/job/');
    return _fetchPipeline('job/$path');
  }

  /// Retrieves [JenkinsJob] by provided [path].
  ///
  /// Both [fetchPipeline] and [fetchPipelineByFullName] delegate fetching
  /// job to this method.
  Future<JenkinsResult<JenkinsJob>> _fetchPipeline(String path) {
    final fullUrl = _buildJenkinsApiUrl(
      _jenkinsUrl,
      path: '$path/api/json',
      treeQuery: TreeQuery.job,
    );

    return _handleResponse<JenkinsJob>(
      _client.get(fullUrl, headers: headers),
      (Map<String, dynamic> json) => JenkinsResult.success(
        result: JenkinsJob.fromJson(json),
      ),
    );
  }

  /// Retrieves jobs for the [multiBranchJob] using its URL.
  ///
  /// Results with the [JenkinsMultiBranchJob]'s instance similar to
  /// [multiBranchJob] but with populated [JenkinsMultiBranchJob.jobs] list.
  /// [limits] can be used to set the fetch limits (see [JenkinsQueryLimits]) -
  /// defaults to [JenkinsQueryLimits.empty].
  Future<JenkinsResult<JenkinsMultiBranchJob>> fetchJobs(
    JenkinsMultiBranchJob multiBranchJob, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final url = _buildJenkinsApiUrl(
      multiBranchJob.url,
      treeQuery: '${TreeQuery.jobBase},'
          'jobs[${TreeQuery.job}]${limits.toQuery()}',
    );

    return _handleResponse<JenkinsMultiBranchJob>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) => JenkinsResult.success(
        result: JenkinsMultiBranchJob.fromJson(json),
      ),
    );
  }

  /// Retrieves builds for the [buildingJob] using its URL.
  ///
  /// Results with the [JenkinsBuildingJob]'s instance similar to
  /// [buildingJob] but with populated builds-related fields.
  /// [limits] can be used to set the fetch limits (see [JenkinsQueryLimits]) -
  /// defaults to [JenkinsQueryLimits.empty].
  Future<JenkinsResult<JenkinsBuildingJob>> fetchBuilds(
    JenkinsBuildingJob buildingJob, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final url = _buildJenkinsApiUrl(
      buildingJob.url,
      treeQuery: '${TreeQuery.jobBase},'
          'builds[${TreeQuery.build}]${limits.toQuery()},'
          'lastBuild[${TreeQuery.build}],firstBuild[${TreeQuery.build}]',
    );

    return _handleResponse<JenkinsBuildingJob>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) => JenkinsResult.success(
        result: JenkinsBuildingJob.fromJson(json),
      ),
    );
  }

  /// Retrieves a list of [JenkinsBuildArtifact]s generated during the build
  /// specified by the provided [buildUrl].
  ///
  /// [limits] can be used to set the fetch limits (see [JenkinsQueryLimits]) -
  /// defaults to [JenkinsQueryLimits.empty].
  Future<JenkinsResult<List<JenkinsBuildArtifact>>> fetchArtifactsByBuildUrl(
    String buildUrl, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final url = _buildJenkinsApiUrl(
      buildUrl,
      treeQuery: 'artifacts[${TreeQuery.artifacts}]${limits.toQuery()}',
    );

    return _handleResponse<List<JenkinsBuildArtifact>>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) => JenkinsResult.success(
        result: JenkinsBuildArtifact.listFromJson(
            json['artifacts'] as List<dynamic>),
      ),
    );
  }

  /// Retrieves the content of an artifact specified by the provided
  /// [relativePath] within the build specified by the provided [buildUrl].
  Future<JenkinsResult<Map<String, dynamic>>> fetchArtifactByRelativePath(
    String buildUrl,
    String relativePath,
  ) {
    final url = _buildJenkinsApiUrl(buildUrl, path: 'artifact/$relativePath');

    return _fetchArtifact(url);
  }

  /// Retrieves the [buildArtifact]'s content generated during the [build].
  Future<JenkinsResult<Map<String, dynamic>>> fetchArtifact(
    JenkinsBuild build,
    JenkinsBuildArtifact buildArtifact,
  ) {
    final url = _buildJenkinsApiUrl(
      build.url,
      path: 'artifact/${buildArtifact.relativePath}',
    );

    return _fetchArtifact(url);
  }

  /// Retrieves the artifact's content by the given [url].
  ///
  /// Both [fetchArtifactByRelativePath] and [fetchArtifact] methods delegate
  /// fetching the artifact's content to this method.
  Future<JenkinsResult<Map<String, dynamic>>> _fetchArtifact(String url) {
    return _handleResponse<Map<String, dynamic>>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) => JenkinsResult.success(result: json),
    );
  }

  /// Closes the client and cleans up any resources associated with it.
  /// Similar to [Client.close].
  void close() {
    _client.close();
  }
}
