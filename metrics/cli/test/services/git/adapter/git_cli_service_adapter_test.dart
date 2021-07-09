// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

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
    final gitAdapter = GitCliServiceAdapter(gitCli);
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
        await gitAdapter.checkout(url, path);

        verify(gitCli.clone(url, path)).called(once);
      },
    );

    test(
      ".version() shows the version information",
      () async {
        await gitAdapter.version();

        verify(gitCli.version()).called(once);
      },
    );

    test(
      ".installDependencies() throws if Git CLI throws during the cloning",
      () {
        when(gitCli.clone(any, any))
            .thenAnswer((_) => Future.error(stateError));

        expect(gitAdapter.checkout(url, path), throwsStateError);
      },
    );

    test(
      ".version() throws if Git CLI throws during the version showing",
      () {
        when(gitCli.version()).thenAnswer((_) => Future.error(stateError));

        expect(gitCli.version(), throwsStateError);
      },
    );
  });
}

class _GitCliMock extends Mock implements GitCli {}
