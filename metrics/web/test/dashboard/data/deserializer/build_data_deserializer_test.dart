import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/dashboard/data/deserializer/build_data_deserializer.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDataDeserializer", () {
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

    test(".fromJson() create a BuildData from json encodable map", () {
      final buildData = BuildDataDeserializer.fromJson(buildDataJson, id);

      expect(buildData.id, equals(id));
      expect(buildData.buildNumber, equals(buildNumber));
      expect(buildData.buildStatus, equals(buildStatus));
      expect(buildData.startedAt, equals(startedAt));
      expect(buildData.duration, equals(duration));
      expect(buildData.workflowName, equals(workflowName));
      expect(buildData.url, equals(url));
      expect(buildData.coverage, equals(coverage));
    });

    test(
      ".fromJson() create a BuildData with unknown buildStatus if the json contains invalid enum value",
      () {
        final _buildDataJson = Map<String, dynamic>.from(buildDataJson);

        _buildDataJson['buildStatus'] = 'invalid';

        final buildData = BuildDataDeserializer.fromJson(_buildDataJson, id);

        expect(buildData.buildStatus, BuildStatus.unknown);
      },
    );
  });
}
