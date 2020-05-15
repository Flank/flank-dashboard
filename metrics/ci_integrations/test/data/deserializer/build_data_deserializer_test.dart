import 'package:ci_integration/data/deserializer/build_data_deserializer.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDataDeserializer", () {
    const id = 'id';
    const duration = Duration(milliseconds: 100000);
    const url = 'testUrl';
    const buildNumber = 1;
    const buildStatus = BuildStatus.failed;
    const workflowName = 'testWorkflowName';
    final coverage = PercentValueObject(1.0);
    final startedAt = DateTime.now();
    final buildDataJson = {
      'id': id,
      'duration': duration.inMilliseconds,
      'startedAt': startedAt,
      'url': url,
      'buildNumber': buildNumber,
      'buildStatus': buildStatus.toString(),
      'workflowName': workflowName,
      'coverage': coverage.value,
    };

    test(
      ".fromJson() should return null if the given JSON is null",
      () {
        final buildData = BuildDataDeserializer.fromJson(null, id);

        expect(buildData, isNull);
      },
    );

    test(".fromJson() should return BuildData from a JSON map", () {
      final expectedBuildData = BuildData(
        id: id,
        duration: duration,
        startedAt: startedAt,
        url: url,
        buildNumber: buildNumber,
        buildStatus: buildStatus,
        workflowName: workflowName,
        coverage: coverage,
      );

      final buildData = BuildDataDeserializer.fromJson(buildDataJson, id);

      expect(buildData, equals(expectedBuildData));
    });
  });
}
