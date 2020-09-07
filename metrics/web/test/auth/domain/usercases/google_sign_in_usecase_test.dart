import 'package:metrics/auth/domain/entities/auth_credentials.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/entities/email_validation_result.dart';
import 'package:metrics/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';
import '../../../test_utils/user_repository_mock.dart';

void main() {
  group("GoogleSignInUseCase", () {
    final repository = UserRepositoryMock();
    const email = 'email';

    setUp(() {
      when(repository.getGoogleSignInCredentials()).thenAnswer(
        (_) => Future.value(
          AuthCredentials(
            email: email,
            accessToken: 'accessToken',
            idToken: 'idToken',
          ),
        ),
      );

      when(repository.validateEmail(any)).thenAnswer(
        (_) => Future.value(
          EmailValidationResult(email: email, isValid: true),
        ),
      );
    });

    tearDown(() {
      reset(repository);
    });

    test("throws an AssertionError if the given repository is null", () {
      expect(
        () => GoogleSignInUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "delegates call to the UserRepository.getGoogleSignInCredentials",
      () async {
        final signInUseCase = GoogleSignInUseCase(repository);

        await signInUseCase();

        verify(repository.getGoogleSignInCredentials()).called(equals(1));
      },
    );

    test(
      "delegates call to the UserRepository.validateEmail",
      () async {
        final signInUseCase = GoogleSignInUseCase(repository);

        await signInUseCase();

        verify(repository.validateEmail(any)).called(equals(1));
      },
    );

    test(
      "throws if UserRepository.validateEmail's result is not a valid email",
      () async {
        when(repository.validateEmail(any)).thenAnswer(
          (_) => Future.value(
            EmailValidationResult(email: email, isValid: false),
          ),
        );

        final signInUseCase = GoogleSignInUseCase(repository);

        expect(
          () => signInUseCase(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );

    test(
      "calls the UserRepository.signOut if the UserRepository.validateEmail's result is not a valid email",
      () async {
        when(repository.validateEmail(any)).thenAnswer(
          (_) => Future.value(
            EmailValidationResult(email: email, isValid: false),
          ),
        );

        try {
          final signInUseCase = GoogleSignInUseCase(repository);
          await signInUseCase();
        } catch (error) {
          verify(repository.signOut()).called(equals(1));
        }
      },
    );

    test(
      "delegates call to the UserRepository.signInWithGoogle",
      () async {
        final signInUseCase = GoogleSignInUseCase(repository);

        await signInUseCase();

        verify(repository.signInWithGoogle(any)).called(equals(1));
      },
    );

    test(
      "throws if UserRepository throws during sign in process",
      () {
        final signInUseCase = GoogleSignInUseCase(repository);

        when(repository.signInWithGoogle(any))
            .thenThrow(const AuthenticationException());

        expect(
          () => signInUseCase(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );
  });
}
