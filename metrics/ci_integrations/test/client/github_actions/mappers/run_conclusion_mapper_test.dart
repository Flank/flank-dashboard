import 'package:ci_integration/client/github_actions/mappers/run_conclusion_mapper.dart';
import 'package:ci_integration/client/github_actions/models/run_conclusion.dart';
import 'package:test/test.dart';

void main() {
  group("RunConclusionMapper", () {
    const runConclusionMapper = RunConclusionMapper();

    test(
      ".map() maps the success run conclusion to the RunConclusion.success",
      () {
        const conclusion = RunConclusionMapper.success;
        final runConclusion = runConclusionMapper.map(conclusion);

        const expectedRunConclusion = RunConclusion.success;

        expect(runConclusion, equals(expectedRunConclusion));
      },
    );

    test(
      ".map() maps the failure run conclusion to the RunConclusion.failure",
      () {
        const conclusion = RunConclusionMapper.failure;
        final runConclusion = runConclusionMapper.map(conclusion);

        const expectedRunConclusion = RunConclusion.failure;

        expect(runConclusion, equals(expectedRunConclusion));
      },
    );

    test(
      ".map() maps the neutral run conclusion to the RunConclusion.neutral",
      () {
        const conclusion = RunConclusionMapper.neutral;
        final runConclusion = runConclusionMapper.map(conclusion);

        const expectedRunConclusion = RunConclusion.neutral;

        expect(runConclusion, equals(expectedRunConclusion));
      },
    );

    test(
      ".map() maps the cancelled run conclusion to the RunConclusion.cancelled",
      () {
        const conclusion = RunConclusionMapper.cancelled;
        final runConclusion = runConclusionMapper.map(conclusion);

        const expectedRunConclusion = RunConclusion.cancelled;

        expect(runConclusion, equals(expectedRunConclusion));
      },
    );

    test(
      ".map() maps the skipped run conclusion to the RunConclusion.skipped",
      () {
        const conclusion = RunConclusionMapper.skipped;
        final runConclusion = runConclusionMapper.map(conclusion);

        const expectedRunConclusion = RunConclusion.skipped;

        expect(runConclusion, equals(expectedRunConclusion));
      },
    );

    test(
      ".map() maps the timed out run conclusion to the RunConclusion.timedOut",
      () {
        const conclusion = RunConclusionMapper.timedOut;
        final runConclusion = runConclusionMapper.map(conclusion);
        const expectedRunConclusion = RunConclusion.timedOut;

        expect(runConclusion, equals(expectedRunConclusion));
      },
    );

    test(
      ".map() maps the action required run conclusion to the RunConclusion.actionRequired",
      () {
        const conclusion = RunConclusionMapper.actionRequired;
        final runConclusion = runConclusionMapper.map(conclusion);

        const expectedRunConclusion = RunConclusion.actionRequired;

        expect(runConclusion, equals(expectedRunConclusion));
      },
    );

    test(
      ".map() maps the not specified run conclusion to null",
      () {
        final runConclusion = runConclusionMapper.map("TEST");

        expect(runConclusion, isNull);
      },
    );

    test(
      ".map() maps the null run conclusion to null",
      () {
        final runConclusion = runConclusionMapper.map(null);

        expect(runConclusion, isNull);
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.success to successful run conclusion value",
      () {
        final runStatus = runConclusionMapper.unmap(RunConclusion.success);

        const expectedRunStatus = RunConclusionMapper.success;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.failure to failed run conclusion value",
      () {
        final runStatus = runConclusionMapper.unmap(RunConclusion.failure);

        const expectedRunStatus = RunConclusionMapper.failure;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.neutral to neutral run conclusion value",
      () {
        final runStatus = runConclusionMapper.unmap(RunConclusion.neutral);

        const expectedRunStatus = RunConclusionMapper.neutral;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.cancelled to cancelled run conclusion value",
      () {
        final runStatus = runConclusionMapper.unmap(RunConclusion.cancelled);

        const expectedRunStatus = RunConclusionMapper.cancelled;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.skipped to skipped run conclusion value",
      () {
        final runStatus = runConclusionMapper.unmap(RunConclusion.skipped);

        const expectedRunStatus = RunConclusionMapper.skipped;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.timedOut to timed out run conclusion value",
      () {
        final runStatus = runConclusionMapper.unmap(RunConclusion.timedOut);

        const expectedRunStatus = RunConclusionMapper.timedOut;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.actionRequired to action required run conclusion value",
      () {
        final runStatus =
            runConclusionMapper.unmap(RunConclusion.actionRequired);

        const expectedRunStatus = RunConclusionMapper.actionRequired;

        expect(runStatus, equals(expectedRunStatus));
      },
    );

    test(
      ".unmap() unmaps the null to null",
      () {
        final runStatus = runConclusionMapper.unmap(null);

        expect(runStatus, isNull);
      },
    );
  });
}
