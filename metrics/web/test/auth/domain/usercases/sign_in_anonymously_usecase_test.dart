// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/usecases/sign_in_anonymously_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';
import '../../../test_utils/user_repository_mock.dart';

void main() {
  group("SignInAnonymouslyUseCase", () {
    final repository = UserRepositoryMock();

    tearDown(() {
      reset(repository);
    });

    test("throws an AssertionError if the given repository is null", () {
      expect(
        () => SignInAnonymouslyUseCase(null),
        throwsAssertionError,
      );
    });

    test(
      "delegates call to the UserRepository.signInAnonymously",
      () async {
        final signInAnonymouslyUseCase = SignInAnonymouslyUseCase(repository);

        await signInAnonymouslyUseCase(Null);

        verify(repository.signInAnonymously()).called(once);
      },
    );

    test(
      "throws if UserRepository throws during sign in process",
      () {
        final signInAnonymouslyUseCase = SignInAnonymouslyUseCase(repository);

        when(repository.signInAnonymously())
            .thenThrow(const AuthenticationException());

        expect(
          () => signInAnonymouslyUseCase(Null),
          throwsAuthenticationException,
        );
      },
    );
  });
}
