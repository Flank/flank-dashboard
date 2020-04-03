import 'package:ci_integration/firestore/deserializer/build_data_deserializer.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group('BuildDataDeserializer', () {
    const id = 'id';
    final buildData = BuildData(
      id: id,
      duration: const Duration(milliseconds: 100000),
      startedAt: DateTime.now(),
      url: 'testUrl',
      buildNumber: 1,
      buildStatus: BuildStatus.failed,
      workflowName: 'testWorkflowName',
      coverage: const Percent(1.0),
    );

    test(
      '.fromJson() should throw NoSuchMethodError if a given json is null',
      () {
        expect(
          () => BuildDataDeserializer.fromJson(null, id),
          throwsNoSuchMethodError,
        );
      },
    );

    test('.fromJson() should return BuildData from a json map', () {
      expect(
        BuildDataDeserializer.fromJson(buildData.toJson(), id),
        equals(buildData),
      );
    });
  });
}
