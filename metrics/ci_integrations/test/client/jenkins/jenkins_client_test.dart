import 'dart:io';

import 'package:ci_integration/client/jenkins/jenkins_client.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_artifact.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_result.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_building_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_multi_branch_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_query_limits.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

import 'test_utils/mock/jenkins_mock_server.dart';

void main() {
  group("JenkinsClient", () {
    final jenkinsMockServer = JenkinsMockServer();

    final firstBuild = JenkinsBuild(
      number: 1,
      duration: const Duration(),
      timestamp: DateTime(2000),
      result: JenkinsBuildResult.failure,
      artifacts: const [],
    );

    final lastBuild = JenkinsBuild(
      number: 2,
      duration: const Duration(),
      timestamp: DateTime(2000),
      result: JenkinsBuildResult.success,
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
      await jenkinsMockServer.start();

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
      "should throw ArgumentError creating a client instance with a null URL",
      () {
        expect(() => JenkinsClient(jenkinsUrl: null), throwsArgumentError);
      },
    );

    test(
      "should throw ArgumentError creating a client instance with an empty URL",
      () {
        expect(() => JenkinsClient(jenkinsUrl: ''), throwsArgumentError);
      },
    );

    test(
      ".headers should contain the 'content-type' header with an application-json value",
      () {
        final headers = jenkinsClient.headers;

        expect(
          headers,
          containsPair(HttpHeaders.contentTypeHeader, ContentType.json.value),
        );
      },
    );

    test(
      ".headers should contain the 'accept' header with an application-json value",
      () {
        final headers = jenkinsClient.headers;

        expect(
          headers,
          containsPair(HttpHeaders.acceptHeader, ContentType.json.value),
        );
      },
    );

    test(
      ".headers should include authorization related header if provided",
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
      ".headers should not include authorization related header if client is not authorized",
      () {
        final headers = unauthorizedJenkinsClient.headers;
        final expectedHeaders = {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
          HttpHeaders.acceptHeader: ContentType.json.value,
        };

        expect(headers, equals(expectedHeaders));
      },
    );

    test("should fail to perform requests if not authorized", () {
      final result = unauthorizedJenkinsClient
          .fetchJob('test')
          .then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test(".fetchJob() should fail if a job is not found", () {
      final result =
          jenkinsClient.fetchJob('name').then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test(".fetchJob() should respond with a job", () {
      final result =
          jenkinsClient.fetchJob('test').then((result) => result.result);
      const expected = JenkinsMultiBranchJob(
        name: 'test',
        fullName: 'test',
        jobs: [],
      );

      expect(result, completion(equals(expected)));
    });

    test(
      ".fetchJobByFullName() should fail if a job with the given full name is not found",
      () {
        final result = jenkinsClient
            .fetchJobByFullName('test/dev')
            .then((result) => result.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".fetchJobByFullName() should respond with a job matching the given full name",
      () {
        final result = jenkinsClient
            .fetchJobByFullName('test/master')
            .then((result) => result.result);
        const expected = JenkinsBuildingJob(
          name: 'master',
          fullName: 'test/master',
          builds: [],
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(".fetchJobs() should fail if a job is not found", () {
      final result =
          jenkinsClient.fetchJobs('name').then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test(
      ".fetchJobs() should respond with a list of jobs",
      () {
        final result =
            jenkinsClient.fetchJobs('test').then((result) => result.result);
        const expected = [
          JenkinsBuildingJob(
            name: 'master',
            fullName: 'test/master',
            builds: [],
          ),
        ];

        expect(result, completion(equals(expected)));
      },
    );

    test(".fetchJobs() should apply limits to request if provided", () {
      final result = jenkinsClient
          .fetchJobs('test', limits: JenkinsQueryLimits.endBefore(0))
          .then((result) => result.result);
      const expected = [];

      expect(result, completion(equals(expected)));
    });

    test(
      ".fetchJobsByUrl() should fail if a multi-branch job is not found",
      () {
        final result = jenkinsClient
            .fetchJobsByUrl('${jenkinsMockServer.url}/job/name')
            .then((result) => result.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".fetchJobsByUrl() should respond with a list of jobs",
      () {
        final result = jenkinsClient
            .fetchJobsByUrl('${jenkinsMockServer.url}/job/test')
            .then((result) => result.result);
        const expected = [
          JenkinsBuildingJob(
            name: 'master',
            fullName: 'test/master',
            builds: [],
          ),
        ];

        expect(result, completion(equals(expected)));
      },
    );

    test(".fetchJobsByUrl() should apply limits to request if provided", () {
      final result = jenkinsClient
          .fetchJobsByUrl(
            '${jenkinsMockServer.url}/job/test',
            limits: JenkinsQueryLimits.endBefore(0),
          )
          .then((result) => result.result);
      const expected = [];

      expect(result, completion(equals(expected)));
    });

    test(".fetchBuilds() should fail if a building job is not found", () {
      final result = jenkinsClient
          .fetchBuilds('test/dev')
          .then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test(
      ".fetchBuilds() should respond with a building job populated with builds related data",
      () {
        final result = jenkinsClient
            .fetchBuilds('test/master')
            .then((result) => result.result);

        final expected = JenkinsBuildingJob(
          name: 'master',
          fullName: 'test/master',
          builds: [firstBuild, lastBuild],
          firstBuild: firstBuild,
          lastBuild: lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuilds() should apply limits to request if provided",
      () {
        final result = jenkinsClient
            .fetchBuilds(
              'test/master',
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

    test(".fetchBuildsByUrl() should fail if a building job is not found", () {
      final result = jenkinsClient
          .fetchBuildsByUrl('${jenkinsMockServer.url}/job/test/job/dev')
          .then((result) => result.isError);

      expect(result, completion(isTrue));
    });

    test(
      ".fetchBuildsByUrl() should respond with a building job populated with builds related data",
      () {
        final result = jenkinsClient
            .fetchBuildsByUrl('${jenkinsMockServer.url}/job/test/job/master')
            .then((result) => result.result);

        final expected = JenkinsBuildingJob(
          name: 'master',
          fullName: 'test/master',
          builds: [firstBuild, lastBuild],
          firstBuild: firstBuild,
          lastBuild: lastBuild,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsByUrl() should apply limits to request if provided",
      () {
        final result = jenkinsClient
            .fetchBuildsByUrl(
              '${jenkinsMockServer.url}/job/test/job/master',
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
      ".fetchArtifactsByBuildUrl() should fail if build with the given url is not found",
      () {
        final url = '${jenkinsMockServer.url}/job/test/job/master/10';
        final result = jenkinsClient
            .fetchArtifactsByBuildUrl(url)
            .then((result) => result.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".fetchArtifactsByBuildUrl() should respond with a list of artifacts for the build matching given url",
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
      ".fetchArtifactsByBuildUrl() should apply limits to request if provided",
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
      ".fetchArtifactByRelativePath() should fail if artifact is not found",
      () {
        final url = '${jenkinsMockServer.url}/job/test/job/master/10';
        final result = jenkinsClient
            .fetchArtifactByRelativePath(url, 'coverage/test.json')
            .then((result) => result.isError);

        expect(result, completion(isTrue));
      },
    );

    test(
      ".fetchArtifactByRelativePath() should respond with an artifact content",
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
      ".fetchArtifact() should fail if the given artifact is not found for the given build",
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

    test(".fetchArtifact() should respond with an artifact content", () {
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
