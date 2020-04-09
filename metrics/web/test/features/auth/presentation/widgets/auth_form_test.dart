import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:rxdart/rxdart.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../test_utils/user_store_stub.dart';

void main() {
  final emailInputFinder =
      find.widgetWithText(AuthInputField, LoginStrings.email);
  final passwordInputFinder =
      find.widgetWithText(AuthInputField, LoginStrings.password);
  final submitButtonFinder =
      find.widgetWithText(RaisedButton, LoginStrings.signIn);

  group("AuthForm", () {
    testWidgets("email input shows error message if value is empty",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthFormTestbed());

      await tester.tap(submitButtonFinder);
      await tester.pump();

      expect(find.text(LoginStrings.emailIsRequired), findsOneWidget);
    });

    testWidgets("email input shows error message if value is not a valid email",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthFormTestbed());
      await tester.enterText(emailInputFinder, 'notAnEmail');

      await tester.tap(submitButtonFinder);
      await tester.pump();

      expect(find.text(LoginStrings.emailIsInvalid), findsOneWidget);
    });

    testWidgets("password input shows error message if value is empty",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthFormTestbed());

      await tester.tap(submitButtonFinder);
      await tester.pump();

      expect(find.text(LoginStrings.passwordIsRequired), findsOneWidget);
    });

    testWidgets(
        "signInWithEmailAndPassword method is called on tap on sign in button",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthFormTestbed(
        userStore: _SignInUserStoreStub(),
      ));
      await tester.enterText(emailInputFinder, 'test@email.com');
      await tester.enterText(passwordInputFinder, 'testPassword');
      await tester.tap(submitButtonFinder);

      expect(_SignInUserStoreStub.called, isTrue);
    });

    testWidgets("shows an auth error text if the login process went wrong",
        (WidgetTester tester) async {
      await tester.pumpWidget(_AuthFormTestbed(
        userStore: _SignInErrorUserStoreStub(),
      ));
      await tester.enterText(emailInputFinder, 'test@email.com');
      await tester.enterText(passwordInputFinder, 'testPassword');
      await tester.tap(submitButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text(_SignInErrorUserStoreStub.errorMessage), findsOneWidget);
    });
  });
}

class _AuthFormTestbed extends StatelessWidget {
  final UserStore userStore;

  const _AuthFormTestbed({
    this.userStore = const UserStoreStub(),
  });

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<UserStore>(() => userStore),
      ],
      initState: () {
        Injector.getAsReactive<UserStore>().setState(
          (store) => store.subscribeToAuthenticationUpdates(),
        );
      },
      builder: (BuildContext context) => MaterialApp(
        title: 'Auth form',
        home: Scaffold(
          body: AuthForm(),
        ),
      ),
    );
  }
}

class _SignInUserStoreStub extends UserStoreStub {
  static bool called = false;

  const _SignInUserStoreStub();

  @override
  void signInWithEmailAndPassword(String email, String password) {
    called = true;
  }
}

class _SignInErrorUserStoreStub extends UserStoreStub {
  static const String errorMessage = "Unknown error";

  _SignInErrorUserStoreStub();

  @override
  String get authErrorMessage => _authExceptionDescription ?? '';

  String _authExceptionDescription;

  @override
  void signInWithEmailAndPassword(String email, String password) {
    _authExceptionDescription = errorMessage;
  }
}
