import 'dart:convert';
import 'dart:io';

import 'package:ci_integration/common/authorization.dart';
import 'package:ci_integration/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/model/jenkins_building_job.dart';
import 'package:ci_integration/jenkins/model/jenkins_job.dart';
import 'package:ci_integration/jenkins/model/jenkins_multi_branch_job.dart';
import 'package:ci_integration/jenkins/model/jenkins_query_bounds.dart';
import 'package:ci_integration/jenkins/model/jenkins_result.dart';
import 'package:http/http.dart';

class JenkinsClient {
  static const String _jsonApiPath = '/api/json';
  static const String _artifactsTreeQuery =
      '[fileName,relativePath]';
  static const String _buildTreeQuery =
      '[number,duration,timestamp,result,url,artifacts$_artifactsTreeQuery]';

  final Client _client = Client();

  final Authorization _authorization;
  final String _jenkinsUrl;

  JenkinsClient({
    String jenkinsUrl,
    Authorization authorization,
  })  : _authorization = authorization,
        _jenkinsUrl = jenkinsUrl;

  Map<String, String> get _headers {
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
    }..addAll(_authorization?.toMap() ?? {});
  }

  String _buildJenkinsApiUrl(
    String url, {
    String path = _jsonApiPath,
    String treeQuery = '',
  }) {
    Uri uri = Uri.parse(url);
    final _path = Uri.parse(path);
    final urlPathSegments = uri.pathSegments.where((s) => s.isNotEmpty);
    final additionalPathSegments =
        _path.pathSegments.where((s) => s.isNotEmpty);

    uri = uri.replace(
      pathSegments: [
        ...urlPathSegments,
        ...additionalPathSegments,
      ],
      queryParameters:
          treeQuery == null || treeQuery.isEmpty ? {} : {'tree': treeQuery},
    );

    return uri.toString();
  }

  Future<JenkinsResult<T>> _handle<T>(
    Future<Response> responseFuture,
    JenkinsResult<T> Function(Map<String, dynamic>) parseBody, [
    int successStatusCode = HttpStatus.ok,
  ]) async {
    try {
      final response = await responseFuture;

      if (response.statusCode == successStatusCode) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return parseBody(body);
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

  Future<JenkinsResult<JenkinsJob>> fetchPipeline(
    String name, {
    List<String> topLevelPipelines = const [],
  }) {
    final jobs = (topLevelPipelines ?? []).toList()..add(name);
    return _fetchPipeline('job/${jobs?.join('/job/')}');
  }

  Future<JenkinsResult<JenkinsJob>> fetchPipelineByFullName(String fullName) {
    final path = fullName.splitMapJoin('/', onMatch: (_) => '/job/');
    return _fetchPipeline('job/$path');
  }

  Future<JenkinsResult<JenkinsJob>> _fetchPipeline(String path) {
    final fullUrl = _buildJenkinsApiUrl(
      _jenkinsUrl,
      path: '$path/api/json',
      treeQuery: 'name,fullName,url,jobs{,0},builds{,0}',
    );

    return _handle<JenkinsJob>(
      _client.get(fullUrl, headers: _headers),
      (Map<String, dynamic> json) => JenkinsResult.success(
        result: JenkinsJob.fromJson(json),
      ),
    );
  }

  Future<JenkinsResult<JenkinsMultiBranchJob>> fetchJobs(
    JenkinsMultiBranchJob multiBranchJob, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final url = _buildJenkinsApiUrl(
      multiBranchJob.url,
      treeQuery: 'name,fullName,url,'
          'jobs[name,fullName,url,jobs{,0},builds{,0}]'
          '${limits.toQuery()}',
    );

    return _handle<JenkinsMultiBranchJob>(
      _client.get(url, headers: _headers),
      (Map<String, dynamic> json) => JenkinsResult.success(
        result: JenkinsMultiBranchJob.fromJson(json),
      ),
    );
  }

  Future<JenkinsResult<JenkinsBuildingJob>> fetchBuilds(
    JenkinsBuildingJob buildingJob, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final url = _buildJenkinsApiUrl(
      buildingJob.url,
      treeQuery: 'name,fullName,url,'
          'builds$_buildTreeQuery${limits.toQuery()},'
          'lastBuild$_buildTreeQuery,'
          'firstBuild$_buildTreeQuery',
    );

    return _handle<JenkinsBuildingJob>(
      _client.get(url, headers: _headers),
      (Map<String, dynamic> json) => JenkinsResult.success(
        result: JenkinsBuildingJob.fromJson(json),
      ),
    );
  }

  Future<JenkinsResult<List<JenkinsBuildArtifact>>> fetchArtifactsByBuildUrl(
    String buildUrl, {
    JenkinsQueryLimits limits = const JenkinsQueryLimits.empty(),
  }) {
    final url = _buildJenkinsApiUrl(
      buildUrl,
      treeQuery: 'artifacts$_artifactsTreeQuery${limits.toQuery()}',
    );

    return _handle<List<JenkinsBuildArtifact>>(
      _client.get(url, headers: _headers),
      (Map<String, dynamic> json) => JenkinsResult.success(
        result: JenkinsBuildArtifact.listFromJson(
            json['artifacts'] as List<dynamic>),
      ),
    );
  }

  Future<JenkinsResult<Map<String, dynamic>>> fetchArtifactByRelativePath(
    String buildUrl,
    String relativePath,
  ) {
    final url = _buildJenkinsApiUrl(buildUrl, path: 'artifact/$relativePath');

    return _fetchArtifact(url);
  }

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

  Future<JenkinsResult<Map<String, dynamic>>> _fetchArtifact(String url) {
    return _handle<Map<String, dynamic>>(
      _client.get(url, headers: _headers),
      (Map<String, dynamic> json) => JenkinsResult.success(result: json),
    );
  }

  void close() {
    _client.close();
    _authorization.revoke();
  }
}
