// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("WorkflowRunArtifactsPage", () {
    const totalCount = 1;
    const page = 1;
    const perPage = 1;
    const nextPageUrl = 'url';
    const values = [WorkflowRun(id: 1), WorkflowRun(id: 2)];

    test(
      "creates an instance with the given values",
      () {
        const artifactsPage = WorkflowRunsPage(
          totalCount: totalCount,
          page: page,
          perPage: perPage,
          nextPageUrl: nextPageUrl,
          values: values,
        );

        expect(artifactsPage.totalCount, equals(totalCount));
        expect(artifactsPage.page, equals(page));
        expect(artifactsPage.perPage, equals(perPage));
        expect(artifactsPage.nextPageUrl, equals(nextPageUrl));
        expect(artifactsPage.values, equals(values));
      },
    );
  });
}
