import 'package:ci_integration/common/model/interaction_result.dart';
import 'package:ci_integration/jenkins/adapter/jenkins_ci_client_adapter.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_result.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_building_job.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_query_limits.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/test_data_builder.dart';

void main() {
  group("JenkinsCiClientAdapter", () {
    const jobName = 'test-job';

    final jenkinsClientMock = JenkinsClientMock();
    final adapter = JenkinsCiClientAdapter(jenkinsClientMock);
    final testDataBuilder = TestDataBuilder();
    final responses = JenkinsClientResponseBuilder(jobName, testDataBuilder);

    setUp(() {
      reset(jenkinsClientMock);
      responses.reset();
    });

    PostExpectation<Future<InteractionResult>> whenFetchArtifact({
      Matcher buildUrlThat,
      Matcher relativePathThat,
    }) {
      return when(jenkinsClientMock.fetchArtifactByRelativePath(
        argThat(buildUrlThat ?? anything),
        argThat(relativePathThat ?? anything),
      ));
    }

    PostExpectation<Future<InteractionResult>> whenFetchBuilds({
      String jobName = jobName,
      JenkinsQueryLimits limits,
    }) {
      whenFetchArtifact().thenAnswer(responses.artifactResponse);
      return when(jenkinsClientMock.fetchBuilds(
        jobName,
        limits: limits ?? anyNamed('limits'),
      ));
    }

    test(
      ".processJenkinsBuilds() should map builds which are not building",
      () {
        final jenkinsBuilds = [
          testDataBuilder.getJenkinsBuild(),
          testDataBuilder.getJenkinsBuild(number: 2, building: true),
        ];
        final expected = [
          testDataBuilder.getBuildData(workflowName: jobName),
        ];

        whenFetchArtifact().thenAnswer(responses.artifactResponse);

        final result = adapter.processJenkinsBuilds(jenkinsBuilds, jobName);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".processJenkinsBuilds() should map builds satisfying the given startFromBuildNumber",
      () {
        final jenkinsBuilds = [
          testDataBuilder.getJenkinsBuild(),
          testDataBuilder.getJenkinsBuild(number: 2),
        ];
        final expected = [
          testDataBuilder.getBuildData(
            buildNumber: 2,
            workflowName: jobName,
          ),
        ];

        whenFetchArtifact().thenAnswer(responses.artifactResponse);

        final result = adapter.processJenkinsBuilds(
          jenkinsBuilds,
          jobName,
          startFromBuildNumber: 1,
        );

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".processJenkinsBuilds() should throw StateError if fetching an artifact content fails for any of the given builds",
      () {
        const fileName = 'coverage-summary.json';
        const relativePath = 'test/$fileName';
        final jenkinsBuild = testDataBuilder.getJenkinsBuild();
        final nonExistingCoverageJenkinsBuild = testDataBuilder.getJenkinsBuild(
          number: 2,
          artifacts: const [
            JenkinsBuildArtifact(
              fileName: fileName,
              relativePath: relativePath,
            ),
          ],
        );
        final jenkinsBuilds = [jenkinsBuild, nonExistingCoverageJenkinsBuild];

        whenFetchArtifact(
          buildUrlThat: equals(jenkinsBuild.url),
          relativePathThat: anything,
        ).thenAnswer(responses.artifactResponse);

        whenFetchArtifact(
          buildUrlThat: equals(nonExistingCoverageJenkinsBuild.url),
          relativePathThat: equals(relativePath),
        ).thenAnswer((_) => responses.errorResponse<Map<String, dynamic>>());

        final result = adapter.processJenkinsBuilds(jenkinsBuilds, jobName);

        expect(result, throwsStateError);
      },
    );

    test(
      ".processJenkinsBuilds() should fetch coverage for each build",
      () async {
        final jenkinsBuilds = [
          testDataBuilder.getJenkinsBuild(),
          testDataBuilder.getJenkinsBuild(number: 2),
          testDataBuilder.getJenkinsBuild(number: 3, artifacts: []),
        ];
        const expected = [Percent(0.6), Percent(0.6), null];

        whenFetchArtifact().thenAnswer(responses.artifactResponse);

        final list = await adapter.processJenkinsBuilds(jenkinsBuilds, jobName);
        final coverages = list.map((buildData) => buildData.coverage).toList();

        expect(coverages, equals(expected));
      },
    );

    test(
      ".processJenkinsBuilds() should map a list of Jenkins builds into the list of BuildData",
      () async {
        final jenkinsBuilds = [
          testDataBuilder.getJenkinsBuild(result: JenkinsBuildResult.failure),
          testDataBuilder.getJenkinsBuild(
              number: 2, result: JenkinsBuildResult.notBuild),
          testDataBuilder.getJenkinsBuild(
              number: 3, result: JenkinsBuildResult.aborted),
          testDataBuilder.getJenkinsBuild(
              number: 4, result: JenkinsBuildResult.unstable),
          testDataBuilder.getJenkinsBuild(
              number: 5, result: JenkinsBuildResult.success),
          testDataBuilder.getJenkinsBuild(number: 6, result: null),
        ];
        final expected = [
          testDataBuilder.getBuildData(
            workflowName: jobName,
            buildStatus: BuildStatus.failed,
          ),
          testDataBuilder.getBuildData(
            buildNumber: 2,
            workflowName: jobName,
            buildStatus: BuildStatus.failed,
          ),
          testDataBuilder.getBuildData(
            buildNumber: 3,
            workflowName: jobName,
            buildStatus: BuildStatus.cancelled,
          ),
          testDataBuilder.getBuildData(
            buildNumber: 4,
            workflowName: jobName,
            buildStatus: BuildStatus.successful,
          ),
          testDataBuilder.getBuildData(
            buildNumber: 5,
            workflowName: jobName,
            buildStatus: BuildStatus.successful,
          ),
          testDataBuilder.getBuildData(
            buildNumber: 6,
            workflowName: jobName,
            buildStatus: BuildStatus.failed,
          ),
        ];

        whenFetchArtifact().thenAnswer(responses.artifactResponse);

        final result = adapter.processJenkinsBuilds(jenkinsBuilds, jobName);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuilds() should throw StateError if a project with the given id is not found",
      () {
        whenFetchBuilds(jobName: 'test-non-job').thenAnswer(
          (_) => responses.errorResponse<JenkinsBuildingJob>(),
        );

        final result = adapter.fetchBuilds('test-non-job');

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() should fetch no more than last 28 builds of a project",
      () {
        const expectedBuildsLength =
            JenkinsCiClientAdapter.initialFetchBuildsLimit;
        responses.prepareBuilds(number: 30);

        whenFetchBuilds().thenAnswer(responses.fetchBuildsResponse);

        final result = adapter.fetchBuilds(jobName);

        expect(
          result,
          completion(hasLength(lessThanOrEqualTo(expectedBuildsLength))),
        );
      },
    );

    test(
      ".fetchBuilds() should fetch all builds",
      () {
        final expected = [
          testDataBuilder.getBuildData(workflowName: jobName),
          testDataBuilder.getBuildData(buildNumber: 2, workflowName: jobName),
          testDataBuilder.getBuildData(buildNumber: 3, workflowName: jobName),
        ];
        responses.prepareBuilds(number: 3);

        whenFetchBuilds().thenAnswer(responses.fetchBuildsResponse);

        final result = adapter.fetchBuilds(jobName);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() should throw an ArgumentError if the given build is null",
      () {
        final result = adapter.fetchBuildsAfter(jobName, null);

        expect(result, throwsArgumentError);
      },
    );

    test(
      ".fetchBuildsAfter() should throw a StateError if a project with the given id is not found",
      () {
        const build = BuildData(buildNumber: 1);

        whenFetchBuilds(jobName: 'test-non-job').thenAnswer(
          (_) => responses.errorResponse<JenkinsBuildingJob>(),
        );

        final result = adapter.fetchBuildsAfter('test-non-job', build);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() should return empty list if there are no new builds",
      () {
        const build = BuildData(buildNumber: 1);
        responses.prepareBuilds(number: 1);

        whenFetchBuilds().thenAnswer(responses.fetchBuildsResponse);

        final result = adapter.fetchBuildsAfter(jobName, build);

        expect(result, completion(isEmpty));
      },
    );

    test(
      ".fetchBuildsAfter() should fetch new builds added during synchronization",
      () {
        const build = BuildData(buildNumber: 1);
        responses.prepareBuilds(number: 3);
        bool additionalBuildsAdded = false;

        whenFetchBuilds().thenAnswer(
          (invocation) => responses.fetchBuildsResponse(
            invocation,
            afterFetchCallback: additionalBuildsAdded
                ? null
                : () {
                    responses.prepareBuilds(number: 2);
                    additionalBuildsAdded = true;
                  },
          ),
        );

        final result = adapter.fetchBuildsAfter(jobName, build);

        expect(result, completion(hasLength(4)));
      },
    );

    test(
      ".fetchBuildsAfter() should act normal if the given build has been deleted",
      () {
        const build = BuildData(buildNumber: 8);
        responses.prepareBuilds(number: 6, buildNumberStep: 2);

        whenFetchBuilds().thenAnswer(
          (invocation) => responses.fetchBuildsResponse(invocation),
        );

        final result = adapter.fetchBuildsAfter(jobName, build);

        expect(result, completion(hasLength(2)));
      },
    );

    test(
      ".fetchBuildsAfter() should act normal on new builds added during synchronization if the given build has been deleted",
      () {
        const build = BuildData(buildNumber: 2);
        responses.prepareBuilds(number: 3, buildNumberStep: 2);
        bool additionalBuildsAdded = false;

        whenFetchBuilds().thenAnswer(
          (invocation) => responses.fetchBuildsResponse(
            invocation,
            afterFetchCallback: additionalBuildsAdded
                ? null
                : () {
                    responses.prepareBuilds(number: 2);
                    additionalBuildsAdded = true;
                  },
          ),
        );

        final result = adapter.fetchBuildsAfter(jobName, build);

        expect(result, completion(hasLength(4)));
      },
    );

    test(
      ".fetchBuildsAfter() should fetch new builds",
      () {
        const build = BuildData(buildNumber: 1);
        responses.prepareBuilds(number: 3);
        final expected = [
          testDataBuilder.getBuildData(buildNumber: 2, workflowName: jobName),
          testDataBuilder.getBuildData(buildNumber: 3, workflowName: jobName),
        ];

        whenFetchBuilds().thenAnswer(responses.fetchBuildsResponse);

        final result = adapter.fetchBuildsAfter(jobName, build);

        expect(result, completion(equals(expected)));
      },
    );

    test(".dispose() should close jenkins client", () {
      adapter.dispose();

      verify(jenkinsClientMock.close()).called(1);
    });
  });
}

class JenkinsClientMock extends Mock implements JenkinsClient {}

class JenkinsClientResponseBuilder {
  final TestDataBuilder _testDataBuilder;
  final String jobName;
  final List<JenkinsBuild> _builds = [];

  JenkinsClientResponseBuilder(this.jobName, this._testDataBuilder);

  void prepareBuilds({
    int number = 30,
    int buildNumberStep = 1,
  }) {
    final startingBuildNumber = _builds.isEmpty ? 1 : _builds.last.number + 1;
    _builds.addAll(_testDataBuilder.getJenkinsBuilds(
      number: number,
      buildNumberStep: buildNumberStep,
      startingFromBuildNumber: startingBuildNumber,
    ));
  }

  Future<InteractionResult<JenkinsBuildingJob>> fetchBuildsResponse(
    Invocation invocation, {
    void Function() afterFetchCallback,
  }) {
    final limits =
        invocation.namedArguments[const Symbol('limits')] as JenkinsQueryLimits;

    final _result = JenkinsBuildingJob(
      name: jobName,
      fullName: jobName,
      url: 'url',
      firstBuild: _builds.first,
      lastBuild: _builds.last,
      builds: _applyLimits(limits).reversed.toList(),
    );

    if (afterFetchCallback != null) {
      afterFetchCallback();
    }

    return _wrapFuture(InteractionResult.success(result: _result));
  }

  List<JenkinsBuild> _applyLimits(JenkinsQueryLimits limits) {
    final _buildsToProcess = _builds.reversed.toList();

    final startIsNull = limits.lower == null;
    final startIsGreaterThanBuildsLength =
        !startIsNull && limits.lower > _buildsToProcess.length;
    final endIsNull = limits.upper == null;
    final endIsGreaterThanBuildsLength =
        !endIsNull && limits.upper > _buildsToProcess.length;

    if (startIsNull && (endIsNull || endIsGreaterThanBuildsLength)) {
      return _buildsToProcess;
    }

    if (startIsGreaterThanBuildsLength) {
      return [];
    }

    return endIsGreaterThanBuildsLength
        ? _buildsToProcess.sublist(limits.lower)
        : _buildsToProcess.sublist(limits.lower ?? 0, limits.upper);
  }

  Future<InteractionResult<Map<String, dynamic>>> artifactResponse([_]) {
    final result = _testDataBuilder.getBuildCoverageArtifact();
    return _wrapFuture(InteractionResult.success(result: result));
  }

  Future<InteractionResult<T>> errorResponse<T>() {
    return _wrapFuture(InteractionResult<T>.error());
  }

  Future<T> _wrapFuture<T>(T value) {
    return Future.value(value);
  }

  void reset() {
    _builds.clear();
  }
}
