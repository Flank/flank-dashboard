// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/dashboard/data/deserializer/build_data_deserializer.dart';
import 'package:metrics_core/metrics_core.dart' hide BuildDataDeserializer;
import 'package:test/test.dart';

void main() {
  group("BuildDataDeserializer", () {
    const id = 'id';
    const buildNumber = 1;
    final startedAt = DateTime.now();
    const buildStatus = BuildStatus.successful;
    const duration = Duration(minutes: 10);
    const workflowName = 'workflow';
    const apiUrl = 'url';
    const url = 'url';
    final coverage = Percent(1.0);

    final buildDataJson = {
      'buildNumber': buildNumber,
      'startedAt': Timestamp.fromDate(startedAt),
      'buildStatus': buildStatus.toString(),
      'duration': duration.inMilliseconds,
      'workflowName': workflowName,
      'apiUrl': apiUrl,
      'url': url,
      'coverage': coverage.value,
    };

    test(".fromJson() create a BuildData from json encodable map", () {
      final buildData = BuildDataDeserializer.fromJson(buildDataJson, id);

      expect(buildData.id, equals(id));
      expect(buildData.buildNumber, equals(buildNumber));
      expect(buildData.buildStatus, equals(buildStatus));
      expect(buildData.startedAt, equals(startedAt));
      expect(buildData.duration, equals(duration));
      expect(buildData.workflowName, equals(workflowName));
      expect(buildData.apiUrl, equals(apiUrl));
      expect(buildData.url, equals(url));
      expect(buildData.coverage, equals(coverage));
    });

    test(
      ".fromJson() creates a BuildData with unknown build status if the json contains invalid enum value",
      () {
        final _buildDataJson = Map<String, dynamic>.from(buildDataJson);

        _buildDataJson['buildStatus'] = 'invalid';

        final buildData = BuildDataDeserializer.fromJson(_buildDataJson, id);

        expect(buildData.buildStatus, BuildStatus.unknown);
      },
    );
  });
}
