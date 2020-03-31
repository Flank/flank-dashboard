import 'package:ci_integration/jenkins/client/model/jenkins_build_artifact.dart';
import 'package:test/test.dart';

import '../test_data/jenkins_artifacts_test_data.dart';

void main() {
  group("JenkinsBuildArtifact", () {
    const artifactJson = JenkinsArtifactsTestData.coverageArtifactJson;
    const artifact = JenkinsArtifactsTestData.coverageArtifact;
    const fileArtifactJson = JenkinsArtifactsTestData.fileArtifactJson;
    const fileArtifact = JenkinsArtifactsTestData.fileArtifact;

    test(".fromJson() should return null if a given json is null", () {
      final job = JenkinsBuildArtifact.fromJson(null);

      expect(job, isNull);
    });

    test(".fromJson() should create an instance from a json map", () {
      final job = JenkinsBuildArtifact.fromJson(artifactJson);

      expect(job, equals(artifact));
    });

    test(
      ".listFromJson() should map a null list as null one",
      () {
        final jobs = JenkinsBuildArtifact.listFromJson(null);

        expect(jobs, isNull);
      },
    );

    test(
      ".listFromJson() should map an empty list as empty one",
      () {
        final jobs = JenkinsBuildArtifact.listFromJson([]);

        expect(jobs, isEmpty);
      },
    );

    test(
      ".listFromJson() should map a list of jobs json maps",
      () {
        final jobs = JenkinsBuildArtifact.listFromJson([
          artifactJson,
          fileArtifactJson,
        ]);
        const expected = [artifact, fileArtifact];

        expect(jobs, equals(expected));
      },
    );

    test(".toJson() should convert an instance to the json map", () {
      final json = artifact.toJson();

      expect(json, equals(artifactJson));
    });
  });
}
