import 'package:ci_integration/client/github_actions/mappers/run_conclusion_mapper.dart';
import 'package:ci_integration/client/github_actions/mappers/run_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/run_conclusion.dart';
import 'package:ci_integration/client/github_actions/models/run_status.dart';
import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("WorkflowRun", () {
    final statusMapper = RunStatusMapper();
    final conclusionMapper = RunConclusionMapper();

    const id = 1;
    const number = 1;
    const url = 'url';
    const status = 'queued';
    const conclusion = 'success';
    final createdAt = DateTime(2020).toUtc();

    final runJson = <String, dynamic>{
      'id': id,
      'run_number': number,
      'url': url,
      'status': status,
      'conclusion': conclusion,
      'created_at': createdAt.toIso8601String(),
    };

    final run = WorkflowRun(
      id: id,
      number: number,
      url: url,
      status: statusMapper.map(status),
      conclusion: conclusionMapper.map(conclusion),
      createdAt: createdAt,
    );

    test("creates an instance with the given values", () {
      const status = RunStatus.inProgress;
      const conclusion = RunConclusion.timedOut;

      final run = WorkflowRun(
        id: id,
        number: number,
        url: url,
        status: status,
        conclusion: conclusion,
        createdAt: createdAt,
      );

      expect(run.id, equals(id));
      expect(run.number, equals(number));
      expect(run.url, equals(url));
      expect(run.status, equals(status));
      expect(run.conclusion, equals(conclusion));
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
          'url': 'url2',
          'status': 'completed',
          'conclusion': 'neutral',
          'created_at': DateTime(2019).toUtc().toString(),
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
