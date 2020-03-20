import 'package:ci_integration/jenkins/client/model/jenkins_build_artifact.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsBuildArtifact", () {
    const fileName = 'file.json';
    const relativePath = 'files/file.json';

    const artifactJson = {
      'fileName': fileName,
      'relativePath': relativePath,
    };

    const buildArtifact = JenkinsBuildArtifact(
      fileName: fileName,
      relativePath: relativePath,
    );

    test(".fromJson() should return null if a given json is null", () {
      final job = JenkinsBuildArtifact.fromJson(null);

      expect(job, isNull);
    });

    test(".fromJson() should create an instance from a json map", () {
      final job = JenkinsBuildArtifact.fromJson(artifactJson);

      expect(job, equals(buildArtifact));
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
          artifactJson,
        ]);

        expect(jobs, equals([buildArtifact, buildArtifact]));
      },
    );

    test(".toJson() should convert an instance to the json map", () {
      final json = buildArtifact.toJson();

      expect(json, equals(artifactJson));
    });
  });
}
