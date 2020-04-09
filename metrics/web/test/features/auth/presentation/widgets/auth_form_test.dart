import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:rxdart/rxdart.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:mockito/mockito.dart';

void main() {
  final emailInputFinder =
      find.widgetWithText(AuthInputField, LoginStrings.email);
  final passwordInputFinder =
      find.widgetWithText(AuthInputField, LoginStrings.password);
  final submitButtonFinder =
      find.widgetWithText(RaisedButton, LoginStrings.signIn);

  const testEmail = 'test@email.com';
  const testPassword = 'testPassword';

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
      final userStore = UserStoreMock();

      await tester.pumpWidget(_AuthFormTestbed(userStore: userStore));
      await tester.enterText(emailInputFinder, testEmail);
      await tester.enterText(passwordInputFinder, testPassword);
      await tester.tap(submitButtonFinder);

      verify(userStore.signInWithEmailAndPassword(testEmail, testPassword))
          .called(equals(1));
    });

    testWidgets("shows an auth error text if the login process went wrong",
        (WidgetTester tester) async {
      await tester.pumpWidget(_AuthFormTestbed(
        userStore: SignInErrorUserStoreStub(),
      ));
      await tester.enterText(emailInputFinder, 'test@email.com');
      await tester.enterText(passwordInputFinder, 'testPassword');
      await tester.tap(submitButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text(SignInErrorUserStoreStub.errorMessage), findsOneWidget);
    });
  });
}

class _AuthFormTestbed extends StatelessWidget {
  final UserStore userStore;

  const _AuthFormTestbed({
    this.userStore,
  });

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<UserStore>(() => userStore ?? UserStoreMock()),
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

/// Stub of [UserStore] that emulates presence of auth message error.
class SignInErrorUserStoreStub implements UserStore {
  static const String errorMessage = "Unknown error";

  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  @override
  Stream<bool> get loggedInStream => _isLoggedInSubject.stream;

  @override
  bool get isLoggedIn => false;

  @override
  String get authErrorMessage => _authExceptionDescription;

  String _authExceptionDescription;

  @override
  void signInWithEmailAndPassword(String email, String password) {
    _authExceptionDescription = errorMessage;
  }

  @override
  void subscribeToAuthenticationUpdates() {}

  @override
  void signOut() {}

  @override
  void dispose() {}
}

/// Mock implementation of the [UserStore].
class UserStoreMock extends Mock implements UserStore {}
