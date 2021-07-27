// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/npm/adapter/npm_cli_service_adapter.dart';
import 'package:cli/services/npm/cli/npm_cli.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("NpmCliServiceAdapter", () {
    const path = 'test/path';

    final npmCli = _NpmCliMock();
    final npmService = NpmCliServiceAdapter(npmCli);
    final stateError = StateError('test');

    tearDown(() {
      reset(npmCli);
    });

    test(
      "throws an ArgumentError if the given Npm CLI is null",
      () {
        expect(
          () => NpmCliServiceAdapter(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".installDependencies() installs the dependencies to the given directory",
      () async {
        await npmService.installDependencies(path);

        verify(npmCli.install(path)).called(once);
      },
    );

    test(
      ".installDependencies() throws if Npm CLI throws during the dependencies installing",
      () {
        when(npmCli.install(any)).thenAnswer((_) => Future.error(stateError));

        expect(npmService.installDependencies(path), throwsStateError);
      },
    );

    test(
      ".version() returns the version information",
      () async {
        final expected = ProcessResult(0, 0, null, null);

        when(npmCli.version()).thenAnswer((_) => Future.value(expected));

        final result = await npmService.version();

        expect(result, equals(expected));
      },
    );

    test(
      ".version() throws if Npm CLI throws during the version retrieving",
      () {
        when(npmCli.version()).thenAnswer((_) => Future.error(stateError));

        expect(npmService.version(), throwsStateError);
      },
    );
  });
}

class _NpmCliMock extends Mock implements NpmCli {}
