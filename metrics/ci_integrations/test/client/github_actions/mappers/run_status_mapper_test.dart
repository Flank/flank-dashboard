import 'package:ci_integration/client/github_actions/mappers/run_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("RunStatusMapper", () {
    final mapper = RunStatusMapper();

    test(
      ".map() maps the queued run status to the RunStatus.queued",
      () {
        const expectedStatus = GithubActionStatus.queued;

        final status = mapper.map(RunStatusMapper.queued);

        expect(status, equals(expectedStatus));
      },
    );

    test(
      ".map() maps the in progress run status to the RunStatus.inProgress",
      () {
        const expectedStatus = GithubActionStatus.inProgress;

        final status = mapper.map(RunStatusMapper.inProgress);

        expect(status, equals(expectedStatus));
      },
    );

    test(
      ".map() maps the completed run status to the RunStatus.completed",
      () {
        const expectedStatus = GithubActionStatus.completed;

        final status = mapper.map(RunStatusMapper.completed);

        expect(status, equals(expectedStatus));
      },
    );

    test(
      ".map() maps the not specified run status to null",
      () {
        final status = mapper.map("TEST");

        expect(status, isNull);
      },
    );

    test(
      ".map() maps the null run status to null",
      () {
        final result = mapper.map(null);

        expect(result, isNull);
      },
    );

    test(
      ".unmap() unmaps the RunStatus.queued to the queued run status value",
      () {
        const expectedStatus = RunStatusMapper.queued;

        final status = mapper.unmap(GithubActionStatus.queued);

        expect(status, equals(expectedStatus));
      },
    );

    test(
      ".unmap() unmaps the RunStatus.inProgress to the in progress run status value",
      () {
        const expectedStatus = RunStatusMapper.inProgress;

        final status = mapper.unmap(GithubActionStatus.inProgress);

        expect(status, equals(expectedStatus));
      },
    );

    test(
      ".unmap() unmaps the RunStatus.completed to the completed run status value",
      () {
        const expectedStatus = RunStatusMapper.completed;

        final status = mapper.unmap(GithubActionStatus.completed);

        expect(status, equals(expectedStatus));
      },
    );

    test(
      ".unmap() unmaps null to null",
      () {
        final status = mapper.unmap(null);

        expect(status, isNull);
      },
    );
  });
}
