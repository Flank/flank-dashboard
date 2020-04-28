import 'dart:async';

import 'package:metrics/features/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/features/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/features/auth/domain/entities/user.dart';
import 'package:metrics/features/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/features/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:metrics/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:metrics/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("AuthStore", () {
    final signInUseCase = SignInUseCaseMock();
    final signOutUseCase = SignOutUseCaseMock();
    final receiveAuthUpdates = ReceiveAuthenticationUpdatesMock();

    final authStore = AuthStore(
      receiveAuthUpdates,
      signInUseCase,
      signOutUseCase,
    );

    tearDown(() {
      reset(signInUseCase);
      reset(signOutUseCase);
      reset(receiveAuthUpdates);
    });

    tearDownAll(() {
      authStore.dispose();
    });

    test(
      ".subscribeToAuthenticationUpdates() delegates to receiveAuthUpdates usecase",
      () {
        when(receiveAuthUpdates.call())
            .thenAnswer((realInvocation) => const Stream.empty());

        authStore.subscribeToAuthenticationUpdates();

        verify(receiveAuthUpdates.call()).called(equals(1));
      },
    );

    test(
      ".subscribeToAuthenticationUpdates() subscribes to user updates",
      () {
        final userController = StreamController<User>();

        when(receiveAuthUpdates.call())
            .thenAnswer((realInvocation) => userController.stream);

        authStore.subscribeToAuthenticationUpdates();

        expect(userController.hasListener, isTrue);
      },
    );

    test(".signInWithEmailAndPassword() delegates to signInUseCase", () {
      const email = 'test@test.com';
      const password = 'someTestPassword';

      authStore.signInWithEmailAndPassword(email, password);

      const userCredentials = UserCredentialsParam(
        email: email,
        password: password,
      );

      verify(signInUseCase(userCredentials)).called(equals(1));
    });

    test("saves the error message when SignInUseCase throws", () {
      const authException = AuthenticationException(
        code: AuthErrorCode.unknown,
      );

      when(signInUseCase.call(any)).thenThrow(authException);

      authStore.signInWithEmailAndPassword('email', 'password');

      expect(authStore.authErrorMessage, isNotNull);
    });

    test(
      ".signInWithEmailAndPassword() clears the authentication error message on successful sign in",
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

        authStore.signInWithEmailAndPassword('email', 'password');

        expect(authStore.authErrorMessage, isNotNull);

        authStore.signInWithEmailAndPassword('valid_email', 'valid_password');

        expect(authStore.authErrorMessage, isNull);
      },
    );

    test(".signOut() delegates to the SignOutUseCase", () {
      authStore.signOut();

      verify(signOutUseCase()).called(equals(1));
    });

    test(
      ".dispose() cancels all created subscriptions",
      () {
        final userController = StreamController<User>();

        when(receiveAuthUpdates()).thenAnswer((_) => userController.stream);

        authStore.subscribeToAuthenticationUpdates();

        expect(userController.hasListener, isTrue);

        authStore.dispose();

        expect(userController.hasListener, isFalse);
      },
    );
  });
}

class ReceiveAuthenticationUpdatesMock extends Mock
    implements ReceiveAuthenticationUpdates {}

class SignInUseCaseMock extends Mock implements SignInUseCase {}

class SignOutUseCaseMock extends Mock implements SignOutUseCase {}
