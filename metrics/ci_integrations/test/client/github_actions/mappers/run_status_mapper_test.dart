import 'package:ci_integration/client/github_actions/mappers/run_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/run_status.dart';
import 'package:test/test.dart';

void main() {
  group("RunStatusMapper", () {
    const runStatusMapper = RunStatusMapper();

    test(
      ".map() maps the queued run status to the RunStatus.queued",
      () {
        final runStatus = runStatusMapper.map(RunStatusMapper.queued);
        const expectedRunStatus = RunStatus.queued;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".map() maps the in progress run status to the RunStatus.inProgress",
      () {
        final runStatus = runStatusMapper.map(RunStatusMapper.inProgress);
        const expectedRunStatus = RunStatus.inProgress;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".map() maps the completed run status to the RunStatus.completed",
      () {
        final runStatus = runStatusMapper.map(RunStatusMapper.completed);
        const expectedRunStatus = RunStatus.completed;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".map() maps the not specified run status to null",
      () {
        final runStatus = runStatusMapper.map("TEST");

        expect(runStatus, isNull);
      },
    );

    test(
      ".map() maps the null run status to null",
      () {
        final result = runStatusMapper.map(null);

        expect(result, isNull);
      },
    );

    test(
      ".unmap() unmaps the RunStatus.queued",
      () {
        final runStatus = runStatusMapper.unmap(RunStatus.queued);
        const expectedRunStatus = RunStatusMapper.queued;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".unmap() unmaps the RunStatus.inProgress",
      () {
        final runStatus = runStatusMapper.unmap(RunStatus.inProgress);
        const expectedRunStatus = RunStatusMapper.inProgress;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".unmap() unmaps the RunStatus.completed",
      () {
        final runStatus = runStatusMapper.unmap(RunStatus.completed);
        const expectedRunStatus = RunStatusMapper.completed;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".unmap() unmaps null to null",
      () {
        final runStatus = runStatusMapper.unmap(null);

        expect(runStatus, isNull);
      },
    );
  });
}
