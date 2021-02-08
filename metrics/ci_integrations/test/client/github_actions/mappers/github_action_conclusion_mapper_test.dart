// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/mappers/github_action_conclusion_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:test/test.dart';

void main() {
  group("GithubActionConclusionMapper", () {
    const mapper = GithubActionConclusionMapper();

    test(
      ".map() maps the success run conclusion to the GithubActionConclusion.success",
      () {
        const expectedConclusion = GithubActionConclusion.success;

        final conclusion = mapper.map(GithubActionConclusionMapper.success);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the failure run conclusion to the GithubActionConclusion.failure",
      () {
        const expectedConclusion = GithubActionConclusion.failure;

        final conclusion = mapper.map(GithubActionConclusionMapper.failure);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the neutral run conclusion to the GithubActionConclusion.neutral",
      () {
        const expectedConclusion = GithubActionConclusion.neutral;

        final conclusion = mapper.map(GithubActionConclusionMapper.neutral);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the cancelled run conclusion to the GithubActionConclusion.cancelled",
      () {
        const expectedConclusion = GithubActionConclusion.cancelled;

        final conclusion = mapper.map(GithubActionConclusionMapper.cancelled);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the skipped run conclusion to the GithubActionConclusion.skipped",
      () {
        const expectedConclusion = GithubActionConclusion.skipped;

        final conclusion = mapper.map(GithubActionConclusionMapper.skipped);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the timed out run conclusion to the GithubActionConclusion.timedOut",
      () {
        const expectedConclusion = GithubActionConclusion.timedOut;

        final conclusion = mapper.map(GithubActionConclusionMapper.timedOut);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".map() maps the action required run conclusion to the GithubActionConclusion.actionRequired",
      () {
        const expectedConclusion = GithubActionConclusion.actionRequired;

        final conclusion =
            mapper.map(GithubActionConclusionMapper.actionRequired);

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
      ".unmap() unmaps the GithubActionConclusion.success to the successful run conclusion value",
      () {
        const expectedConclusion = GithubActionConclusionMapper.success;

        final conclusion = mapper.unmap(GithubActionConclusion.success);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the GithubActionConclusion.failure to the failed run conclusion value",
      () {
        const expectedConclusion = GithubActionConclusionMapper.failure;

        final conclusion = mapper.unmap(GithubActionConclusion.failure);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the GithubActionConclusion.neutral to the neutral run conclusion value",
      () {
        const expectedConclusion = GithubActionConclusionMapper.neutral;

        final conclusion = mapper.unmap(GithubActionConclusion.neutral);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the GithubActionConclusion.cancelled to the cancelled run conclusion value",
      () {
        const expectedConclusion = GithubActionConclusionMapper.cancelled;

        final conclusion = mapper.unmap(GithubActionConclusion.cancelled);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the GithubActionConclusion.skipped to the skipped run conclusion value",
      () {
        const expectedConclusion = GithubActionConclusionMapper.skipped;

        final conclusion = mapper.unmap(GithubActionConclusion.skipped);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the GithubActionConclusion.timedOut to the timed out run conclusion value",
      () {
        const expectedConclusion = GithubActionConclusionMapper.timedOut;

        final conclusion = mapper.unmap(GithubActionConclusion.timedOut);

        expect(conclusion, equals(expectedConclusion));
      },
    );

    test(
      ".unmap() unmaps the GithubActionConclusion.actionRequired to the action required run conclusion value",
      () {
        const expectedConclusion = GithubActionConclusionMapper.actionRequired;

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
