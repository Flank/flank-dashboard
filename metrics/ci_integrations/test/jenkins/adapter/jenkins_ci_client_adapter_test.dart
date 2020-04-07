import 'package:ci_integration/common/model/interaction_result.dart';
import 'package:ci_integration/jenkins/adapter/jenkins_ci_client_adapter.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_result.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_building_job.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_query_limits.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsCiClientAdapter", () {
    final jenkinsClientMock = JenkinsClientMock();
    final adapter = JenkinsCiClientAdapter(jenkinsClientMock);
    final responses = JenkinsClientResponseBuilder('test-job');

    setUp(() {
      reset(jenkinsClientMock);
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
        final jenkinsBuild = JenkinsBuild(
          number: 1,
          duration: const Duration(seconds: 10),
          timestamp: DateTime.now(),
          result: JenkinsBuildResult.success,
          url: 'url',
          building: true,
        );
        final result = adapter.checkBuildFinishedAndInRange(jenkinsBuild, 0);

        expect(result, isFalse);
      },
    );

    test(
      ".checkBuildFinishedAndInRange() should return false if the given build number is less than or equal to the given range",
      () {
        final jenkinsBuild = JenkinsBuild(
          number: 1,
          duration: const Duration(seconds: 10),
          timestamp: DateTime.now(),
          result: JenkinsBuildResult.success,
          url: 'url',
          building: false,
        );
        final result = adapter.checkBuildFinishedAndInRange(jenkinsBuild, 1);

        expect(result, isFalse);
      },
    );

    test(
      ".checkBuildFinishedAndInRange() should ignore the given range if it is null",
      () {
        final jenkinsBuild = JenkinsBuild(
          number: 1,
          duration: const Duration(seconds: 10),
          timestamp: DateTime.now(),
          result: JenkinsBuildResult.success,
          url: 'url',
          building: false,
        );
        final result = adapter.checkBuildFinishedAndInRange(jenkinsBuild, null);

        expect(result, isTrue);
      },
    );

    test(
      ".checkBuildFinishedAndInRange() should ignore the given range if it is negative",
      () {
        final jenkinsBuild = JenkinsBuild(
          number: 1,
          duration: const Duration(seconds: 10),
          timestamp: DateTime.now(),
          result: JenkinsBuildResult.success,
          url: 'url',
          building: false,
        );
        final result = adapter.checkBuildFinishedAndInRange(jenkinsBuild, -1);

        expect(result, isTrue);
      },
    );

    test(
      ".checkBuildFinishedAndInRange() should return true if the given build is finished and satisfies the given range",
      () {
        final jenkinsBuild = JenkinsBuild(
          number: 2,
          duration: const Duration(seconds: 10),
          timestamp: DateTime.now(),
          result: JenkinsBuildResult.success,
          url: 'url',
          building: false,
        );
        final result = adapter.checkBuildFinishedAndInRange(jenkinsBuild, 1);

        expect(result, isTrue);
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
        when(
          jenkinsClientMock.fetchBuilds(
            'test-job',
            limits: anyNamed('limits'),
          ),
        ).thenAnswer(responses.fetchBuildsResponse);
        final future = adapter.fetchBuilds('test-job');
        const expectedBuildsLength =
            JenkinsCiClientAdapter.initialFetchBuildsLimit;

        expect(
          future,
          completion(hasLength(lessThanOrEqualTo(expectedBuildsLength))),
        );
      },
    );
  });
}

class JenkinsClientMock extends Mock implements JenkinsClient {}

class JenkinsClientResponseBuilder {
  final String jobName;
  List<JenkinsBuild> _builds;

  JenkinsClientResponseBuilder(this.jobName) {
    _builds = List.generate(30, (index) {
      return JenkinsBuild(
        number: index + 1,
        duration: const Duration(seconds: 10),
        timestamp: DateTime.now().subtract(Duration(days: index)),
        result: JenkinsBuildResult.values[index % 4],
        url: 'url/$index',
        building: false,
        artifacts: const [
          JenkinsBuildArtifact(
            fileName: 'coverage-summary.json',
            relativePath: 'coverage/coverage-summary.json',
          ),
        ],
      );
    });
  }

  Future<InteractionResult<JenkinsBuildingJob>> fetchBuildsResponse(
    Invocation invocation,
  ) {
    final limits =
        invocation.namedArguments[const Symbol('limits')] as JenkinsQueryLimits;
    final _jobName = invocation.positionalArguments.first as String;

    if (_jobName == jobName) {
      final result = JenkinsBuildingJob(
        name: _jobName,
        fullName: _jobName,
        url: 'url',
        firstBuild: null,
        lastBuild: null,
        builds: const [],
//        builds: limits.upper == null
//            ? _builds.sublist(limits.lower ?? 0)
//            : _builds.sublist(limits.lower ?? 0, limits.upper),
      );
      return wrapFuture(InteractionResult.success(result: result));
    } else {
      return wrapFuture(const InteractionResult.error());
    }
  }

  Future<T> wrapFuture<T>(T value) {
    return Future.value(value);
  }
}
