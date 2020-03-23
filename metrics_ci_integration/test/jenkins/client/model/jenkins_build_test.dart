import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';
import 'package:test/test.dart';

import '../../resources/jenkins_artifacts_resources.dart';

void main() {
  group("JenkinsBuild", () {
    const number = 1;
    const duration = 10;
    const result = 'FAILED';
    const url = 'url';
    final timestamp = DateTime(2020);

    final buildJson = {
      'number': number,
      'duration': duration,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'result': result,
      'url': url,
      'artifacts': JenkinsArtifactsResources.artifactsJson,
    };

    final jenkinsBuild = JenkinsBuild(
      number: number,
      duration: const Duration(seconds: duration),
      timestamp: timestamp,
      result: result,
      url: url,
      artifacts: JenkinsArtifactsResources.artifacts,
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
        final jobs = JenkinsBuild.listFromJson([buildJson, buildJson]);

        expect(jobs, equals([jenkinsBuild, jenkinsBuild]));
      },
    );

    test(".toJson() should convert an instance to the json map", () {
      final json = jenkinsBuild.toJson();

      expect(json, equals(buildJson));
    });
  });
}
