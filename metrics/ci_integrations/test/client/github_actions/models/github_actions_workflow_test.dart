// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_actions_workflow.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GithubActionsWorkflow", () {
    const id = 1;
    const name = 'name';
    const path = 'path';

    const workflowJson = {
      'id': id,
      'name': name,
      'path': path,
    };

    const workflow = GithubActionsWorkflow(id: id, name: name, path: path);

    test(
      "creates an instance with the given values",
      () {
        const workflow = GithubActionsWorkflow(id: id, name: name, path: path);

        expect(workflow.id, equals(id));
        expect(workflow.name, equals(name));
        expect(workflow.path, equals(path));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final workflow = GithubActionsWorkflow.fromJson(null);

        expect(workflow, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final actualWorkflow = GithubActionsWorkflow.fromJson(workflowJson);

        expect(actualWorkflow, equals(workflow));
      },
    );

    test(
      ".listFromJson() returns null if the given list is null",
      () {
        final workflows = GithubActionsWorkflow.listFromJson(null);

        expect(workflows, isNull);
      },
    );

    test(
      ".listFromJson() returns an empty list if the given one is empty",
      () {
        final workflows = GithubActionsWorkflow.listFromJson([]);

        expect(workflows, isEmpty);
      },
    );

    test(
      ".listFromJson() creates a list of workflows from the given list of JSON encodable objects",
      () {
        final anotherJson = {'id': 2, 'name': 'name2', 'path': 'path2'};
        final anotherWorkflow = GithubActionsWorkflow.fromJson(anotherJson);
        final jsonList = [workflowJson, anotherJson];
        final expectedList = [workflow, anotherWorkflow];

        final workflows = GithubActionsWorkflow.listFromJson(jsonList);

        expect(workflows, equals(expectedList));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        final json = workflow.toJson();

        expect(json, equals(workflowJson));
      },
    );
  });
}
