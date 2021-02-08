// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_build_artifact.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/jenkins_artifacts_test_data.dart';

void main() {
  group("JenkinsBuildArtifact", () {
    const artifactJson = JenkinsArtifactsTestData.coverageArtifactJson;
    const artifact = JenkinsArtifactsTestData.coverageArtifact;
    const fileArtifactJson = JenkinsArtifactsTestData.fileArtifactJson;
    const fileArtifact = JenkinsArtifactsTestData.fileArtifact;

    test(".fromJson() returns null if a given json is null", () {
      final job = JenkinsBuildArtifact.fromJson(null);

      expect(job, isNull);
    });

    test(".fromJson() creates an instance from a json map", () {
      final job = JenkinsBuildArtifact.fromJson(artifactJson);

      expect(job, equals(artifact));
    });

    test(
      ".listFromJson() maps a null list as null one",
      () {
        final jobs = JenkinsBuildArtifact.listFromJson(null);

        expect(jobs, isNull);
      },
    );

    test(
      ".listFromJson() maps an empty list as empty one",
      () {
        final jobs = JenkinsBuildArtifact.listFromJson([]);

        expect(jobs, isEmpty);
      },
    );

    test(
      ".listFromJson() maps a list of jobs json maps",
      () {
        final jobs = JenkinsBuildArtifact.listFromJson([
          artifactJson,
          fileArtifactJson,
        ]);
        const expected = [artifact, fileArtifact];

        expect(jobs, equals(expected));
      },
    );

    test(".toJson() converts an instance to the json map", () {
      final json = artifact.toJson();

      expect(json, equals(artifactJson));
    });
  });
}
