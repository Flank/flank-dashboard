import 'package:ci_integration/client/github_actions/mappers/run_conclusion_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("RunConclusionMapper", () {
    final mapper = RunConclusionMapper();

    test(
      ".map() maps the success run conclusion to the RunConclusion.success",
      () {
        const expectedConclusion = GithubActionConclusion.success;

        final conclusion = mapper.map(RunConclusionMapper.success);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the failure run conclusion to the RunConclusion.failure",
      () {
        const expectedConclusion = GithubActionConclusion.failure;

        final conclusion = mapper.map(RunConclusionMapper.failure);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the neutral run conclusion to the RunConclusion.neutral",
      () {
        const expectedConclusion = GithubActionConclusion.neutral;

        final conclusion = mapper.map(RunConclusionMapper.neutral);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the cancelled run conclusion to the RunConclusion.cancelled",
      () {
        const expectedConclusion = GithubActionConclusion.cancelled;

        final conclusion = mapper.map(RunConclusionMapper.cancelled);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the skipped run conclusion to the RunConclusion.skipped",
      () {
        const expectedConclusion = GithubActionConclusion.skipped;

        final conclusion = mapper.map(RunConclusionMapper.skipped);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the timed out run conclusion to the RunConclusion.timedOut",
      () {
        const expectedConclusion = GithubActionConclusion.timedOut;

        final conclusion = mapper.map(RunConclusionMapper.timedOut);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the action required run conclusion to the RunConclusion.actionRequired",
      () {
        const expectedConclusion = GithubActionConclusion.actionRequired;

        final conclusion = mapper.map(RunConclusionMapper.actionRequired);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the not specified run conclusion to null",
      () {
        final conclusion = mapper.map("TEST");

        expect(conclusion, isNull);
      },
    );

    test(
      ".map() maps the null run conclusion to null",
      () {
        final conclusion = mapper.map(null);

        expect(conclusion, isNull);
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.success to the successful run conclusion value",
      () {
        const expectedConclusion = RunConclusionMapper.success;

        final conclusion = mapper.unmap(GithubActionConclusion.success);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.failure to the failed run conclusion value",
      () {
        const expectedConclusion = RunConclusionMapper.failure;

        final conclusion = mapper.unmap(GithubActionConclusion.failure);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.neutral to the neutral run conclusion value",
      () {
        const expectedConclusion = RunConclusionMapper.neutral;

        final conclusion = mapper.unmap(GithubActionConclusion.neutral);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.cancelled to the cancelled run conclusion value",
      () {
        const expectedConclusion = RunConclusionMapper.cancelled;

        final conclusion = mapper.unmap(GithubActionConclusion.cancelled);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.skipped to the skipped run conclusion value",
      () {
        const expectedConclusion = RunConclusionMapper.skipped;

        final conclusion = mapper.unmap(GithubActionConclusion.skipped);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.timedOut to the timed out run conclusion value",
      () {
        const expectedConclusion = RunConclusionMapper.timedOut;

        final conclusion = mapper.unmap(GithubActionConclusion.timedOut);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the RunConclusion.actionRequired to the action required run conclusion value",
      () {
        const expectedConclusion = RunConclusionMapper.actionRequired;

        final conclusion = mapper.unmap(GithubActionConclusion.actionRequired);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the null to null",
      () {
        final conclusion = mapper.unmap(null);

        expect(conclusion, isNull);
      },
    );
  });
}
