// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/mappers/buildkite_build_state_mapper.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteBuildStateMapper", () {
    const mapper = BuildkiteBuildStateMapper();

    test(
      ".map() maps the running build state to the BuildkiteBuildState.running",
      () {
        const expectedState = BuildkiteBuildState.running;

        final state = mapper.map(BuildkiteBuildStateMapper.running);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".map() maps the scheduled build state to the BuildkiteBuildState.scheduled",
      () {
        const expectedState = BuildkiteBuildState.scheduled;

        final state = mapper.map(BuildkiteBuildStateMapper.scheduled);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".map() maps the passed build state to the BuildkiteBuildState.passed",
      () {
        const expectedState = BuildkiteBuildState.passed;

        final state = mapper.map(BuildkiteBuildStateMapper.passed);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".map() maps the failed build state to the BuildkiteBuildState.failed",
      () {
        const expectedState = BuildkiteBuildState.failed;

        final state = mapper.map(BuildkiteBuildStateMapper.failed);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".map() maps the blocked build state to the BuildkiteBuildState.blocked",
      () {
        const expectedState = BuildkiteBuildState.blocked;

        final state = mapper.map(BuildkiteBuildStateMapper.blocked);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".map() maps the canceled build state to the BuildkiteBuildState.canceled",
      () {
        const expectedState = BuildkiteBuildState.canceled;

        final state = mapper.map(BuildkiteBuildStateMapper.canceled);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".map() maps the canceling build state to the BuildkiteBuildState.canceling",
      () {
        const expectedState = BuildkiteBuildState.canceling;

        final state = mapper.map(BuildkiteBuildStateMapper.canceling);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".map() maps the skipped build state to the BuildkiteBuildState.skipped",
      () {
        const expectedState = BuildkiteBuildState.skipped;

        final state = mapper.map(BuildkiteBuildStateMapper.skipped);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".map() maps the notRun build state to the BuildkiteBuildState.notRun",
      () {
        const expectedState = BuildkiteBuildState.notRun;

        final state = mapper.map(BuildkiteBuildStateMapper.notRun);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".map() maps the finished build state to the BuildkiteBuildState.finished",
      () {
        const expectedState = BuildkiteBuildState.finished;

        final state = mapper.map(BuildkiteBuildStateMapper.finished);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".map() maps the not specified run state to null",
      () {
        final state = mapper.map("TEST");

        expect(state, isNull);
      },
    );

    test(
      ".map() maps the null run state to null",
      () {
        final result = mapper.map(null);

        expect(result, isNull);
      },
    );

    test(
      ".unmap() unmaps the BuildkiteBuildState.running to the running build state value",
      () {
        const expectedState = BuildkiteBuildStateMapper.running;

        final state = mapper.unmap(BuildkiteBuildState.running);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteBuildState.scheduled to the scheduled build state value",
      () {
        const expectedState = BuildkiteBuildStateMapper.scheduled;

        final state = mapper.unmap(BuildkiteBuildState.scheduled);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteBuildState.passed to the passed build state value",
      () {
        const expectedState = BuildkiteBuildStateMapper.passed;

        final state = mapper.unmap(BuildkiteBuildState.passed);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteBuildState.failed to the failed build state value",
      () {
        const expectedState = BuildkiteBuildStateMapper.failed;

        final state = mapper.unmap(BuildkiteBuildState.failed);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteBuildState.blocked to the blocked build state value",
      () {
        const expectedState = BuildkiteBuildStateMapper.blocked;

        final state = mapper.unmap(BuildkiteBuildState.blocked);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteBuildState.canceled to the canceled build state value",
      () {
        const expectedState = BuildkiteBuildStateMapper.canceled;

        final state = mapper.unmap(BuildkiteBuildState.canceled);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteBuildState.canceling to the canceling build state value",
      () {
        const expectedState = BuildkiteBuildStateMapper.canceling;

        final state = mapper.unmap(BuildkiteBuildState.canceling);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteBuildState.skipped to the skipped build state value",
      () {
        const expectedState = BuildkiteBuildStateMapper.skipped;

        final state = mapper.unmap(BuildkiteBuildState.skipped);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteBuildState.notRun to the notRun build state value",
      () {
        const expectedState = BuildkiteBuildStateMapper.notRun;

        final state = mapper.unmap(BuildkiteBuildState.notRun);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".unmap() unmaps the BuildkiteBuildState.finished to the finished build state value",
      () {
        const expectedState = BuildkiteBuildStateMapper.finished;

        final state = mapper.unmap(BuildkiteBuildState.finished);

        expect(state, equals(expectedState));
      },
    );

    test(
      ".unmap() unmaps null to null",
      () {
        final state = mapper.unmap(null);

        expect(state, isNull);
      },
    );
  });
}
