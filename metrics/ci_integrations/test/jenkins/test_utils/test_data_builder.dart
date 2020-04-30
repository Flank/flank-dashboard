import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_result.dart';
import 'package:ci_integration/jenkins/util/number_validator.dart';
import 'package:metrics_core/metrics_core.dart';

class TestDataBuilder {
  JenkinsBuild getJenkinsBuild({
    int number = JenkinsBuildDefaultValue.number,
    Duration duration = JenkinsBuildDefaultValue.duration,
    DateTime timestamp,
    JenkinsBuildResult result = JenkinsBuildDefaultValue.result,
    String url = JenkinsBuildDefaultValue.url,
    bool building = JenkinsBuildDefaultValue.building,
    List<JenkinsBuildArtifact> artifacts = JenkinsBuildDefaultValue.artifacts,
  }) {
    return JenkinsBuild(
      number: number,
      duration: duration,
      timestamp: timestamp ?? JenkinsBuildDefaultValue.timestamp,
      result: result,
      url: url,
      building: building,
      artifacts: artifacts,
    );
  }

  BuildData getBuildData({
    String id = BuildDataDefaultValue.id,
    int buildNumber = BuildDataDefaultValue.buildNumber,
    DateTime startedAt,
    BuildStatus buildStatus = BuildDataDefaultValue.buildStatus,
    Duration duration = BuildDataDefaultValue.duration,
    String workflowName = BuildDataDefaultValue.workflowName,
    String url = BuildDataDefaultValue.url,
    Percent coverage = BuildDataDefaultValue.coverage,
  }) {
    return BuildData(
      id: id,
      buildNumber: buildNumber,
      startedAt: startedAt ?? BuildDataDefaultValue.startedAt,
      buildStatus: buildStatus,
      duration: duration,
      workflowName: workflowName,
      url: url,
      coverage: coverage,
    );
  }

  List<JenkinsBuild> getJenkinsBuilds({
    int number = 30,
    int buildNumberStep = 1,
    int startingFromBuildNumber = 1,
  }) {
    NumberValidator.checkPositive(number);
    NumberValidator.checkPositive(buildNumberStep);
    return List.generate(
      number,
      (index) {
        final number = startingFromBuildNumber + index * buildNumberStep;
        return getJenkinsBuild(
          number: number,
          url: 'url/$number',
        );
      },
    );
  }

  Map<String, dynamic> getBuildCoverageArtifact([int percent = 60]) {
    return <String, dynamic>{
      'total': {
        'branches': {
          'pct': percent,
        },
      },
    };
  }
}

class JenkinsBuildDefaultValue {
  static const int number = 1;
  static const Duration duration = Duration(seconds: 10);
  static final DateTime timestamp = DateTime(2020);
  static const JenkinsBuildResult result = JenkinsBuildResult.success;
  static const String url = 'url';
  static const bool building = false;
  static const List<JenkinsBuildArtifact> artifacts = [
    JenkinsBuildArtifact(
      fileName: 'coverage-summary.json',
      relativePath: 'coverage/coverage-summary.json',
    ),
  ];
}

class BuildDataDefaultValue {
  static const String id = 'projectId_1';
  static const int buildNumber = 1;
  static const Duration duration = Duration(seconds: 10);
  static final DateTime startedAt = DateTime(2020);
  static const BuildStatus buildStatus = BuildStatus.successful;
  static const String workflowName = 'test-job';
  static const String url = 'url';
  static const Percent coverage = Percent(0.6);
}
