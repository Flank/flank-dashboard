// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/npm/adapter/npm_cli_service_adapter.dart';
import 'package:cli/services/npm/cli/npm_cli.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group('NpmCliServiceAdapter', () {
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
      ".version() shows the version information",
      () async {
        await npmService.version();

        verify(npmCli.version()).called(once);
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
      ".version() throws if Npm CLI throws during the version showing",
      () {
        when(npmCli.version()).thenAnswer((_) => Future.error(stateError));

        expect(npmService.version(), throwsStateError);
      },
    );
  });
}

class _NpmCliMock extends Mock implements NpmCli {}
