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

import '../test_utils/jenkins_builder.dart';

void main() {
  group("JenkinsCiClientAdapter", () {
    const jobName = 'test-job';
    final jenkinsClientMock = JenkinsClientMock();
    final adapter = JenkinsCiClientAdapter(jenkinsClientMock);
    final jenkinsBuilder = JenkinsBuilder();
    final responses = JenkinsClientResponseBuilder(jobName, jenkinsBuilder);

    setUp(() {
      reset(jenkinsClientMock);
      responses.reset();
    });

    test(
      ".fetchCoverage() should return coverage equal to 0.0 if the given build has no coverage artifact",
      () {
        final jenkinsBuild = jenkinsBuilder.getBuild(artifacts: []);
        final result = adapter.fetchCoverage(jenkinsBuild);
        const expected = Percent(0.0);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchCoverage() should throw StateError if fetching an artifact content fails",
      () {
        const fileName = 'coverage-summary.json';
        const relativePath = 'test/$fileName';
        final jenkinsBuild = jenkinsBuilder.getBuild(artifacts: const [
          JenkinsBuildArtifact(fileName: fileName, relativePath: relativePath),
        ]);
        when(jenkinsClientMock.fetchArtifactByRelativePath(
          jenkinsBuild.url,
          relativePath,
        )).thenAnswer(responses.errorResponse);
        final result = adapter.fetchCoverage(jenkinsBuild);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchCoverage() should fetch coverage of the given build",
      () {
        final jenkinsBuild = jenkinsBuilder.getBuild();
        final artifact = jenkinsBuild.artifacts.first;
        when(jenkinsClientMock.fetchArtifactByRelativePath(
          jenkinsBuild.url,
          artifact.relativePath,
        )).thenAnswer(responses.artifactResponse);
        final result = adapter.fetchCoverage(jenkinsBuild);
        const expected = Percent(0.6);

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".processJenkinsBuilds() should map builds which are not building",
      () {
        final jenkinsBuilds = [
          jenkinsBuilder.getBuild(),
          jenkinsBuilder.getBuild(number: 2, building: true),
        ];
        when(jenkinsClientMock.fetchArtifactByRelativePath(
          argThat(anything),
          argThat(anything),
        )).thenAnswer(responses.artifactResponse);
        final result = adapter.processJenkinsBuilds(jenkinsBuilds, jobName);
        final expected = [
          BuildData(
            buildNumber: 1,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.successful,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
        ];

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".processJenkinsBuilds() should map builds satisfying the given startFromBuildNumber",
      () {
        final jenkinsBuilds = [
          jenkinsBuilder.getBuild(),
          jenkinsBuilder.getBuild(number: 2),
        ];
        when(jenkinsClientMock.fetchArtifactByRelativePath(
          argThat(anything),
          argThat(anything),
        )).thenAnswer(responses.artifactResponse);
        final result = adapter.processJenkinsBuilds(
          jenkinsBuilds,
          jobName,
          startFromBuildNumber: 1,
        );
        final expected = [
          BuildData(
            buildNumber: 2,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.successful,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
        ];

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".processJenkinsBuilds() should fetch coverage for each build",
      () async {
        final jenkinsBuilds = [
          jenkinsBuilder.getBuild(),
          jenkinsBuilder.getBuild(number: 2),
        ];
        when(jenkinsClientMock.fetchArtifactByRelativePath(
          argThat(anything),
          argThat(anything),
        )).thenAnswer(responses.artifactResponse);
        await adapter.processJenkinsBuilds(jenkinsBuilds, jobName);

        verify(jenkinsClientMock.fetchArtifactByRelativePath(
          argThat(anything),
          argThat(anything),
        )).called(equals(jenkinsBuilds.length));
      },
    );

    test(
      ".processJenkinsBuilds() should map a list of Jenkins builds into the list of BuildData",
      () async {
        final jenkinsBuilds = [
          jenkinsBuilder.getBuild(result: JenkinsBuildResult.failure),
          jenkinsBuilder.getBuild(
              number: 2, result: JenkinsBuildResult.notBuild),
          jenkinsBuilder.getBuild(
              number: 3, result: JenkinsBuildResult.aborted),
          jenkinsBuilder.getBuild(
              number: 4, result: JenkinsBuildResult.unstable),
          jenkinsBuilder.getBuild(
              number: 5, result: JenkinsBuildResult.success),
          jenkinsBuilder.getBuild(number: 6, result: null),
        ];
        when(jenkinsClientMock.fetchArtifactByRelativePath(
          argThat(anything),
          argThat(anything),
        )).thenAnswer(responses.artifactResponse);
        final result = adapter.processJenkinsBuilds(jenkinsBuilds, jobName);
        final expected = [
          BuildData(
            buildNumber: 1,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.failed,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
          BuildData(
            buildNumber: 2,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.failed,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
          BuildData(
            buildNumber: 3,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.cancelled,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
          BuildData(
            buildNumber: 4,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.successful,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
          BuildData(
            buildNumber: 5,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.successful,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
          BuildData(
            buildNumber: 6,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.failed,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
        ];

        expect(result, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuilds() should throw StateError if a project with the given id is not found",
      () {
        when(
          jenkinsClientMock.fetchBuilds(
            'test-non-job',
            limits: anyNamed('limits'),
          ),
        ).thenAnswer(responses.errorResponse);
        final future = adapter.fetchBuilds('test-non-job');

        expect(future, throwsStateError);
      },
    );

    test(
      ".fetchBuilds() should fetch no more than last 28 builds of a project",
      () {
        responses.prepareBuilds();
        when(
          jenkinsClientMock.fetchBuilds(jobName, limits: anyNamed('limits')),
        ).thenAnswer(responses.fetchBuildsResponse);
        when(
          jenkinsClientMock.fetchArtifactByRelativePath(
            argThat(anything),
            argThat(anything),
          ),
        ).thenAnswer(responses.artifactResponse);
        final future = adapter.fetchBuilds(jobName);
        const expectedBuildsLength =
            JenkinsCiClientAdapter.initialFetchBuildsLimit;

        expect(
          future,
          completion(hasLength(lessThanOrEqualTo(expectedBuildsLength))),
        );
      },
    );

    test(
      ".fetchBuilds() should fetch all builds",
      () {
        responses.prepareBuilds(number: 3);
        when(jenkinsClientMock.fetchBuilds(
          jobName,
          limits: anyNamed('limits'),
        )).thenAnswer(responses.fetchBuildsResponse);
        when(
          jenkinsClientMock.fetchArtifactByRelativePath(
            argThat(anything),
            argThat(anything),
          ),
        ).thenAnswer(responses.artifactResponse);
        final future = adapter.fetchBuilds(jobName);
        final expected = [
          BuildData(
            buildNumber: 1,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.successful,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
          BuildData(
            buildNumber: 2,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.successful,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
          BuildData(
            buildNumber: 3,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.successful,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
        ];

        expect(future, completion(equals(expected)));
      },
    );

    test(
      ".fetchBuildsAfter() should throw an ArgumentError if the given build is null",
      () {
        final future = adapter.fetchBuildsAfter(jobName, null);

        expect(future, throwsArgumentError);
      },
    );

    test(
      ".fetchBuildsAfter() should throw a StateError if a project with the given id is not found",
      () {
        const build = BuildData(buildNumber: 1);
        when(
          jenkinsClientMock.fetchBuilds(
            'test-non-job',
            limits: anyNamed('limits'),
          ),
        ).thenAnswer(responses.errorResponse);
        final future = adapter.fetchBuildsAfter('test-non-job', build);

        expect(future, throwsStateError);
      },
    );

    test(
      ".fetchBuildsAfter() should return empty list if there are no new builds",
      () {
        const build = BuildData(buildNumber: 1);
        responses.prepareBuilds(number: 1);
        when(jenkinsClientMock.fetchBuilds(
          jobName,
          limits: anyNamed('limits'),
        )).thenAnswer(responses.fetchBuildsResponse);
        final future = adapter.fetchBuildsAfter(jobName, build);

        expect(future, completion(isEmpty));
      },
    );

    test(
      ".fetchBuildsAfter() should fetch new builds added during synchronization",
      () {
        const build = BuildData(buildNumber: 1);
        responses.prepareBuilds(number: 3);
        bool additionalBuildsAdded = false;
        when(jenkinsClientMock.fetchBuilds(
          jobName,
          limits: anyNamed('limits'),
        )).thenAnswer(
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
        when(
          jenkinsClientMock.fetchArtifactByRelativePath(
            argThat(anything),
            argThat(anything),
          ),
        ).thenAnswer(responses.artifactResponse);
        final future = adapter.fetchBuildsAfter(jobName, build);

        expect(future, completion(hasLength(4)));
      },
    );

    test(
      ".fetchBuildsAfter() should act normal if the given build has been deleted",
      () {
        const build = BuildData(buildNumber: 4);
        responses.prepareBuilds(number: 10, buildNumberStep: 2);
        when(jenkinsClientMock.fetchBuilds(
          jobName,
          limits: anyNamed('limits'),
        )).thenAnswer(responses.fetchBuildsResponse);
        when(
          jenkinsClientMock.fetchArtifactByRelativePath(
            argThat(anything),
            argThat(anything),
          ),
        ).thenAnswer(responses.artifactResponse);
        final future = adapter.fetchBuildsAfter(jobName, build);

        expect(future, completion(hasLength(8)));
      },
    );

    test(
      ".fetchBuildsAfter() should act normal on new builds added during synchronization if the given build has been deleted",
      () {
        const build = BuildData(buildNumber: 2);
        responses.prepareBuilds(number: 3, buildNumberStep: 2);
        bool additionalBuildsAdded = false;
        when(jenkinsClientMock.fetchBuilds(
          jobName,
          limits: anyNamed('limits'),
        )).thenAnswer(
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
        when(
          jenkinsClientMock.fetchArtifactByRelativePath(
            argThat(anything),
            argThat(anything),
          ),
        ).thenAnswer(responses.artifactResponse);
        final future = adapter.fetchBuildsAfter(jobName, build);

        expect(future, completion(hasLength(4)));
      },
    );

    test(
      ".fetchBuildsAfter() should fetch new builds",
      () {
        const build = BuildData(buildNumber: 1);
        responses.prepareBuilds(number: 3);
        when(jenkinsClientMock.fetchBuilds(
          jobName,
          limits: anyNamed('limits'),
        )).thenAnswer(responses.fetchBuildsResponse);
        when(
          jenkinsClientMock.fetchArtifactByRelativePath(
            argThat(anything),
            argThat(anything),
          ),
        ).thenAnswer(responses.artifactResponse);
        final future = adapter.fetchBuildsAfter(jobName, build);
        final expected = [
          BuildData(
            buildNumber: 2,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.successful,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
          BuildData(
            buildNumber: 3,
            startedAt: DateTime(2020),
            buildStatus: BuildStatus.successful,
            duration: const Duration(seconds: 10),
            workflowName: jobName,
            url: 'url',
            coverage: const Percent(0.6),
          ),
        ];

        expect(future, completion(equals(expected)));
      },
    );
  });
}

class JenkinsClientMock extends Mock implements JenkinsClient {}

class JenkinsClientResponseBuilder {
  final JenkinsBuilder _jenkinsBuilder;
  final String jobName;
  final List<JenkinsBuild> _builds = [];

  JenkinsClientResponseBuilder(this.jobName, this._jenkinsBuilder);

  void prepareBuilds({
    int number = 30,
    int buildNumberStep = 1,
  }) {
    final startingBuildNumber = _builds.isEmpty ? 1 : _builds.last.number + 1;
    _builds.addAll(_jenkinsBuilder.getBuilds(
      number: number,
      buildNumberStep: buildNumberStep,
      startingBuildNumber: startingBuildNumber,
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

    return wrapFuture(InteractionResult.success(result: _result));
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
    final result = _jenkinsBuilder.getCoverage();
    return wrapFuture(InteractionResult.success(result: result));
  }

  Future<InteractionResult<T>> errorResponse<T>([_]) {
    return wrapFuture(const InteractionResult.error());
  }

  Future<T> wrapFuture<T>(T value) {
    return Future.value(value);
  }

  void reset() {
    _builds.clear();
  }
}
