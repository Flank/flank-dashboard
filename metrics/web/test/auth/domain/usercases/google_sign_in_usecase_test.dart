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
    final authCredentials = AuthCredentials(
      email: 'email',
      accessToken: 'access',
      idToken: 'idToken',
    );

    /// Get an instance of the [EmailDomainValidationResult]
    /// with the given [isValid] validation status.
    EmailDomainValidationResult getValidationResult({bool isValid}) {
      return EmailDomainValidationResult(isValid: isValid);
    }

    PostExpectation<Future<AuthCredentials>> whenGetGoogleSignInCredentials() {
      return when(repository.getGoogleSignInCredentials());
    }

    PostExpectation<Future<EmailDomainValidationResult>>
        whenValidateEmailDomain() {
      return when(repository.validateEmailDomain(any));
    }

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
      "throws if the UserRepository throws during getting the google sign-in credentials",
      () {
        whenGetGoogleSignInCredentials().thenThrow(
          const AuthenticationException(),
        );

        final signInUseCase = GoogleSignInUseCase(repository);

        expect(
          () => signInUseCase(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );

    test(
      "throws if the UserRepository throws during validating an email domain",
      () {
        whenGetGoogleSignInCredentials().thenAnswer(
          (_) => Future.value(authCredentials),
        );
        whenValidateEmailDomain().thenThrow(const AuthenticationException());

        final signInUseCase = GoogleSignInUseCase(repository);

        expect(
          () => signInUseCase(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );

    test(
      "gets the google sign-in credentials from the UserRepository",
      () async {
        whenGetGoogleSignInCredentials().thenAnswer(
          (_) => Future.value(authCredentials),
        );
        whenValidateEmailDomain().thenAnswer(
          (_) => Future.value(getValidationResult(isValid: true)),
        );

        final signInUseCase = GoogleSignInUseCase(repository);

        await signInUseCase();

        verify(repository.getGoogleSignInCredentials()).called(equals(1));
      },
    );

    test("validates the email domain", () async {
      whenGetGoogleSignInCredentials().thenAnswer(
        (_) => Future.value(authCredentials),
      );
      whenValidateEmailDomain().thenAnswer(
        (_) => Future.value(getValidationResult(isValid: true)),
      );

      final signInUseCase = GoogleSignInUseCase(repository);

      await signInUseCase();

      verify(repository.validateEmailDomain(any)).called(equals(1));
    });

    test("throws if an email domain is not valid", () async {
      whenGetGoogleSignInCredentials().thenAnswer(
        (_) => Future.value(authCredentials),
      );
      whenValidateEmailDomain().thenAnswer(
        (_) => Future.value(getValidationResult(isValid: false)),
      );

      final signInUseCase = GoogleSignInUseCase(repository);

      expect(
        () => signInUseCase(),
        MatcherUtil.throwsAuthenticationException,
      );
    });

    test(
      "does not call the sign-in with Google if the email domain is not valid",
      () async {
        whenGetGoogleSignInCredentials().thenAnswer(
          (_) => Future.value(authCredentials),
        );
        whenValidateEmailDomain().thenAnswer(
          (_) => Future.value(getValidationResult(isValid: false)),
        );

        final signInUseCase = GoogleSignInUseCase(repository);
        await expectLater(
          signInUseCase(),
          MatcherUtil.throwsAuthenticationException,
        );

        verifyNever(repository.signInWithGoogle(any));
      },
    );

    test("signs out if the user email is not valid", () async {
      whenGetGoogleSignInCredentials().thenAnswer(
        (_) => Future.value(authCredentials),
      );
      whenValidateEmailDomain().thenAnswer(
        (_) => Future.value(getValidationResult(isValid: false)),
      );

      final signInUseCase = GoogleSignInUseCase(repository);
      await expectLater(
        signInUseCase(),
        MatcherUtil.throwsAuthenticationException,
      );
      verify(repository.signOut()).called(equals(1));
    });

    test(
      "signs in a user using the Google authentication",
      () async {
        whenGetGoogleSignInCredentials().thenAnswer(
          (_) => Future.value(authCredentials),
        );
        whenValidateEmailDomain().thenAnswer(
          (_) => Future.value(getValidationResult(isValid: true)),
        );

        final signInUseCase = GoogleSignInUseCase(repository);

        await signInUseCase();

        verify(repository.signInWithGoogle(any)).called(equals(1));
      },
    );

    test(
      "throws if UserRepository throws during sign-in process",
      () {
        whenGetGoogleSignInCredentials().thenAnswer(
          (_) => Future.value(authCredentials),
        );
        whenValidateEmailDomain().thenAnswer(
          (_) => Future.value(getValidationResult(isValid: true)),
        );
        when(repository.signInWithGoogle(any))
            .thenThrow(const AuthenticationException());

        final signInUseCase = GoogleSignInUseCase(repository);

        expect(
          () => signInUseCase(),
          MatcherUtil.throwsAuthenticationException,
        );
      },
    );
  });
}
