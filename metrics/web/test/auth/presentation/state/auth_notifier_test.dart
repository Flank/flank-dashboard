import 'dart:async';

import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/entities/user.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';
import '../../test_utils/receive_authentication_updates_mock.dart';
import '../../test_utils/sign_in_usecase_mock.dart';
import '../../test_utils/sign_out_usecase_mock.dart';

void main() {
  group("AuthNotifier", () {
    final signInUseCase = SignInUseCaseMock();
    final signOutUseCase = SignOutUseCaseMock();
    final receiveAuthUpdates = ReceiveAuthenticationUpdatesMock();

    const email = 'test@email.com';
    const password = 'password';

    final authNotifier = AuthNotifier(
      receiveAuthUpdates,
      signInUseCase,
      signOutUseCase,
    );

    tearDown(() {
      reset(signInUseCase);
      reset(signOutUseCase);
      reset(receiveAuthUpdates);
    });

    test("throws AssertionError if a receiveAuthUpdates parameter is null", () {
      expect(
        () => AuthNotifier(null, signInUseCase, signOutUseCase),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws AssertionError if a signInUseCase parameter is null", () {
      expect(
        () => AuthNotifier(receiveAuthUpdates, null, signOutUseCase),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws AssertionError if a signOutUseCase parameter is null", () {
      expect(
        () => AuthNotifier(receiveAuthUpdates, signInUseCase, null),
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

    test(".isLoggedIn status is false after a user signs out", () async {
      when(receiveAuthUpdates()).thenAnswer((_) => Stream.value(null));

      authNotifier.subscribeToAuthenticationUpdates();

      await authNotifier.signOut();

      expect(authNotifier.isLoggedIn, isFalse);
    });

    test(".signInWithEmailAndPassword() delegates to signInUseCase", () {
      const email = 'test@test.com';
      const password = 'someTestPassword';

      authNotifier.signInWithEmailAndPassword(email, password);

      const userCredentials = UserCredentialsParam(
        email: email,
        password: password,
      );

      verify(signInUseCase(userCredentials)).called(equals(1));
    });

    test(".authErrorMessage populated when SignInUseCase throws", () {
      const authException = AuthenticationException(
        code: AuthErrorCode.unknown,
      );

      when(signInUseCase.call(any)).thenThrow(authException);

      authNotifier.signInWithEmailAndPassword('email', 'password');

      expect(authNotifier.authErrorMessage, isNotNull);
    });

    test(
      ".signInWithEmailAndPassword() clears the authentication error message on a successful sign in",
      () {
        const invalidEmail = 'email';
        const invalidPassword = 'password';
        const invalidCredentials = UserCredentialsParam(
          email: invalidEmail,
          password: invalidPassword,
        );
        const authException = AuthenticationException(
          code: AuthErrorCode.unknown,
        );

        when(signInUseCase.call(invalidCredentials)).thenThrow(authException);

        authNotifier.signInWithEmailAndPassword('email', 'password');

        expect(authNotifier.authErrorMessage, isNotNull);

        authNotifier.signInWithEmailAndPassword(
            'valid_email', 'valid_password');

        expect(authNotifier.authErrorMessage, isNull);
      },
    );

    test(".signOut() delegates to the SignOutUseCase", () {
      authNotifier.signOut();

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

