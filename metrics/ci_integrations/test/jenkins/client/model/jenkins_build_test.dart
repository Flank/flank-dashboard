import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:ci_integration/jenkins/util/jenkins_util.dart';
import 'package:test/test.dart';

import '../test_data/jenkins_artifacts_test_data.dart';

void main() {
  group("JenkinsBuild", () {
    const number = 1;
    const duration = 10;
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
      duration: const Duration(seconds: duration),
      timestamp: timestamp,
      result: JenkinsUtil.mapJenkinsBuildResult(result),
      url: url,
      artifacts: JenkinsArtifactsTestData.artifacts,
    );

    test(".fromJson() should return null if a given json is null", () {
      final job = JenkinsBuild.fromJson(null);

      expect(job, isNull);
    });

    test(".fromJson() should create an instance from a json map", () {
      final job = JenkinsBuild.fromJson(buildJson);

      expect(job, equals(jenkinsBuild));
    });

    test(
      ".listFromJson() should map a null list as null one",
      () {
        final jobs = JenkinsBuild.listFromJson(null);

        expect(jobs, isNull);
      },
    );

    test(
      ".listFromJson() should map an empty list as empty one",
      () {
        final jobs = JenkinsBuild.listFromJson([]);

        expect(jobs, isEmpty);
      },
    );

    test(
      ".listFromJson() should map a list of jobs json maps",
      () {
        const _number = number + 1;
        const _duration = duration + 10;
        final _timestamp = timestamp.add(const Duration(days: 1));
        const _result = 'SUCCESS';
        const _url = 'anotherUrl';

        final anotherBuildJson = {
          'number': _number,
          'duration': _duration,
          'timestamp': _timestamp.millisecondsSinceEpoch,
          'result': _result,
          'url': _url,
          'artifacts': null,
        };

        final anotherBuild = JenkinsBuild(
          number: _number,
          duration: const Duration(seconds: _duration),
          timestamp: _timestamp,
          result: JenkinsUtil.mapJenkinsBuildResult(_result),
          url: _url,
        );

        final jobs = JenkinsBuild.listFromJson([buildJson, anotherBuildJson]);

        expect(jobs, equals([jenkinsBuild, anotherBuild]));
      },
    );

    test(".toJson() should convert an instance to the json map", () {
      final json = jenkinsBuild.toJson();

      expect(json, equals(buildJson));
    });
  });
}
