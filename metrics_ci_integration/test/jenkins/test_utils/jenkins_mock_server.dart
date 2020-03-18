import 'dart:convert';
import 'dart:io';

import 'package:ci_integration/jenkins/client/config/jenkins_api_config.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_multi_branch_job.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_building_job.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_query_limits.dart';

import '../../test_utils/api_mock_server/api_mock_server.dart';
import '../../test_utils/api_mock_server/auth_credentials.dart';

/// A mock server for the Jenkins API.
class JenkinsMockServer extends ApiMockServer {
  @override
  List<RequestHandler> get handlers => [
        RequestHandler.get(
          path: '/job/test${JenkinsApiConfig.jsonApiPath}',
          dispatcher: _multiBranchJobResponse,
        ),
        RequestHandler.get(
          path: '/job/name/${JenkinsApiConfig.jsonApiPath}',
          dispatcher: _notFoundResponse,
        ),
        RequestHandler.get(
          path: '/job/test/job/master${JenkinsApiConfig.jsonApiPath}',
          dispatcher: _buildingJobResponse,
        ),
        RequestHandler.get(
          path: '/job/test/job/dev${JenkinsApiConfig.jsonApiPath}',
          dispatcher: _notFoundResponse,
        ),
        RequestHandler.get(
          path: '/job/test/job/master/1${JenkinsApiConfig.jsonApiPath}',
          dispatcher: _artifactsResponse,
        ),
        RequestHandler.get(
          path: '/job/test/job/master/10${JenkinsApiConfig.jsonApiPath}',
          dispatcher: _notFoundResponse,
        ),
        RequestHandler.get(
          path: '/job/test/job/master/1/artifact/coverage/coverage.json',
          dispatcher: _artifactContentResponse,
        ),
        RequestHandler.get(
          path: '/job/test/job/master/1/artifact/coverage/test.json',
          dispatcher: _notFoundResponse,
        ),
      ];

  @override
  List<AuthCredentials> get authCredentials => const [
        AuthCredentials(token: 'test'),
      ];

  JenkinsMultiBranchJob _buildMultiBranchJob({
    bool hasJobs = false,
    JenkinsQueryLimits limits,
  }) {
    if (hasJobs) {
      final jobsList = [
        _buildBuildingJob(),
      ];

      return JenkinsMultiBranchJob(
        name: 'test',
        fullName: 'test',
        jobs: limits == null
            ? jobsList
            : jobsList.sublist(
                limits.lower, limits.upper == 0 ? 0 : limits.upper - 1),
      );
    } else {
      return const JenkinsMultiBranchJob(
        name: 'test',
        fullName: 'test',
        jobs: [],
      );
    }
  }

  JenkinsBuildingJob _buildBuildingJob({
    bool hasBuilds = false,
    JenkinsQueryLimits limits,
  }) {
    if (hasBuilds) {
      final firstBuild = JenkinsBuild(
        number: 1,
        duration: const Duration(),
        timestamp: DateTime(2000),
        result: 'FAILURE',
        artifacts: const [],
      );
      final lastBuild = JenkinsBuild(
        number: 2,
        duration: const Duration(),
        timestamp: DateTime(2000),
        result: 'SUCCESS',
        artifacts: const [
          JenkinsBuildArtifact(
            fileName: 'coverage.json',
            relativePath: 'coverage/coverage.json',
          ),
        ],
      );

      final buildsList = [
        lastBuild,
        firstBuild,
      ];

      return JenkinsBuildingJob(
        name: 'master',
        fullName: 'test/master',
        builds: limits == null
            ? buildsList
            : buildsList.sublist(
                limits.lower, limits.upper == 0 ? 0 : limits.upper - 1),
        firstBuild: firstBuild,
        lastBuild: lastBuild,
      );
    } else {
      return const JenkinsBuildingJob(
        name: 'master',
        fullName: 'test/master',
        builds: [],
      );
    }
  }

  bool _treeQueryContains(HttpRequest request, Pattern pattern) {
    final requestQuery = request.uri.queryParameters['tree'];
    return requestQuery?.contains(pattern) ?? false;
  }

  JenkinsQueryLimits _extractLimits(HttpRequest request, Pattern after) {
    final requestQuery = request.uri.queryParameters['tree'];
    final substring = requestQuery.replaceAll(after, '');
    final regexp = RegExp(r'\{[-\d,]+\}');
    final match = regexp.stringMatch(substring);
    return match == null ? null : JenkinsQueryLimits.fromQuery(match);
  }

  Future<void> _multiBranchJobResponse(HttpRequest request) async {
    String responseBody;

    if (_treeQueryContains(request, RegExp(r'jobs\[[\w\W]+\]'))) {
      final limits = _extractLimits(request, RegExp(r'jobs\[[\w\W]+\]'));
      responseBody = jsonEncode(_buildMultiBranchJob(
        hasJobs: true,
        limits: limits,
      ).toJson());
    } else {
      responseBody = jsonEncode(_buildMultiBranchJob().toJson());
    }

    request.response.write(responseBody);
    await request.response.flush();
    await request.response.close();
  }

  Future<void> _buildingJobResponse(HttpRequest request) async {
    String responseBody;

    if (_treeQueryContains(request, JenkinsApiConfig.buildTreeQuery)) {
      final limits = _extractLimits(
        request,
        'builds[${JenkinsApiConfig.buildTreeQuery}]',
      );
      responseBody = jsonEncode(_buildBuildingJob(
        hasBuilds: true,
        limits: limits,
      ).toJson());
    } else {
      responseBody = jsonEncode(_buildBuildingJob().toJson());
    }

    request.response.write(responseBody);
    await request.response.flush();
    await request.response.close();
  }

  Future<void> _artifactsResponse(HttpRequest request) async {
    final _response = {
      'artifacts': [
        const JenkinsBuildArtifact(
          fileName: 'coverage.json',
          relativePath: 'coverage/coverage.json',
        ),
        const JenkinsBuildArtifact(
          fileName: 'file.json',
          relativePath: 'files/file.json',
        )
      ].map((art) => art.toJson()).toList(),
    };

    final limits = _extractLimits(request, 'artifacts');
    if (limits == null) {
      request.response.write(jsonEncode(_response));
    } else {
      _response['artifacts'] = _response['artifacts']
          .sublist(limits.lower, limits.upper == 0 ? 0 : limits.upper - 1);
      request.response.write(jsonEncode(_response));
    }

    await request.response.flush();
    await request.response.close();
  }

  Future<void> _artifactContentResponse(HttpRequest request) async {
    const artifactContent = <String, dynamic>{
      'coverage': 80,
      'total': 200,
      'pct': 40,
    };

    request.response.write(jsonEncode(artifactContent));
    await request.response.flush();
    await request.response.close();
  }

  Future<void> _notFoundResponse(HttpRequest request) async {
    request.response.statusCode = HttpStatus.notFound;

    await request.response.close();
  }
}
