// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_jobs_page.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("WorkflowRunJobsPage", () {
    const totalCount = 1;
    const page = 2;
    const perPage = 3;
    const nextPageUrl = 'url';
    const values = [WorkflowRunJob(id: 1), WorkflowRunJob(id: 2)];

    test(
      "creates an instance with the given values",
      () {
        const jobsPage = WorkflowRunJobsPage(
          totalCount: totalCount,
          page: page,
          perPage: perPage,
          nextPageUrl: nextPageUrl,
          values: values,
        );

        expect(jobsPage.totalCount, equals(totalCount));
        expect(jobsPage.page, equals(page));
        expect(jobsPage.perPage, equals(perPage));
        expect(jobsPage.nextPageUrl, equals(nextPageUrl));
        expect(jobsPage.values, equals(values));
      },
    );
  });
}
