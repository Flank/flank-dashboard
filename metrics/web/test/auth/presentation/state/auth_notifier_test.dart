import 'dart:async';

import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/entities/user.dart';
import 'package:metrics/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:metrics/auth/domain/usecases/sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/sign_out_usecase.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("AuthNotifier", () {
    final signInUseCase = SignInUseCaseMock();
    final googleSignInUseCase = GoogleSignInUseCaseMock();
    final signOutUseCase = SignOutUseCaseMock();
    final receiveAuthUpdates = ReceiveAuthenticationUpdatesMock();

    const authException = AuthenticationException(
      code: AuthErrorCode.unknown,
    );
    const emailAuthException = AuthenticationException(
      code: AuthErrorCode.userNotFound,
    );
    const passwordAuthException = AuthenticationException(
      code: AuthErrorCode.wrongPassword,
    );

    const email = 'test@email.com';
    const password = 'password';

    const invalidEmail = 'email@mail.mail';
    const invalidPassword = 'password';
    final invalidCredentials = UserCredentialsParam(
      email: Email(invalidEmail),
      password: Password(invalidPassword),
    );

    final authNotifier = AuthNotifier(
      receiveAuthUpdates,
      signInUseCase,
      googleSignInUseCase,
      signOutUseCase,
    );

    tearDown(() {
      reset(signInUseCase);
      reset(googleSignInUseCase);
      reset(signOutUseCase);
      reset(receiveAuthUpdates);
    });

    test("throws AssertionError if a receiveAuthUpdates parameter is null", () {
      expect(
        () => AuthNotifier(
          null,
          signInUseCase,
          googleSignInUseCase,
          signOutUseCase,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws AssertionError if a signInUseCase parameter is null", () {
      expect(
        () => AuthNotifier(
          receiveAuthUpdates,
          null,
          googleSignInUseCase,
          signOutUseCase,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "throws AssertionError if a googleSignInUseCase parameter is null",
      () {
        expect(
          () => AuthNotifier(
            receiveAuthUpdates,
            signInUseCase,
            null,
            signOutUseCase,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test("throws AssertionError if a signOutUseCase parameter is null", () {
      expect(
        () => AuthNotifier(
          receiveAuthUpdates,
          signInUseCase,
          googleSignInUseCase,
          null,
        ),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      ".subscribeToAuthenticationUpdates() delegates to receiveAuthUpdates usecase",
      () {
        when(receiveAuthUpdates.call())
            .thenAnswer((realInvocation) => const Stream.empty());

        authNotifier.subscribeToAuthenticationUpdates();

        verify(receiveAuthUpdates.call()).called(equals(1));
      },
    );

    test(
      ".subscribeToAuthenticationUpdates() subscribes to user updates",
      () {
        final userController = StreamController<User>();

        when(receiveAuthUpdates.call())
            .thenAnswer((realInvocation) => userController.stream);

        authNotifier.subscribeToAuthenticationUpdates();

        expect(userController.hasListener, isTrue);
      },
    );

    test(".isLoggedIn status is true after a user signs in", () async {
      final user = User(id: 'id', email: email);

      when(receiveAuthUpdates()).thenAnswer((_) => Stream.value(user));

      authNotifier.subscribeToAuthenticationUpdates();

      await authNotifier.signInWithEmailAndPassword(email, password);

      expect(authNotifier.isLoggedIn, isTrue);
    });

    test(
      ".isLoggedIn status is true after a user signs in with Google",
      () async {
        final user = User(id: 'id', email: email);

        when(receiveAuthUpdates()).thenAnswer((_) => Stream.value(user));

        authNotifier.subscribeToAuthenticationUpdates();

        await authNotifier.signInWithGoogle();

        expect(authNotifier.isLoggedIn, isTrue);
      },
    );

    test(".isLoggedIn status is false after a user signs out", () async {
      when(receiveAuthUpdates()).thenAnswer((_) => Stream.value(null));

      authNotifier.subscribeToAuthenticationUpdates();

      await authNotifier.signOut();

      expect(authNotifier.isLoggedIn, isFalse);
    });

    test(
      ".isLoading status is false after a user signs in with login and password",
      () async {
        await authNotifier.signInWithEmailAndPassword(email, password);

        expect(authNotifier.isLoading, isFalse);
      },
    );

    test(
      ".isLoading status is false after a user signs in with Google",
      () async {
        await authNotifier.signInWithGoogle();

        expect(authNotifier.isLoading, isFalse);
      },
    );

    test(
      ".isLoading status is false if .signInWithEmailAndPassword() is finished with an error",
      () async {
        final userCredentials = UserCredentialsParam(
          email: Email(email),
          password: Password(password),
        );

        when(signInUseCase(userCredentials))
            .thenAnswer((_) => Future.error(authException));

        await authNotifier.signInWithEmailAndPassword(email, password);

        expect(authNotifier.isLoading, isFalse);
      },
    );

    test(
      ".isLoading status is false if .signInWithGoogle() is finished with an error",
      () async {
        when(googleSignInUseCase())
            .thenAnswer((_) => Future.error(authException));

        await authNotifier.signInWithGoogle();

        expect(authNotifier.isLoading, isFalse);
      },
    );

    test(".signInWithEmailAndPassword() delegates to signInUseCase", () async {
      await authNotifier.signInWithEmailAndPassword(email, password);

      final userCredentials = UserCredentialsParam(
        email: Email(email),
        password: Password(password),
      );

      verify(signInUseCase(userCredentials)).called(equals(1));
    });

    test(".signInWithEmailAndPassword() does nothing if isLoading is true", () {
      authNotifier.signInWithGoogle();
      authNotifier.signInWithEmailAndPassword(email, password);

      final userCredentials = UserCredentialsParam(
        email: Email(email),
        password: Password(password),
      );

      verifyNever(signInUseCase(userCredentials));
    });

    test(".signInWithGoogle() delegates to googleSignInUseCase", () async {
      await authNotifier.signInWithGoogle();

      verify(googleSignInUseCase()).called(equals(1));
    });

    test(".signInWithGoogle() does nothing if isLoading is true", () {
      authNotifier.signInWithEmailAndPassword(email, password);
      authNotifier.signInWithGoogle();

      verifyNever(googleSignInUseCase());
    });

    test(
      ".authErrorMessage is populated when the auth error occurred during the sign-in process",
      () async {
        when(signInUseCase.call(any))
            .thenAnswer((_) => Future.error(authException));

        await authNotifier.signInWithEmailAndPassword(email, password);

        expect(authNotifier.authErrorMessage, isNotNull);
      },
    );

    test(
      ".emailErrorMessage is populated when the email-related error occurred during the sign-in process",
      () async {
        when(signInUseCase.call(any))
            .thenAnswer((_) => Future.error(emailAuthException));

        await authNotifier.signInWithEmailAndPassword(email, password);

        expect(authNotifier.emailErrorMessage, isNotNull);
      },
    );

    test(
      ".passwordErrorMessage is populated when the password-related error occurred during the sign-in process",
      () async {
        when(signInUseCase.call(any))
            .thenAnswer((_) => Future.error(passwordAuthException));

        await authNotifier.signInWithEmailAndPassword(email, password);

        expect(authNotifier.passwordErrorMessage, isNotNull);
      },
    );

    test(
      ".authErrorMessage is populated when the auth error occurred during the google sign-in process",
      () async {
        when(googleSignInUseCase.call())
            .thenAnswer((_) => Future.error(authException));

        await authNotifier.signInWithGoogle();

        expect(authNotifier.authErrorMessage, isNotNull);
      },
    );

    test(
      ".signInWithEmailAndPassword() clears the authentication error message on a successful sign in",
      () async {
        when(signInUseCase.call(invalidCredentials))
            .thenAnswer((_) => Future.error(authException));

        await authNotifier.signInWithEmailAndPassword(
          invalidEmail,
          invalidPassword,
        );

        expect(authNotifier.authErrorMessage, isNotNull);

        await authNotifier.signInWithEmailAndPassword(email, password);

        expect(authNotifier.authErrorMessage, isNull);
      },
    );

    test(
      ".signInWithEmailAndPassword() clears the authentication email error message on a successful sign in",
      () async {
        when(signInUseCase.call(invalidCredentials))
            .thenAnswer((_) => Future.error(emailAuthException));

        await authNotifier.signInWithEmailAndPassword(
          invalidEmail,
          invalidPassword,
        );

        expect(authNotifier.emailErrorMessage, isNotNull);

        await authNotifier.signInWithEmailAndPassword(email, password);

        expect(authNotifier.emailErrorMessage, isNull);
      },
    );

    test(
      ".signInWithEmailAndPassword() clears the authentication password error message on a successful sign in",
      () async {
        when(signInUseCase.call(invalidCredentials))
            .thenAnswer((_) => Future.error(passwordAuthException));

        await authNotifier.signInWithEmailAndPassword(
          invalidEmail,
          invalidPassword,
        );

        expect(authNotifier.passwordErrorMessage, isNotNull);

        await authNotifier.signInWithEmailAndPassword(email, password);

        expect(authNotifier.passwordErrorMessage, isNull);
      },
    );

    test(
      ".signInWithGoogle() clears the authentication error message on a successful sign in",
      () async {
        when(googleSignInUseCase.call())
            .thenAnswer((_) => Future.error(authException));

        await authNotifier.signInWithGoogle();

        expect(authNotifier.authErrorMessage, isNotNull);

        when(googleSignInUseCase.call()).thenAnswer((_) => null);

        await authNotifier.signInWithGoogle();

        expect(authNotifier.authErrorMessage, isNull);
      },
    );

    test(".signOut() delegates to the SignOutUseCase", () async {
      await authNotifier.signOut();

      verify(signOutUseCase()).called(equals(1));
    });

    test(
      ".dispose() cancels all created subscriptions",
      () {
        final userController = StreamController<User>();

        when(receiveAuthUpdates()).thenAnswer((_) => userController.stream);

        authNotifier.subscribeToAuthenticationUpdates();

        expect(userController.hasListener, isTrue);

        authNotifier.dispose();

        expect(userController.hasListener, isFalse);
      },
    );
  });
}

class SignInUseCaseMock extends Mock implements SignInUseCase {}

class GoogleSignInUseCaseMock extends Mock implements GoogleSignInUseCase {}

class SignOutUseCaseMock extends Mock implements SignOutUseCase {}

class ReceiveAuthenticationUpdatesMock extends Mock
    implements ReceiveAuthenticationUpdates {}
