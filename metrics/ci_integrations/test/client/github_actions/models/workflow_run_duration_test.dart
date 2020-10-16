import 'package:ci_integration/client/github_actions/models/workflow_run_duration.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("WorkflowRunDuration", () {
    const time = Duration(milliseconds: 5000);

    final durationJson = {
      'run_duration_ms': time.inMilliseconds,
    };

    final duration = WorkflowRunDuration(duration: time);

    test(
      "creates an instance with the given values",
      () {
        const duration = WorkflowRunDuration(duration: time);

        expect(duration.duration, equals(time));
      },
    );

    test(
      ".fromJson returns null if the given json is null",
      () {
        final duration = WorkflowRunDuration.fromJson(null);

        expect(duration, isNull);
      },
    );

    test(
      ".fromJson creates an instance from the given json",
      () {
        final runDuration = WorkflowRunDuration.fromJson(durationJson);

        expect(runDuration, duration);
      },
    );

    test(".toJson() converts an instance to the json map", () {
      final json = duration.toJson();

      expect(json, equals(durationJson));
    });
  });
}
