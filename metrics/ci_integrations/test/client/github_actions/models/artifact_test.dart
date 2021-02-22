// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/artifact.dart';
import 'package:test/test.dart';

void main() {
  group("Artifact", () {
    const id = 1;
    const name = 'test';
    const artifact = Artifact(id: id, name: name);
    final artifactJson = {'id': id, 'name': name};

    test("creates an instance with the given values", () {
      const artifact = Artifact(
        id: id,
        name: name,
      );

      expect(artifact.id, equals(id));
      expect(artifact.name, equals(name));
    });

    test(".fromJson() returns null if the given json is null", () {
      final artifact = Artifact.fromJson(null);

      expect(artifact, isNull);
    });

    test(".fromJson() creates an instance from the given json", () {
      final actualArtifact = Artifact.fromJson(artifactJson);

      expect(actualArtifact, equals(artifact));
    });

    test(".listFromJson() maps a null list to null", () {
      final artifacts = Artifact.listFromJson(null);

      expect(artifacts, isNull);
    });

    test(".listFromJson() maps an empty list to an empty one", () {
      final artifacts = Artifact.listFromJson([]);

      expect(artifacts, isEmpty);
    });

    test(".listFromJson() maps a list of artifacts", () {
      final anotherArtifactJson = <String, dynamic>{
        'id': 2,
        'name': "test2",
      };
      final anotherArtifact = Artifact.fromJson(anotherArtifactJson);

      final jsonList = [artifactJson, anotherArtifactJson];
      final artifacts = Artifact.listFromJson(jsonList);

      expect(artifacts, equals([artifact, anotherArtifact]));
    });

    test(".toJson() converts an instance to the json map", () {
      final json = artifact.toJson();

      expect(json, equals(artifactJson));
    });
  });
}
