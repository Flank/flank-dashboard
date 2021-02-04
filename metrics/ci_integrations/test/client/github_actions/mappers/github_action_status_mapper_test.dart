// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/mappers/github_action_status_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_action_status.dart';
import 'package:test/test.dart';

void main() {
  group("GithubActionStatusMapper", () {
    const mapper = GithubActionStatusMapper();

    test(
      ".map() maps the queued run status to the GithubActionStatus.queued",
      () {
        const expectedStatus = GithubActionStatus.queued;

        final status = mapper.map(GithubActionStatusMapper.queued);

        expect(status, equals(expectedStatus));
      },
    );

    test(
      ".map() maps the in progress run status to the GithubActionStatus.inProgress",
      () {
        const expectedStatus = GithubActionStatus.inProgress;

        final status = mapper.map(GithubActionStatusMapper.inProgress);

        expect(status, equals(expectedStatus));
      },
    );

    test(
      ".map() maps the completed run status to the GithubActionStatus.completed",
      () {
        const expectedStatus = GithubActionStatus.completed;

        final status = mapper.map(GithubActionStatusMapper.completed);

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
      ".unmap() unmaps the GithubActionStatus.queued to the queued run status value",
      () {
        const expectedStatus = GithubActionStatusMapper.queued;

        final status = mapper.unmap(GithubActionStatus.queued);

        expect(status, equals(expectedStatus));
      },
    );

    test(
      ".unmap() unmaps the GithubActionStatus.inProgress to the in progress run status value",
      () {
        const expectedStatus = GithubActionStatusMapper.inProgress;

        final status = mapper.unmap(GithubActionStatus.inProgress);

        expect(status, equals(expectedStatus));
      },
    );

    test(
      ".unmap() unmaps the GithubActionStatus.completed to the completed run status value",
      () {
        const expectedStatus = GithubActionStatusMapper.completed;

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
