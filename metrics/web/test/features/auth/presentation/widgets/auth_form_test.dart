import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
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
      final authStore = AuthStoreMock();

      await tester.pumpWidget(_AuthFormTestbed(authStore: authStore));
      await tester.enterText(emailInputFinder, testEmail);
      await tester.enterText(passwordInputFinder, testPassword);
      await tester.tap(submitButtonFinder);

      verify(authStore.signInWithEmailAndPassword(testEmail, testPassword))
          .called(equals(1));
    });

    testWidgets("shows an auth error text if the login process went wrong",
        (WidgetTester tester) async {
      await tester.pumpWidget(_AuthFormTestbed(
        authStore: SignInErrorAuthStoreStub(),
      ));
      await tester.enterText(emailInputFinder, 'test@email.com');
      await tester.enterText(passwordInputFinder, 'testPassword');
      await tester.tap(submitButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text(SignInErrorAuthStoreStub.errorMessage), findsOneWidget);
    });
  });
}

class _AuthFormTestbed extends StatelessWidget {
  final AuthStore authStore;

  const _AuthFormTestbed({
    this.authStore,
  });

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<AuthStore>(() => authStore ?? AuthStoreMock()),
      ],
      initState: () {
        Injector.getAsReactive<AuthStore>().setState(
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

/// Stub of [AuthStore] that emulates presence of auth message error.
class SignInErrorAuthStoreStub implements AuthStore {
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

/// Mock implementation of the [AuthStore].
class AuthStoreMock extends Mock implements AuthStore {}
