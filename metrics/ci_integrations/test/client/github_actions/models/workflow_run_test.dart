// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("WorkflowRun", () {
    const id = 1;
    const number = 1;
    const apiUrl = 'api-url';
    const url = 'url';
    const status = 'queued';
    final createdAt = DateTime(2020).toUtc();

    final runJson = <String, dynamic>{
      'id': id,
      'run_number': number,
      'url': apiUrl,
      'html_url': url,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };

    final run = WorkflowRun(
      id: id,
      number: number,
      apiUrl: apiUrl,
      url: url,
      status: GithubActionStatus.queued,
      createdAt: createdAt,
    );

    test("creates an instance with the given values", () {
      const status = GithubActionStatus.inProgress;

      final run = WorkflowRun(
        id: id,
        number: number,
        apiUrl: apiUrl,
        url: url,
        status: status,
        createdAt: createdAt,
      );

      expect(run.id, equals(id));
      expect(run.number, equals(number));
      expect(run.apiUrl, equals(apiUrl));
      expect(run.url, equals(url));
      expect(run.status, equals(status));
      expect(run.createdAt, equals(createdAt));
    });

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final workflowRun = WorkflowRun.fromJson(null);

        expect(workflowRun, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final workflowRun = WorkflowRun.fromJson(runJson);

        expect(workflowRun, equals(run));
      },
    );

    test(
      ".listFromJson() maps a null list to null",
      () {
        final runs = WorkflowRun.listFromJson(null);

        expect(runs, isNull);
      },
    );

    test(
      ".listFromJson() maps an empty list to empty one",
      () {
        final runs = WorkflowRun.listFromJson([]);

        expect(runs, isEmpty);
      },
    );

    test(
      ".listFromJson() maps a list of workflow runs",
      () {
        final anotherJson = <String, dynamic>{
          'id': 2,
          'run_number': 2,
          'apiUrl': 'api-url2',
          'url': 'url2',
          'status': 'completed',
          'created_at': DateTime(2019).toUtc().toIso8601String(),
        };
        final anotherRun = WorkflowRun.fromJson(anotherJson);

        final jsonList = [runJson, anotherJson];
        final runs = WorkflowRun.listFromJson(jsonList);

        expect(runs, equals([run, anotherRun]));
      },
    );

    test(".toJson() converts an instance to the json map", () {
      final json = run.toJson();

      expect(json, equals(runJson));
    });
  });
}
