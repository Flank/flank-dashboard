// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/constants/jenkins_constants.dart';
import 'package:ci_integration/client/jenkins/constants/tree_query.dart';
import 'package:ci_integration/client/jenkins/deserializer/jenkins_build_deserializer.dart';
import 'package:ci_integration/client/jenkins/mapper/jenkins_build_result_mapper.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/jenkins_artifacts_test_data.dart';

void main() {
  group("JenkinsBuildDeserializer", () {
    const resultMapper = JenkinsBuildResultMapper();
    const number = 1;
    const duration = 10000;
    const result = 'FAILURE';
    const url = 'http://test.com';
    final apiUrl = '$url${JenkinsConstants.jsonApiPath}?'
        'tree=${Uri.encodeQueryComponent(TreeQuery.build)}';
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
      apiUrl: apiUrl,
      artifacts: JenkinsArtifactsTestData.artifacts,
    );

    test(".fromJson() returns null if a given json is null", () {
      final build = JenkinsBuildDeserializer.fromJson(null);

      expect(build, isNull);
    });

    test(".fromJson() creates an instance from a json map", () {
      final build = JenkinsBuildDeserializer.fromJson(buildJson);

      expect(build, equals(jenkinsBuild));
    });

    test(
      ".listFromJson() maps a null list as null one",
      () {
        final builds = JenkinsBuildDeserializer.listFromJson(null);

        expect(builds, isNull);
      },
    );

    test(
      ".listFromJson() maps an empty list as empty one",
      () {
        final builds = JenkinsBuildDeserializer.listFromJson([]);

        expect(builds, isEmpty);
      },
    );

    test(
      ".listFromJson() maps a list of builds json maps",
      () {
        const _number = number + 1;
        const _duration = duration + 10000;
        const _result = 'SUCCESS';
        const _url = 'http://test.com/path';
        final _apiUrl = '$_url${JenkinsConstants.jsonApiPath}?'
            'tree=${Uri.encodeQueryComponent(TreeQuery.build)}';
        final _timestamp = timestamp.add(const Duration(days: 1));

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
          apiUrl: _apiUrl,
        );

        final builds = JenkinsBuildDeserializer.listFromJson([
          buildJson,
          anotherBuildJson,
        ]);

        expect(builds, equals([jenkinsBuild, anotherBuild]));
      },
    );
  });
}
