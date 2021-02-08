// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/workflow_run_artifact.dart';
import 'package:test/test.dart';

void main() {
  group("WorkflowRunArtifact", () {
    const id = 1;
    const name = 'TEST';
    const downloadUrl = 'url';

    final artifactJson = <String, dynamic>{
      'id': id,
      'name': name,
      'archive_download_url': downloadUrl,
    };

    const artifact = WorkflowRunArtifact(
      id: id,
      name: name,
      downloadUrl: downloadUrl,
    );

    test(
      "creates an instance with the given values",
      () {
        const artifact = WorkflowRunArtifact(
          id: id,
          name: name,
          downloadUrl: downloadUrl,
        );

        expect(artifact.id, equals(id));
        expect(artifact.name, equals(name));
        expect(artifact.downloadUrl, equals(downloadUrl));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final artifact = WorkflowRunArtifact.fromJson(null);

        expect(artifact, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final runArtifact = WorkflowRunArtifact.fromJson(artifactJson);

        expect(runArtifact, equals(artifact));
      },
    );

    test(
      ".listFromJson() maps a null list to null",
      () {
        final artifacts = WorkflowRunArtifact.listFromJson(null);

        expect(artifacts, isNull);
      },
    );

    test(
      ".listFromJson() maps an empty list to an empty one",
      () {
        final artifacts = WorkflowRunArtifact.listFromJson([]);

        expect(artifacts, isEmpty);
      },
    );

    test(
      ".listFromJson() maps a list of workflow run artifacts",
      () {
        final anotherArtifactJson = <String, dynamic>{
          'id': id,
          'name': name,
          'archive_download_url': downloadUrl,
        };
        final anotherArtifact =
            WorkflowRunArtifact.fromJson(anotherArtifactJson);

        final jsonList = [artifactJson, anotherArtifactJson];
        final artifacts = WorkflowRunArtifact.listFromJson(jsonList);

        expect(artifacts, equals([artifact, anotherArtifact]));
      },
    );

    test(".toJson() converts an instance to the json map", () {
      final json = artifact.toJson();

      expect(json, equals(artifactJson));
    });
  });
}
