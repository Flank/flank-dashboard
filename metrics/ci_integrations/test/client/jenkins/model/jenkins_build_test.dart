// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/mapper/jenkins_build_result_mapper.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_result.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/jenkins_artifacts_test_data.dart';

void main() {
  group("JenkinsBuild", () {
    const resultMapper = JenkinsBuildResultMapper();
    const number = 1;
    const duration = 10000;
    const result = 'FAILURE';
    const url = 'url';
    final timestamp = DateTime(2020);

    final buildJson = {
      'number': number,
      'duration': duration,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'result': result,
      'url': url,
      'artifacts': JenkinsArtifactsTestData.artifactsJson,
    };

    final jenkinsBuild = JenkinsBuild(
      number: number,
      duration: const Duration(milliseconds: duration),
      timestamp: timestamp,
      result: resultMapper.map(result),
      url: url,
      artifacts: JenkinsArtifactsTestData.artifacts,
    );

    test("creates a new instance with the given parameters", () {
      const duration = Duration(milliseconds: 10000);
      const result = JenkinsBuildResult.aborted;
      const artifacts = JenkinsArtifactsTestData.artifacts;
      const apiUrl = 'api-url';

      final jenkinsBuild = JenkinsBuild(
        number: number,
        duration: duration,
        timestamp: timestamp,
        result: result,
        url: url,
        apiUrl: apiUrl,
        artifacts: artifacts,
      );

      expect(jenkinsBuild.number, equals(number));
      expect(jenkinsBuild.duration, equals(duration));
      expect(jenkinsBuild.timestamp, equals(timestamp));
      expect(jenkinsBuild.result, equals(result));
      expect(jenkinsBuild.url, equals(url));
      expect(jenkinsBuild.apiUrl, equals(apiUrl));
      expect(jenkinsBuild.artifacts, equals(artifacts));
    });

    test(".toJson() converts an instance to the json map", () {
      final json = jenkinsBuild.toJson();

      expect(json, equals(buildJson));
    });
  });
}
