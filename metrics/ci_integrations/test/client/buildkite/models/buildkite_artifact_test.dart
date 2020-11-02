import 'package:ci_integration/client/buildkite/models/buildkite_artifact.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("BuildkiteArtifact", () {
    const id = "1";
    const filename = 'test';
    const downloadUrl = 'url';
    const mimeType = 'application/x-gzip';

    final artifactJson = <String, dynamic>{
      'id': id,
      'filename': filename,
      'download_url': downloadUrl,
      'mime_type': mimeType
    };

    final expectedArtifact = BuildkiteArtifact(
      id: id,
      filename: filename,
      downloadUrl: downloadUrl,
      mimeType: mimeType,
    );

    test("creates an instance with the given values", () {
      final artifact = BuildkiteArtifact(
        id: id,
        filename: filename,
        downloadUrl: downloadUrl,
        mimeType: mimeType,
      );

      expect(artifact.id, equals(id));
      expect(artifact.filename, equals(filename));
      expect(artifact.downloadUrl, equals(downloadUrl));
      expect(artifact.mimeType, equals(mimeType));
    });

    test(".fromJson returns null if the given json is null", () {
      final artifact = BuildkiteArtifact.fromJson(null);

      expect(artifact, isNull);
    });

    test(".fromJson creates an instance from the given json", () {
      final artifact = BuildkiteArtifact.fromJson(artifactJson);

      expect(artifact, equals(expectedArtifact));
    });

    test(".listFromJson() maps a null list to null", () {
      final artifacts = BuildkiteArtifact.listFromJson(null);

      expect(artifacts, isNull);
    });

    test(".listFromJson() maps an empty list to an empty one", () {
      final artifacts = BuildkiteArtifact.listFromJson([]);

      expect(artifacts, isEmpty);
    });

    test(".listFromJson() maps a list of build's artifacts", () {
      final anotherArtifactJson = <String, dynamic>{
        'id': id,
        'filename': filename,
        'download_url': downloadUrl,
        'mime_type': mimeType,
      };
      final anotherArtifact = BuildkiteArtifact.fromJson(anotherArtifactJson);

      final jsonList = [artifactJson, anotherArtifactJson];
      final artifacts = BuildkiteArtifact.listFromJson(jsonList);

      expect(artifacts, equals([expectedArtifact, anotherArtifact]));
    });

    test(".toJson() converts an instance to the json map", () {
      final json = expectedArtifact.toJson();

      expect(json, equals(artifactJson));
    });
  });
}
