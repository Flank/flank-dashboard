import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/dashboard/data/deserializer/build_data_deserializer.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDataDeserializer", () {
    test(".fromJson() create a BuildData from json encodable map", () {
      const id = 'id';
      const buildNumber = 1;
      final startedAt = DateTime.now();
      const buildStatus = BuildStatus.successful;
      const duration = Duration(minutes: 10);
      const workflowName = 'workflow';
      const url = 'url';
      final coverage = Percent(1.0);

      final buildDataJson = {
        'buildNumber': buildNumber,
        'startedAt': Timestamp.fromDate(startedAt),
        'buildStatus': buildStatus.toString(),
        'duration': duration.inMilliseconds,
        'workflowName': workflowName,
        'url': url,
        'coverage': coverage.value,
      };

      final buildData = BuildDataDeserializer.fromJson(buildDataJson, id);

      expect(buildData.id, id);
      expect(buildData.buildNumber, buildNumber);
      expect(buildData.startedAt, startedAt);
      expect(buildData.duration, duration);
      expect(buildData.workflowName, workflowName);
      expect(buildData.url, url);
      expect(buildData.coverage, coverage);
    });
  });
}
