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
    final flutterService = FlutterCliServiceAdapter(flutterCli);
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
        await flutterService.version();

        verify(flutterCli.version()).called(once);
      },
    );

    test(
      ".build() builds the web application in the given path",
      () async {
        await flutterService.build(path);

        verify(flutterCli.buildWeb(path)).called(once);
      },
    );

    test(
      ".build() enables web support",
      () async {
        await flutterService.build(path);

        verify(flutterCli.enableWeb()).called(once);
      },
    );

    test(
      ".version() throws if showing the version throws",
      () {
        when(flutterCli.version()).thenAnswer((_) => Future.error(stateError));

        expect(flutterService.version(), throwsA(isA<StateError>()));
      },
    );

    test(
      ".build() doesn't build the web application if enabling web support throws",
      () {
        when(flutterCli.enableWeb())
            .thenAnswer((_) => Future.error(stateError));

        expect(flutterService.build(path), throwsA(isA<StateError>()));
        verifyNever(flutterCli.buildWeb(any));
      },
    );

    test(
      ".build() throws if building the web application throws",
      () {
        when(flutterCli.buildWeb(any))
            .thenAnswer((_) => Future.error(stateError));

        expect(flutterService.build(path), throwsA(isA<StateError>()));
      },
    );
  });
}

class _FlutterCliMock extends Mock implements FlutterCli {}
