// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:functions/models/document_change_data.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("DocumentChangeData", () {
    const beforeProjectId = '1';
    const afterProjectId = '2';
    const buildNumber = 1;
    const buildStatus = BuildStatus.failed;
    const duration = Duration(milliseconds: 100000);
    const workflowName = 'testWorkflowName';
    const url = 'testUrl';
    const apiUrl = 'testApiUrl';

    final startedAt = DateTime.now();
    final coverage = Percent(1.0);

    final beforeUpdateData = BuildData(
      projectId: beforeProjectId,
      buildNumber: buildNumber,
      startedAt: startedAt,
      buildStatus: buildStatus,
      duration: duration,
      workflowName: workflowName,
      url: url,
      apiUrl: apiUrl,
      coverage: coverage,
    );
    final afterUpdateData = BuildData(
      projectId: afterProjectId,
      buildNumber: buildNumber,
      startedAt: startedAt,
      buildStatus: buildStatus,
      duration: duration,
      workflowName: workflowName,
      url: url,
      apiUrl: apiUrl,
      coverage: coverage,
    );
    final beforeUpdateDataJson = beforeUpdateData.toJson();
    final afterUpdateDataJson = afterUpdateData.toJson();

    test(
      "throws an ArgumentError if the given before update data is null",
      () {
        expect(
          () => DocumentChangeData(
            beforeUpdateData: null,
            afterUpdateData: afterUpdateData,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given after update data is null",
      () {
        expect(
          () => DocumentChangeData(
            beforeUpdateData: beforeUpdateData,
            afterUpdateData: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final documentChangeData = DocumentChangeData(
          beforeUpdateData: beforeUpdateData,
          afterUpdateData: afterUpdateData,
        );

        expect(documentChangeData.beforeUpdateData, equals(beforeUpdateData));
        expect(documentChangeData.afterUpdateData, equals(afterUpdateData));
      },
    );

    test(
      ".toJson() converts an instance to the JSON-encodable map",
      () {
        final expectedJson = {
          'before': beforeUpdateDataJson,
          'after': afterUpdateDataJson,
        };

        final documentChangeData = DocumentChangeData(
          beforeUpdateData: beforeUpdateData,
          afterUpdateData: afterUpdateData,
        );

        final json = documentChangeData.toJson();

        expect(json, equals(expectedJson));
      },
    );

    test(
      ".toJson() uses a before build's JSON to convert to the JSON-encodable map",
      () {
        final documentChangeData = DocumentChangeData(
          beforeUpdateData: beforeUpdateData,
          afterUpdateData: afterUpdateData,
        );

        final json = documentChangeData.toJson();

        expect(json['before'], equals(beforeUpdateDataJson));
      },
    );

    test(
      ".toJson() uses an after build's JSON to convert to the JSON-encodable map",
      () {
        final documentChangeData = DocumentChangeData(
          beforeUpdateData: beforeUpdateData,
          afterUpdateData: afterUpdateData,
        );

        final json = documentChangeData.toJson();

        expect(json['after'], equals(afterUpdateDataJson));
      },
    );
  });
}
