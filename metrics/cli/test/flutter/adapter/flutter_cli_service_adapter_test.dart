// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/flutter/adapter/flutter_cli_service_adapter.dart';
import 'package:cli/flutter/cli/flutter_cli.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

void main() {
  group("FlutterCliServiceAdapter", () {
    const path = './test';
    final flutterCli = _FlutterCliMock();
    final flutterAdapter = FlutterCliServiceAdapter(flutterCli);
    final stateError = StateError('test');

    tearDown(() {
      reset(flutterCli);
    });

    test(
      "throws an ArgumentError if the given Flutter CLI is null",
      () {
        expect(() => FlutterCliServiceAdapter(null), throwsArgumentError);
      },
    );

    test(
      ".version() shows the version information",
      () async {
        await flutterAdapter.version();

        verify(flutterCli.version()).called(once);
      },
    );

    test(
      ".build() builds the web application in the given path",
      () async {
        await flutterAdapter.build(path);

        verify(flutterCli.buildWeb(path)).called(once);
      },
    );

    test(
      ".build() enables web support",
      () async {
        await flutterAdapter.build(path);

        verify(flutterCli.enableWeb()).called(once);
      },
    );

    test(
      ".build() enables web support before building the web application",
      () async {
        await flutterAdapter.build(path);

        verifyInOrder([
          flutterCli.enableWeb(),
          flutterCli.buildWeb(path),
        ]);
      },
    );

    test(
      ".version() rethrows the StateError if showing the version throws it",
          () {
        when(flutterCli.version()).thenThrow(stateError);

        final actual = expectAsync0(() => flutterAdapter.version());

        expect(actual, throwsStateError);
      },
    );

    test(
      ".build() doesn't build the web application if enabling web support throws the StateError ",
          () {
        when(flutterCli.enableWeb()).thenThrow(stateError);

        final actual = expectAsync0(() => flutterAdapter.build(path));

        expect(actual, throwsStateError);
        verifyNever(flutterCli.buildWeb(any));
      },
    );

    test(
      ".build() rethrows the StateError if building the web application throws it",
          () {
        when(flutterCli.buildWeb(any)).thenThrow(stateError);

        final actual = expectAsync0(() => flutterAdapter.build(path));

        expect(actual, throwsStateError);
      },
    );
  });
}

class _FlutterCliMock extends Mock implements FlutterCli {}
