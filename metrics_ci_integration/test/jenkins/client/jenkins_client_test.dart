import 'dart:io';

import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:ci_integration/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/model/jenkins_building_job.dart';
import 'package:ci_integration/jenkins/model/jenkins_multi_branch_job.dart';
import 'package:ci_integration/jenkins/model/jenkins_query_limits.dart';
import 'package:test/test.dart';

import '../test_utils/jenkins_mock_server.dart';

void main() {
  group('JenkinsClient', () {
    const localhostUrl = 'http://localhost:8080';
    final jenkinsMockServer = JenkinsMockServer();

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

    final authorization = ApiKeyAuthorization(
      HttpHeaders.authorizationHeader,
      'test',
    );

    JenkinsClient jenkinsClient;
    JenkinsClient unauthorizedJenkinsClient;

    setUpAll(() async {
      await jenkinsMockServer.init();

      unauthorizedJenkinsClient = JenkinsClient(
        jenkinsUrl: jenkinsMockServer.url,
      );

      jenkinsClient = JenkinsClient(
        jenkinsUrl: jenkinsMockServer.url,
        authorization: authorization,
      );
    });

    tearDownAll(() async {
      await jenkinsMockServer.close();
      unauthorizedJenkinsClient.close();
      jenkinsClient.close();
    });

    test(
      'should throw ArgumentError creating a client instance with a null URL',
      () {
        expect(() => JenkinsClient(jenkinsUrl: null), throwsArgumentError);
      },
    );

    test(
      'should throw ArgumentError creating a client instance with an empty URL',
      () {
        expect(() => JenkinsClient(jenkinsUrl: ''), throwsArgumentError);
      },
    );

    test(
      'buildJenkinsApiUrl() should throw ArgumentError if a URL is null',
      () {
        expect(
          () => jenkinsClient.buildJenkinsApiUrl(null),
          throwsArgumentError,
        );
      },
    );

    test(
      'buildJenkinsApiUrl() should throw FormatException if a URL is invalid',
      () {
        expect(
          () => jenkinsClient.buildJenkinsApiUrl('test'),
          throwsFormatException,
        );
      },
    );

    test(
      'buildJenkinsApiUrl() should add default path to Jenkins JSON API '
      'if no provided',
      () {
        final result = jenkinsClient.buildJenkinsApiUrl(localhostUrl);
        const expected = '$localhostUrl/api/json';

        expect(result, equals(expected));
      },
    );

    test(
      'buildJenkinsApiUrl() should not add query parameters if not provided',
      () {
        final result = jenkinsClient.buildJenkinsApiUrl(localhostUrl);
        final actual = Uri.parse(result).hasQuery;

        expect(actual, isFalse);
      },
    );

    test(
      'buildJenkinsApiUrl() should not add query parameters if an empty '
      'tree query provided',
      () {
        final result = jenkinsClient.buildJenkinsApiUrl(
          localhostUrl,
          treeQuery: '',
        );
        final actual = Uri.parse(result).hasQuery;

        expect(actual, isFalse);
      },
    );

    test(
      'buildJenkinsApiUrl() should build a valid URL from parts provided',
      () {
        final result = jenkinsClient.buildJenkinsApiUrl(
          '$localhostUrl/',
          path: '/job/test/job/test/1/',
          treeQuery: 'number,url,timestamp,duration,artifacts',
        );
        final uri = Uri.parse('$localhostUrl/job/test/job/test/1').replace(
          queryParameters: {'tree': 'number,url,timestamp,duration,artifacts'},
        );
        final expected = uri.toString();

        expect(result, equals(expected));
      },
    );

    test(
      'headers should contain the "content-type" header with an '
      'application-json value',
      () {
        final headers = jenkinsClient.headers;

        expect(
          headers,
          containsPair(HttpHeaders.contentTypeHeader, ContentType.json.value),
        );
      },
    );

    test(
      'headers should contain the "accept" header with an '
      'application-json value',
      () {
        final headers = jenkinsClient.headers;

        expect(
          headers,
          containsPair(HttpHeaders.acceptHeader, ContentType.json.value),
        );
      },
    );

    test(
      'headers should include authorization related header if provided',
      () {
        final headers = jenkinsClient.headers;
        final authHeader = authorization.toMap().entries.first;

        expect(
          headers,
          containsPair(authHeader.key, authHeader.value),
        );
      },
    );

    test(
      'headers should not include authorization related header if client '
      'is not authorized',
      () {
        final headers = unauthorizedJenkinsClient.headers;
        final expectedHeaders = {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
          HttpHeaders.acceptHeader: ContentType.json.value,
        };

        expect(headers, equals(expectedHeaders));
      },
    );

    test('should fail to perform requests if not authorized', () {
      final result = unauthorizedJenkinsClient
          .fetchPipeline('test')
          .then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test('fetchPipeline() should fail if a pipeline is not found', () {
      final result =
          jenkinsClient.fetchPipeline('name').then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test('fetchPipeline() should response with a pipeline', () {
      final result =
          jenkinsClient.fetchPipeline('test').then((result) => result.result);
      const expected = JenkinsMultiBranchJob(
        name: 'test',
        fullName: 'test',
        jobs: [],
      );

      expect(result, completion(equals(expected)));
    });

    test(
      'fetchPipelineByFullName() should fail if a pipeline with the given '
      'full name is not found',
      () {
        final result = jenkinsClient
            .fetchPipelineByFullName('test/dev')
            .then((result) => result.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      'fetchPipelineByFullName() should response with a pipeline matching '
      'the given full name',
      () {
        final result = jenkinsClient
            .fetchPipelineByFullName('test/master')
            .then((result) => result.result);
        const expected = JenkinsBuildingJob(
          name: 'master',
          fullName: 'test/master',
          builds: [],
        );

        expect(result, completion(equals(expected)));
      },
    );

    test('fetchJobs() should fail if a pipeline is not found', () {
      final multiBranchJob = JenkinsMultiBranchJob(
        name: 'name',
        url: '${jenkinsMockServer.url}/job/name',
      );
      final result = jenkinsClient
          .fetchJobs(multiBranchJob)
          .then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test(
      'fetchJobs() should response with a pipeline populated with a list of jobs',
      () {
        final multiBranchJob = JenkinsMultiBranchJob(
          name: 'test',
          url: '${jenkinsMockServer.url}/job/test',
        );
        final result = jenkinsClient
            .fetchJobs(multiBranchJob)
            .then((result) => result.result);
        const expected = JenkinsMultiBranchJob(
          name: 'test',
          fullName: 'test',
          jobs: [
            JenkinsBuildingJob(
              name: 'master',
              fullName: 'test/master',
              builds: [],
            ),
          ],
        );

        expect(result, completion(equals(expected)));
      },
    );

    test('fetchJobs() should apply limits to request if provided', () {
      final multiBranchJob = JenkinsMultiBranchJob(
        name: 'test',
        url: '${jenkinsMockServer.url}/job/test',
      );
      final result = jenkinsClient
          .fetchJobs(
            multiBranchJob,
            limits: JenkinsQueryLimits.endBefore(0),
          )
          .then((result) => result.result);
      const expected = JenkinsMultiBranchJob(
        name: 'test',
        fullName: 'test',
        jobs: [],
      );

      expect(result, completion(equals(expected)));
    });

    test('fetchBuilds() should fail if building job is not found', () {
      final buildingJob = JenkinsBuildingJob(
        name: 'dev',
        url: '${jenkinsMockServer.url}/job/test/job/dev',
      );
      final result = jenkinsClient
          .fetchBuilds(buildingJob)
          .then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test(
      'fetchBuilds() should response with a building populated with '
      'builds related data',
      () {
        final buildingJob = JenkinsBuildingJob(
          name: 'master',
          url: '${jenkinsMockServer.url}/job/test/job/master',
        );
        final result = jenkinsClient
            .fetchBuilds(buildingJob)
            .then((result) => result.result);

        final expected = JenkinsBuildingJob(
          name: 'master',
          fullName: 'test/master',
          builds: [lastBuild, firstBuild],
          firstBuild: firstBuild,
          lastBuild: lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      'fetchBuilds() should apply limits to request if provided',
      () {
        final buildingJob = JenkinsBuildingJob(
          name: 'master',
          url: '${jenkinsMockServer.url}/job/test/job/master',
        );
        final result = jenkinsClient
            .fetchBuilds(
              buildingJob,
              limits: JenkinsQueryLimits.endAt(1),
            )
            .then((result) => result.result);

        final expected = JenkinsBuildingJob(
          name: 'master',
          fullName: 'test/master',
          builds: [lastBuild],
          firstBuild: firstBuild,
          lastBuild: lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      'fetchArtifactsByBuildUrl() should fail if build with the given '
      'url is not found',
      () {
        final url = '${jenkinsMockServer.url}/job/test/job/master/10';
        final result = jenkinsClient
            .fetchArtifactsByBuildUrl(url)
            .then((result) => result.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      'fetchArtifactsByBuildUrl() should response with a list of artifacts '
      'for the build matching given url',
      () {
        final url = '${jenkinsMockServer.url}/job/test/job/master/1';
        final result = jenkinsClient
            .fetchArtifactsByBuildUrl(url)
            .then((result) => result.result);
        const expected = [
          JenkinsBuildArtifact(
            fileName: 'coverage.json',
            relativePath: 'coverage/coverage.json',
          ),
          JenkinsBuildArtifact(
            fileName: 'file.json',
            relativePath: 'files/file.json',
          ),
        ];

        expect(result, completion(equals(expected)));
      },
    );

    test(
      'fetchArtifactsByBuildUrl() should apply limits to request if provided',
      () {
        final url = '${jenkinsMockServer.url}/job/test/job/master/1';
        final result = jenkinsClient
            .fetchArtifactsByBuildUrl(
              url,
              limits: JenkinsQueryLimits.endAt(1),
            )
            .then((result) => result.result);
        const expected = [
          JenkinsBuildArtifact(
            fileName: 'coverage.json',
            relativePath: 'coverage/coverage.json',
          ),
        ];

        expect(result, completion(equals(expected)));
      },
    );

    test(
      'fetchArtifactByRelativePath() should fail if artifact is not found',
      () {
        final url = '${jenkinsMockServer.url}/job/test/job/master/10';
        final result = jenkinsClient
            .fetchArtifactByRelativePath(url, 'coverage/test.json')
            .then((result) => result.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      'fetchArtifactByRelativePath() should response with an artifact content',
      () {
        final url = '${jenkinsMockServer.url}/job/test/job/master/1';
        final result = jenkinsClient
            .fetchArtifactByRelativePath(url, 'coverage/coverage.json')
            .then((result) => result.result);
        const expected = <String, dynamic>{
          'coverage': 80,
          'total': 200,
          'pct': 40,
        };

        expect(result, completion(equals(expected)));
      },
    );

    test(
      'fetchArtifact() should fail if the given artifact is not '
      'found for the given build',
      () {
        final build = JenkinsBuild(
          url: '${jenkinsMockServer.url}/job/test/job/master/10',
        );
        const artifact = JenkinsBuildArtifact(
          fileName: 'test.json',
          relativePath: 'coverage/test.json',
        );
        final result = jenkinsClient
            .fetchArtifact(build, artifact)
            .then((result) => result.isError);

        expect(result, completion(isTrue));
      },
    );

    test('fetchArtifact() should response with an artifact content', () {
      final build = JenkinsBuild(
        url: '${jenkinsMockServer.url}/job/test/job/master/1',
      );
      const artifact = JenkinsBuildArtifact(
        fileName: 'coverage.json',
        relativePath: 'coverage/coverage.json',
      );
      final result = jenkinsClient
          .fetchArtifact(build, artifact)
          .then((result) => result.result);
      const expected = <String, dynamic>{
        'coverage': 80,
        'total': 200,
        'pct': 40,
      };

      expect(result, completion(equals(expected)));
    });
  });
}
