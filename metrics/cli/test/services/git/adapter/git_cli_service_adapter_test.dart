// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/git/adapter/git_cli_service_adapter.dart';
import 'package:cli/services/git/cli/git_cli.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("GitCliServiceAdapter", () {
    const url = 'https://test.com';
    const path = 'test/path';

    final gitCli = _GitCliMock();
    final gitService = GitCliServiceAdapter(gitCli);
    final stateError = StateError('test');

    tearDown(() {
      reset(gitCli);
    });

    test(
      "throws an ArgumentError if the given Git CLI is null",
      () {
        expect(
          () => GitCliServiceAdapter(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkout() clones the repository from the given repo URL into the given directory",
      () async {
        await gitService.checkout(url, path);

        verify(gitCli.clone(url, path)).called(once);
      },
    );

    test(
      ".installDependencies() throws if Git CLI throws during the cloning",
      () {
        when(
          gitCli.clone(any, any),
        ).thenAnswer((_) => Future.error(stateError));

        expect(gitService.checkout(url, path), throwsStateError);
      },
    );

    test(
      ".version() returns the version information",
      () async {
        final expected = ProcessResult(0, 0, null, null);

        when(gitCli.version()).thenAnswer((_) => Future.value(expected));

        final result = await gitService.version();

        expect(result, equals(expected));
      },
    );

    test(
      ".version() throws if Git CLI throws during the version retrieving",
      () {
        when(gitCli.version()).thenAnswer((_) => Future.error(stateError));

        expect(gitCli.version(), throwsStateError);
      },
    );
  });
}

class _GitCliMock extends Mock implements GitCli {}
