import 'package:ci_integration/jenkins/model/jenkins_build_artifact.dart';
import 'package:test/test.dart';

void main() {
  group('JenkinsBuildArtifact', () {
    const artifactJson = {
      'fileName': 'file.json',
      'relativePath': 'files/file.json',
    };

    const buildArtifact = JenkinsBuildArtifact(
      fileName: 'file.json',
      relativePath: 'files/file.json',
    );

    test('.fromJson() should return null if a given json is null', () {
      final job = JenkinsBuildArtifact.fromJson(null);

      expect(job, isNull);
    });

    test('.fromJson() should create an instance from a json map', () {
      final job = JenkinsBuildArtifact.fromJson(artifactJson);

      expect(job, equals(buildArtifact));
    });

    test(
      '.listFromJson() should map a null list as null one',
      () {
        final jobs = JenkinsBuildArtifact.listFromJson(null);

        expect(jobs, isNull);
      },
    );

    test(
      '.listFromJson() should map an empty list as empty one',
      () {
        final jobs = JenkinsBuildArtifact.listFromJson([]);

        expect(jobs, isEmpty);
      },
    );

    test(
      '.listFromJson() should map a list of jobs json maps',
      () {
        final jobs = JenkinsBuildArtifact.listFromJson([
          artifactJson,
          artifactJson,
        ]);

        expect(jobs, equals([buildArtifact, buildArtifact]));
      },
    );

    test('toJson() should include only non-null properties', () {
      const job = JenkinsBuildArtifact(fileName: 'file.json');
      const expected = {'fileName': 'file.json'};
      final json = job.toJson();

      expect(json, equals(expected));
    });

    test('toJson() should convert an instance to the json map', () {
      final json = buildArtifact.toJson();

      expect(json, equals(artifactJson));
    });
  });
}
