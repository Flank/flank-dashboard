// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_action_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run_job.dart';
import 'package:test/test.dart';

void main() {
  group("WorkflowRunJob", () {
    const id = 1;
    const runId = 2;
    const url = 'url';
    const name = 'test';
    const status = 'completed';
    const conclusion = 'success';
    final startedAt = DateTime(2019).toUtc();
    final completedAt = DateTime(2020).toUtc();

    final jobJson = {
      'id': id,
      'run_id': runId,
      'html_url': url,
      'name': name,
      'status': status,
      'conclusion': conclusion,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt.toIso8601String(),
    };

    final job = WorkflowRunJob(
      id: id,
      runId: runId,
      url: url,
      name: name,
      status: GithubActionStatus.completed,
      conclusion: GithubActionConclusion.success,
      startedAt: startedAt,
      completedAt: completedAt,
    );

    test(
      "creates an instance with the given values",
      () {
        const status = GithubActionStatus.queued;
        const conclusion = GithubActionConclusion.failure;

        final job = WorkflowRunJob(
          id: id,
          runId: runId,
          url: url,
          name: name,
          status: status,
          conclusion: conclusion,
          startedAt: startedAt,
          completedAt: completedAt,
        );

        expect(job.id, equals(id));
        expect(job.runId, equals(runId));
        expect(job.url, equals(url));
        expect(job.name, equals(name));
        expect(job.status, equals(status));
        expect(job.conclusion, equals(conclusion));
        expect(job.startedAt, equals(startedAt));
        expect(job.completedAt, equals(completedAt));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final job = WorkflowRunJob.fromJson(null);

        expect(job, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final result = WorkflowRunJob.fromJson(jobJson);

        expect(result, equals(job));
      },
    );

    test(
      ".listFromJson() returns null if the given list is null",
      () {
        final result = WorkflowRunJob.listFromJson(null);

        expect(result, isNull);
      },
    );

    test(
      ".listFromJson() returns an empty list if the given list is empty",
      () {
        final result = WorkflowRunJob.listFromJson([]);

        expect(result, isEmpty);
      },
    );

    test(
      ".listFromJson() maps a list of workflow run jobs",
      () {
        final anotherJson = {
          'id': 2,
          'run_id': 3,
          'url': 'newUrl',
          'name': 'name',
          'status': 'in_progress',
          'conclusion': 'neutral',
          'started_at': DateTime(2017).toUtc().toIso8601String(),
          'completed_at': DateTime(2018).toUtc().toIso8601String(),
        };
        final anotherJob = WorkflowRunJob.fromJson(anotherJson);

        final jsonList = [anotherJson, jobJson];
        final expected = [anotherJob, job];

        final jobList = WorkflowRunJob.listFromJson(jsonList);

        expect(jobList, equals(expected));
      },
    );

    test(
      ".toJson() converts an instance to the json map",
      () {
        final json = job.toJson();

        expect(json, equals(jobJson));
      },
    );
  });
}
