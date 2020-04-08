import 'package:ci_integration/common/model/interaction_result.dart';
import 'package:ci_integration/jenkins/adapter/jenkins_ci_client_adapter.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_result.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_building_job.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_query_limits.dart';
import 'package:ci_integration/jenkins/util/number_validator.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsCiClientAdapter", () {
    const jobName = 'test-job';
    final jenkinsClientMock = JenkinsClientMock();
    final adapter = JenkinsCiClientAdapter(jenkinsClientMock);
    final responses = JenkinsClientResponseBuilder(jobName);

    setUp(() {
      reset(jenkinsClientMock);
      responses.reset();
    });

    test(
      "should throw an ArgumentError trying to create an instance with null Jenkins client",
      () {
        expect(() => JenkinsCiClientAdapter(null), throwsArgumentError);
      },
    );

    test(
      ".throwIfInteractionUnsuccessful() should throw StateError if the given InteractionResult is failed",
      () {
        const interactionResult = InteractionResult.error();

        expect(
          () => adapter.throwIfInteractionUnsuccessful(interactionResult),
          throwsStateError,
        );
      },
    );

    test(
      ".throwIfInteractionUnsuccessful() should return normally if the given InteractionResult is successful",
      () {
        const interactionResult = InteractionResult.success();

        expect(
          () => adapter.throwIfInteractionUnsuccessful(interactionResult),
          returnsNormally,
        );
      },
    );

    test(
      ".checkBuildFinishedAndInRange() should return false if the given build is building",
      () {
        final jenkinsBuild = responses.getBuildWith(building: true);
        final result = adapter.checkBuildFinishedAndInRange(jenkinsBuild, 0);

        expect(result, isFalse);
      },
    );

    test(
      ".checkBuildFinishedAndInRange() should return false if the given build number is less than or equal to the given range",
      () {
        final jenkinsBuild = responses.getBuildWith();
        final result = adapter.checkBuildFinishedAndInRange(jenkinsBuild, 1);

        expect(result, isFalse);
      },
    );

    test(
      ".checkBuildFinishedAndInRange() should ignore the given range if it is null",
      () {
        final jenkinsBuild = responses.getBuildWith();
        final result = adapter.checkBuildFinishedAndInRange(jenkinsBuild, null);

        expect(result, isTrue);
      },
    );

    test(
      ".checkBuildFinishedAndInRange() should ignore the given range if it is negative",
      () {
        final jenkinsBuild = responses.getBuildWith();
        final result = adapter.checkBuildFinishedAndInRange(jenkinsBuild, -1);

        expect(result, isTrue);
      },
    );

    test(
      ".checkBuildFinishedAndInRange() should return true if the given build is finished and satisfies the given range",
      () {
        final jenkinsBuild = responses.getBuildWith(number: 2);
        final result = adapter.checkBuildFinishedAndInRange(jenkinsBuild, 1);

        expect(result, isTrue);
      },
    );

    test(
      ".mapJenkinsBuildResult() should map JenkinsBuildResult.aborted to BuildStatus.cancelled",
      () {
        final result =
            adapter.mapJenkinsBuildResult(JenkinsBuildResult.aborted);

        expect(result, equals(BuildStatus.cancelled));
      },
    );

    test(
      ".mapJenkinsBuildResult() should map JenkinsBuildResult.notBuild to BuildStatus.failed",
      () {
        final result =
            adapter.mapJenkinsBuildResult(JenkinsBuildResult.notBuild);

        expect(result, equals(BuildStatus.failed));
      },
    );

    test(
      ".mapJenkinsBuildResult() should map JenkinsBuildResult.failure to BuildStatus.failed",
      () {
        final result =
            adapter.mapJenkinsBuildResult(JenkinsBuildResult.failure);

        expect(result, equals(BuildStatus.failed));
      },
    );

    test(
      ".mapJenkinsBuildResult() should map JenkinsBuildResult.unstable to BuildStatus.successful",
      () {
        final result =
            adapter.mapJenkinsBuildResult(JenkinsBuildResult.unstable);

        expect(result, equals(BuildStatus.successful));
      },
    );

    test(
      ".mapJenkinsBuildResult() should map JenkinsBuildResult.success to BuildStatus.successful",
      () {
        final result =
            adapter.mapJenkinsBuildResult(JenkinsBuildResult.success);

        expect(result, equals(BuildStatus.successful));
      },
    );

    test(
      ".mapJenkinsBuildResult() should map null result to BuildStatus.failed",
      () {
        final result = adapter.mapJenkinsBuildResult(null);

        expect(result, equals(BuildStatus.failed));
      },
    );

    test(
      ".fetchCoverage() should return coverage equal to 0.0 if the given build has no coverage artifact",
      () {
        final jenkinsBuild = responses.getBuildWith(artifacts: []);
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
        final jenkinsBuild = responses.getBuildWith(artifacts: const [
          JenkinsBuildArtifact(fileName: fileName, relativePath: relativePath),
        ]);
        when(jenkinsClientMock.fetchArtifactByRelativePath(
          jenkinsBuild.url,
          relativePath,
        )).thenAnswer(responses.artifactResponse);
        final result = adapter.fetchCoverage(jenkinsBuild);

        expect(result, throwsStateError);
      },
    );

    test(
      ".fetchCoverage() should fetch coverage of the given build",
      () {
        final jenkinsBuild = responses.getBuildWith();
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
          responses.getBuildWith(),
          responses.getBuildWith(number: 2, building: true),
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
          responses.getBuildWith(),
          responses.getBuildWith(number: 2),
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
          responses.getBuildWith(),
          responses.getBuildWith(number: 2),
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
          responses.getBuildWith(),
          responses.getBuildWith(number: 2),
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
      ".fetchBuilds() should throw StateError if a project with the given id is not found",
      () {
        when(
          jenkinsClientMock.fetchBuilds(
            'test-non-job',
            limits: anyNamed('limits'),
          ),
        ).thenAnswer(responses.fetchBuildsResponse);
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
        ).thenAnswer(responses.fetchBuildsResponse);
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
  final String jobName;
  final List<JenkinsBuild> _builds = [];

  JenkinsClientResponseBuilder(this.jobName);

  void prepareBuilds({
    int number = 30,
    int buildNumberStep = 1,
  }) {
    NumberValidator.checkPositive(number);
    NumberValidator.checkPositive(buildNumberStep);
    final startingBuildNumber = _builds.isEmpty ? 1 : _builds.last.number + 1;
    _builds.addAll(List.generate(
      number,
      (index) {
        final number = startingBuildNumber + index * buildNumberStep;
        return getBuildWith(
          number: number,
          url: 'url/$number',
        );
      },
    ));
  }

  JenkinsBuild getBuildWith({
    int number,
    Duration duration,
    DateTime timestamp,
    JenkinsBuildResult result,
    String url,
    bool building,
    List<JenkinsBuildArtifact> artifacts,
  }) {
    const _artifacts = [
      JenkinsBuildArtifact(
        fileName: 'coverage-summary.json',
        relativePath: 'coverage/coverage-summary.json',
      ),
    ];
    return JenkinsBuild(
      number: number ?? 1,
      duration: duration ?? const Duration(seconds: 10),
      timestamp: timestamp ?? DateTime(2020),
      result: result ?? JenkinsBuildResult.success,
      url: url ?? 'url',
      building: building ?? false,
      artifacts: artifacts ?? _artifacts,
    );
  }

  Future<InteractionResult<JenkinsBuildingJob>> fetchBuildsResponse(
    Invocation invocation, {
    void Function() afterFetchCallback,
  }) {
    final limits =
        invocation.namedArguments[const Symbol('limits')] as JenkinsQueryLimits;
    final _jobName = invocation.positionalArguments.first as String;

    Future<InteractionResult<JenkinsBuildingJob>> result;
    if (_jobName == jobName) {
      final _result = JenkinsBuildingJob(
        name: _jobName,
        fullName: _jobName,
        url: 'url',
        firstBuild: _builds.first,
        lastBuild: _builds.last,
        builds: _applyLimits(limits).reversed.toList(),
      );
      result = wrapFuture(InteractionResult.success(result: _result));
    } else {
      result = wrapFuture(const InteractionResult.error());
    }

    if (afterFetchCallback != null) {
      afterFetchCallback();
    }

    return result;
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

  Future<T> wrapFuture<T>(T value) {
    return Future.value(value);
  }

  Future<InteractionResult<Map<String, dynamic>>> artifactResponse(
    Invocation invocation,
  ) {
    final relativePath = invocation.positionalArguments.last as String;

    if (relativePath == 'coverage/coverage-summary.json') {
      final result = <String, dynamic>{
        'total': {
          'branches': {'pct': 60},
        },
      };
      return wrapFuture(InteractionResult.success(result: result));
    } else {
      return wrapFuture(const InteractionResult.error());
    }
  }

  void reset() {
    _builds.clear();
  }
}
