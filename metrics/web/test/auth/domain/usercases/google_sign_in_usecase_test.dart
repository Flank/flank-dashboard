import 'package:metrics/auth/domain/entities/auth_credentials.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/entities/email_domain_validation_result.dart';
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

      when(repository.validateEmailDomain(any)).thenAnswer(
        (_) => Future.value(EmailDomainValidationResult(isValid: true)),
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
      "gets the google sign-in credentials from the repository",
      () async {
        final signInUseCase = GoogleSignInUseCase(repository);

        await signInUseCase();

        verify(repository.getGoogleSignInCredentials()).called(equals(1));
      },
    );

    test("validates the email domain", () async {
      final signInUseCase = GoogleSignInUseCase(repository);

      await signInUseCase();

      verify(repository.validateEmailDomain(any)).called(equals(1));
    });

    test(
      "throws if UserRepository.validateEmail's result is not a valid email",
      () async {
        when(repository.validateEmailDomain(any)).thenAnswer(
          (_) => Future.value(EmailDomainValidationResult(isValid: false)),
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
        when(repository.validateEmailDomain(any)).thenAnswer(
          (_) => Future.value(EmailDomainValidationResult(isValid: false)),
        );

        final signInUseCase = GoogleSignInUseCase(repository);
        await expectLater(
          signInUseCase(),
          MatcherUtil.throwsAuthenticationException,
        );
        verify(repository.signOut()).called(equals(1));
      },
    );

    test(
      "signs in a user using the Google authentication",
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
