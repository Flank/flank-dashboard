import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:rxdart/rxdart.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  final Finder emailInput =
      find.widgetWithText(AuthInputField, LoginStrings.email);
  final Finder passwordInput =
      find.widgetWithText(AuthInputField, LoginStrings.password);
  final Finder submitButton =
      find.widgetWithText(RaisedButton, LoginStrings.signIn);

  group('AuthForm', () {
    testWidgets('Email input shows error message if value is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const AuthFormTestbed());

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text(LoginStrings.emailIsRequired), findsOneWidget);
    });

    testWidgets('Email input shows error message if value is not a valid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(const AuthFormTestbed());
      await tester.enterText(emailInput, 'notAnEmail');

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text(LoginStrings.emailIsInvalid), findsOneWidget);
    });

    testWidgets('Password input shows error message if value is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const AuthFormTestbed());

      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text(LoginStrings.passwordIsRequired), findsOneWidget);
    });

    testWidgets(
        'signInWithEmailAndPassword method is called on tap on sign in button',
        (WidgetTester tester) async {
      await tester.pumpWidget(const AuthFormTestbed(
        userStore: SignInUserStoreStub(),
      ));
      await tester.enterText(emailInput, 'test@email.com');
      await tester.enterText(passwordInput, 'testPassword');
      await tester.tap(submitButton);

      expect(SignInUserStoreStub.called, isTrue);
    });

    testWidgets('Shows an auth error text if the login process went wrong',
        (WidgetTester tester) async {
      await tester.pumpWidget(AuthFormTestbed(
        userStore: SignInErrorUserStoreStub(),
      ));
      await tester.enterText(emailInput, 'test@email.com');
      await tester.enterText(passwordInput, 'testPassword');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text(SignInErrorUserStoreStub.errorMessage), findsOneWidget);
    });
  });
}

class AuthFormTestbed extends StatelessWidget {
  final UserStore userStore;

  const AuthFormTestbed({
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
          (store) => store.subscribeToUserUpdates(),
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

class UserStoreStub implements UserStore {
  const UserStoreStub();

  @override
  Stream get loggedInStream => null;

  @override
  bool get isLoggedIn => false;

  @override
  String get authErrorMessage => '';

  @override
  void subscribeToUserUpdates() {}

  @override
  void signInWithEmailAndPassword(String email, String password) {}

  @override
  void signOut() {}

  @override
  void dispose() {}
}

class SignInUserStoreStub extends UserStoreStub {
  static bool called = false;

  const SignInUserStoreStub();

  @override
  void signInWithEmailAndPassword(String email, String password) {
    called = true;
  }
}

class SignInErrorUserStoreStub extends UserStoreStub {
  static const String errorMessage = "Unknown error";

  SignInErrorUserStoreStub();

  @override
  String get authErrorMessage => _authExceptionDescription ?? '';

  String _authExceptionDescription;

  @override
  void signInWithEmailAndPassword(String email, String password) {
    _authExceptionDescription = errorMessage;
  }
}

class UserIsLoggedInUserStoreStub extends UserStoreStub {

  UserIsLoggedInUserStoreStub();

  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  @override
  Stream get loggedInStream => _isLoggedInSubject.stream;

  @override
  bool get isLoggedIn => _isLoggedInSubject.value;

  @override
  void subscribeToUserUpdates() {
    _isLoggedInSubject.add(true);
  }
}
