// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/mapper/jenkins_build_result_mapper.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
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

    test(".fromJson() returns null if a given json is null", () {
      final job = JenkinsBuild.fromJson(null);

      expect(job, isNull);
    });

    test(".fromJson() creates an instance from a json map", () {
      final job = JenkinsBuild.fromJson(buildJson);

      expect(job, equals(jenkinsBuild));
    });

    test(
      ".listFromJson() maps a null list as null one",
      () {
        final jobs = JenkinsBuild.listFromJson(null);

        expect(jobs, isNull);
      },
    );

    test(
      ".listFromJson() maps an empty list as empty one",
      () {
        final jobs = JenkinsBuild.listFromJson([]);

        expect(jobs, isEmpty);
      },
    );

    test(
      ".listFromJson() maps a list of jobs json maps",
      () {
        const _number = number + 1;
        const _duration = duration + 10000;
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
          duration: const Duration(milliseconds: _duration),
          timestamp: _timestamp,
          result: resultMapper.map(_result),
          url: _url,
        );

        final jobs = JenkinsBuild.listFromJson([buildJson, anotherBuildJson]);

        expect(jobs, equals([jenkinsBuild, anotherBuild]));
      },
    );

    test(".toJson() converts an instance to the json map", () {
      final json = jenkinsBuild.toJson();

      expect(json, equals(buildJson));
    });
  });
}
