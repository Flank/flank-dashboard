import 'dart:convert';
import 'dart:io';

import 'package:ci_integration/cli/logger/logger.dart';
import 'package:ci_integration/client/jenkins/constants/tree_query.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_artifact.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_building_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_query_limits.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:ci_integration/util/url/url_utils.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// A callback for parsing Jenkins API response body.
typedef BodyParserCallback<T> = InteractionResult<T> Function(
  Map<String, dynamic> body,
);

/// A client for interactions with the Jenkins API.
class JenkinsClient {
  /// A Jenkins JSON API path.
  static const String jsonApiPath = '/api/json';

  /// The HTTP client for making requests to the Jenkins API.
  final Client _client = Client();

  /// The authorization method used within HTTP requests.
  final AuthorizationBase authorization;

  /// The base URL of the Jenkins instance.
  final String jenkinsUrl;

  /// Creates an instance of [JenkinsClient] using [jenkinsUrl] and
  /// [authorization] method (see [AuthorizationBase] and implementers)
  /// provided.
  ///
  /// [jenkinsUrl] is required. Throws [ArgumentError] if it is `null` or empty.
  JenkinsClient({
    @required this.jenkinsUrl,
    this.authorization,
  }) {
    if (jenkinsUrl == null || jenkinsUrl.isEmpty) {
      throw ArgumentError.value(
        jenkinsUrl,
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
      if (authorization != null) ...authorization.toMap(),
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

  /// Converts a [JenkinsJob]'s full name to the path to this job.
  String _jobFullNameToPath(String jobFullName) {
    return UrlUtils.replacePathSeparators(jobFullName, 'job');
  }

  /// A method for handling Jenkins-specific HTTP responses.
  ///
  /// Awaits [responseFuture] and handles the result. If either the provided
  /// future throws or [HttpResponse.statusCode] is not equal to
  /// [successStatusCode] (defaults to [HttpStatus.ok]) this method will
  /// result with [InteractionResult.error]. Otherwise, delegates parsing
  /// [Response.body] JSON to the [bodyParser] method.
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

  /// Retrieves [JenkinsJob] by provided [name].
  ///
  /// If the desired job is a part of another job then the top-level job's name
  /// should be included to the [topLevelPipelines] list.
  /// [topLevelPipelines] is optional and defaults to an empty list.
  ///
  /// If the desired job's full name is known, consider to use
  /// [fetchJobByFullName] method instead.
  Future<InteractionResult<JenkinsJob>> fetchJob(
    String name, {
    List<String> topLevelPipelines = const [],
  }) {
    final jobs = (topLevelPipelines ?? []).toList()..add(name);
    return _fetchJob('job/${jobs?.join('/job/')}');
  }

  /// Retrieves [JenkinsJob] by provided [fullName].
  ///
  /// A Jenkins job's full name contains all top-level jobs' names in the
  /// following form: `<top-...-top-job>/.../<top-job>/<job>`. Unlike the
  /// [fetchJob] method, this one will parse [fullName] to detect top-level
  /// jobs and build a path to the desired job.
  Future<InteractionResult<JenkinsJob>> fetchJobByFullName(String fullName) {
    return _fetchJob(_jobFullNameToPath(fullName));
  }

  /// Retrieves [JenkinsJob] by provided [path].
  ///
  /// Both [fetchJob] and [fetchJobByFullName] delegate fetching job to this
  /// method.
  Future<InteractionResult<JenkinsJob>> _fetchJob(String path) {
    final fullUrl = _buildJenkinsApiUrl(
      jenkinsUrl,
      path: '$path/api/json',
      treeQuery: TreeQuery.job,
    );
    Logger.printLog('Jenkins: fetching job from the url: $fullUrl');

    return _handleResponse<JenkinsJob>(
      _client.get(fullUrl, headers: headers),
      (Map<String, dynamic> json) => InteractionResult.success(
        result: JenkinsJob.fromJson(json),
      ),
    );
  }

  /// Retrieves jobs for the multi-branch job by its full name.
  ///
  /// Results with a list of [JenkinsJob]s.
  /// [limits] can be used to set the fetch limits (see [JenkinsQueryLimits]) -
  /// defaults to [JenkinsQueryLimits.empty].
  Future<InteractionResult<List<JenkinsJob>>> fetchJobs(
    String multiBranchJobFullName, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final path = _jobFullNameToPath(multiBranchJobFullName);
    final url = _buildJenkinsApiUrl(
      jenkinsUrl,
      path: '$path$jsonApiPath',
      treeQuery: 'jobs[${TreeQuery.job}]${limits.toQuery()}',
    );
    return _fetchJobs(url);
  }

  /// Retrieves jobs for the multi-branch job by its full name.
  ///
  /// Results with a list of [JenkinsJob]s.
  /// [limits] can be used to set the fetch limits (see [JenkinsQueryLimits]) -
  /// defaults to [JenkinsQueryLimits.empty].
  Future<InteractionResult<List<JenkinsJob>>> fetchJobsByUrl(
    String multiBranchJobUrl, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final url = _buildJenkinsApiUrl(
      multiBranchJobUrl,
      treeQuery: '${TreeQuery.jobBase},'
          'jobs[${TreeQuery.job}]${limits.toQuery()}',
    );
    return _fetchJobs(url);
  }

  /// Retrieves jobs for the multi-branch job by the given URL.
  ///
  /// Both [fetchJobs] and [fetchJobsByUrl] delegate fetching jobs to this
  /// method.
  Future<InteractionResult<List<JenkinsJob>>> _fetchJobs(String url) {
    Logger.printLog('Jenkins: fetching jobs from the url: $url');

    return _handleResponse<List<JenkinsJob>>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) {
        final list = json == null ? null : json['jobs'] as List<dynamic>;
        return InteractionResult.success(
          result: JenkinsJob.listFromJson(list),
        );
      },
    );
  }

  /// Retrieves [JenkinsBuildingJob] with builds specified by its full name.
  ///
  /// [limits] can be used to set the fetch limits (see [JenkinsQueryLimits]) -
  /// defaults to [JenkinsQueryLimits.empty].
  Future<InteractionResult<JenkinsBuildingJob>> fetchBuilds(
    String buildingJobFullName, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final path = _jobFullNameToPath(buildingJobFullName);
    final url = _buildJenkinsApiUrl(
      jenkinsUrl,
      path: '$path$jsonApiPath',
      treeQuery: '${TreeQuery.jobBase},'
          'builds[${TreeQuery.build}]${limits.toQuery()},'
          'lastBuild[${TreeQuery.build}],firstBuild[${TreeQuery.build}]',
    );
    return _fetchBuilds(url);
  }

  /// Retrieves [JenkinsBuildingJob] with builds specified by the given URL.
  ///
  /// [limits] can be used to set the fetch limits (see [JenkinsQueryLimits]) -
  /// defaults to [JenkinsQueryLimits.empty].
  Future<InteractionResult<JenkinsBuildingJob>> fetchBuildsByUrl(
    String buildingJobUrl, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final url = _buildJenkinsApiUrl(
      buildingJobUrl,
      treeQuery: '${TreeQuery.jobBase},'
          'builds[${TreeQuery.build}]${limits.toQuery()},'
          'lastBuild[${TreeQuery.build}],firstBuild[${TreeQuery.build}]',
    );
    return _fetchBuilds(url);
  }

  /// Retrieves a building job by the given URL.
  ///
  /// Both [fetchBuilds] and [fetchBuildsByUrl] delegate fetching builds to this
  /// method.
  Future<InteractionResult<JenkinsBuildingJob>> _fetchBuilds(String url) {
    Logger.printLog('Jenkins: fetching builds from the url: $url');

    return _handleResponse<JenkinsBuildingJob>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) {
        json['builds'] = (json['builds'] as List<dynamic>)?.reversed?.toList();
        return InteractionResult.success(
          result: JenkinsBuildingJob.fromJson(json),
        );
      },
    );
  }

  /// Retrieves a list of [JenkinsBuildArtifact]s generated during the build
  /// specified by the provided [buildUrl].
  ///
  /// [limits] can be used to set the fetch limits (see [JenkinsQueryLimits]) -
  /// defaults to [JenkinsQueryLimits.empty].
  Future<InteractionResult<List<JenkinsBuildArtifact>>>
      fetchArtifactsByBuildUrl(
    String buildUrl, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final url = _buildJenkinsApiUrl(
      buildUrl,
      treeQuery: 'artifacts[${TreeQuery.artifacts}]${limits.toQuery()}',
    );

    Logger.printLog('Jenkins: fetching artifacts from the url: $url');

    return _handleResponse<List<JenkinsBuildArtifact>>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) => InteractionResult.success(
        result: JenkinsBuildArtifact.listFromJson(
            json['artifacts'] as List<dynamic>),
      ),
    );
  }

  /// Retrieves the content of an artifact specified by the provided
  /// [relativePath] within the build specified by the provided [buildUrl].
  Future<InteractionResult<Map<String, dynamic>>> fetchArtifactByRelativePath(
    String buildUrl,
    String relativePath,
  ) {
    final url = _buildJenkinsApiUrl(buildUrl, path: 'artifact/$relativePath');

    return _fetchArtifact(url);
  }

  /// Retrieves the [buildArtifact]'s content generated during the [build].
  Future<InteractionResult<Map<String, dynamic>>> fetchArtifact(
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
  Future<InteractionResult<Map<String, dynamic>>> _fetchArtifact(String url) {
    Logger.printLog('Jenkins: fetching artifact from the url: $url');

    return _handleResponse<Map<String, dynamic>>(
      _client.get(url, headers: headers),
      (Map<String, dynamic> json) => InteractionResult.success(result: json),
    );
  }

  /// Closes the client and cleans up any resources associated with it.
  /// Similar to [Client.close].
  void close() {
    _client.close();
  }
}
