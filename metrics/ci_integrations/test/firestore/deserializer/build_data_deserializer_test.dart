import 'package:ci_integration/firestore/deserializer/build_data_deserializer.dart';
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
    const coverage = Percent(1.0);
    final startedAt = DateTime.now();
    final buildDataJson = {
      'id': id,
      'duration':  duration.inMilliseconds,
      'startedAt': startedAt,
      'url': url,
      'buildNumber': buildNumber,
      'buildStatus': buildStatus.toString(),
      'workflowName': workflowName,
      'coverage': coverage.value,
    };
    final buildData = BuildData(
      id: id,
      duration: duration,
      startedAt: startedAt,
      url: url,
      buildNumber: buildNumber,
      buildStatus: buildStatus,
      workflowName: workflowName,
      coverage: coverage,
    );

    test(
      ".fromJson() should return null if a given json is null",
      () {
        expect(
          () => BuildDataDeserializer.fromJson(null, id),
          throwsNoSuchMethodError,
        );
      },
    );

    test(".fromJson() should return BuildData from a json map", () {
      expect(
        BuildDataDeserializer.fromJson(buildDataJson, id),
        equals(buildData),
      );
    });
  });
}
