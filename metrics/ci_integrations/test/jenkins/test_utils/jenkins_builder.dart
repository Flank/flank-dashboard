import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_artifact.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_build_result.dart';
import 'package:ci_integration/jenkins/util/number_validator.dart';

class JenkinsBuilder {
  JenkinsBuild getBuild({
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

  List<JenkinsBuild> getBuilds({
    int number = 30,
    int buildNumberStep = 1,
    int startingBuildNumber = 1,
  }) {
    NumberValidator.checkPositive(number);
    NumberValidator.checkPositive(buildNumberStep);
    return List.generate(
      number,
      (index) {
        final number = startingBuildNumber + index * buildNumberStep;
        return getBuild(
          number: number,
          url: 'url/$number',
        );
      },
    );
  }

  Map<String, dynamic> getCoverage([int percent = 60]) {
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
