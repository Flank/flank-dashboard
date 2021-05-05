// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:functions/deserializers/build_data_deserializer.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDataDeserializer", () {
    const id = 'id';
    const projectId = 'projectId';
    const duration = Duration(milliseconds: 100000);
    const buildStatus = BuildStatus.failed;
    final startedAtDateTime = DateTime.now();
    final startedAt = Timestamp.fromDateTime(startedAtDateTime);
    final buildDataJson = {
      'projectId': projectId,
      'duration': duration.inMilliseconds,
      'startedAt': startedAt,
      'buildStatus': buildStatus.toString(),
    };

    test(
      ".fromJson() creates a BuildData from the JSON-encodable map",
      () {
        final expectedBuildData = BuildData(
          id: id,
          projectId: projectId,
          duration: duration,
          startedAt: startedAtDateTime,
          buildStatus: buildStatus,
        );

        final buildData = BuildDataDeserializer.fromJson(buildDataJson, id: id);

        expect(buildData, equals(expectedBuildData));
      },
    );

    test(
      ".fromJson() creates a BuildData with a null id from the JSON-encodable map if the id is not passed",
      () {
        final expectedBuildData = BuildData(
          id: null,
          projectId: projectId,
          duration: duration,
          startedAt: startedAtDateTime,
          buildStatus: buildStatus,
        );

        final buildData = BuildDataDeserializer.fromJson(buildDataJson);

        expect(buildData, equals(expectedBuildData));
      },
    );
  });
}
