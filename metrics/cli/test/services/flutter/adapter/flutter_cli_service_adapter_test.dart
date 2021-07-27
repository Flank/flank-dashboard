// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/flutter/adapter/flutter_cli_service_adapter.dart';
import 'package:cli/services/flutter/cli/flutter_cli.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

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
      ".version() returns the version information",
      () async {
        final expected = ProcessResult(0, 0, null, null);

        when(flutterCli.version()).thenAnswer((_) => Future.value(expected));

        final result = await flutterService.version();

        expect(result, equals(expected));
      },
    );

    test(
      ".version() throws if Flutter CLI throws during the version retrieving",
      () {
        when(flutterCli.version()).thenAnswer((_) => Future.error(stateError));

        expect(flutterService.version(), throwsStateError);
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
      ".build() throws if Flutter CLI throws during the web support enabling",
      () {
        when(
          flutterCli.enableWeb(),
        ).thenAnswer((_) => Future.error(stateError));

        expect(flutterService.build(path), throwsStateError);
      },
    );

    test(
      ".build() doesn't build the web application if Flutter CLI throws during the web support enabling",
      () async {
        when(
          flutterCli.enableWeb(),
        ).thenAnswer((_) => Future.error(stateError));

        await expectLater(flutterService.build(path), throwsStateError);

        verify(flutterCli.enableWeb()).called(once);

        verifyNoMoreInteractions(flutterCli);
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
      ".build() throws if Flutter CLI throws during the web application building",
      () {
        when(
          flutterCli.buildWeb(any),
        ).thenAnswer((_) => Future.error(stateError));

        expect(flutterService.build(path), throwsStateError);
      },
    );
  });
}

class _FlutterCliMock extends Mock implements FlutterCli {}
