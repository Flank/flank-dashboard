import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';
import '../state/auth_notifier_test.dart';

void main() {
  group("AuthForm", () {
    final emailInputFinder =
        find.widgetWithText(TextFormField, AuthStrings.email);
    final passwordInputFinder =
        find.widgetWithText(TextFormField, AuthStrings.password);
    final submitButtonFinder =
        find.widgetWithText(RaisedButton, AuthStrings.signIn);

    const testEmail = 'test@email.com';
    const testPassword = 'testPassword';

    final signInUseCase = SignInUseCaseMock();
    final signOutUseCase = SignOutUseCaseMock();
    final receiveAuthUpdates = ReceiveAuthenticationUpdatesMock();

    AuthNotifier authNotifier;

    setUp(() {
      authNotifier = AuthNotifier(
        receiveAuthUpdates,
        signInUseCase,
        signOutUseCase,
      );
    });

    testWidgets(
      "email input shows an error message if a value is empty on submit",
      (WidgetTester tester) async {
        await tester.pumpWidget(_AuthFormTestbed(authNotifier: authNotifier));

        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();

        expect(
          find.text(AuthStrings.emailRequiredErrorMessage),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "email input shows an error message if a value is not a valid email on submit",
      (WidgetTester tester) async {
        await tester.pumpWidget(_AuthFormTestbed(authNotifier: authNotifier));
        await tester.enterText(emailInputFinder, 'notAnEmail');

        await tester.tap(submitButtonFinder);
        await tester.pump();

        expect(find.text(AuthStrings.invalidEmailErrorMessage), findsOneWidget);
      },
    );

    testWidgets(
      "password input shows an error message if a value is empty on submit",
      (WidgetTester tester) async {
        await tester.pumpWidget(_AuthFormTestbed(authNotifier: authNotifier));

        await tester.tap(submitButtonFinder);
        await tester.pump();

        expect(
          find.text(AuthStrings.passwordRequiredErrorMessage),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "uses the AuthNotifier to sign in a user",
      (WidgetTester tester) async {
        final authNotifier = AuthNotifierMock();

        await tester.pumpWidget(_AuthFormTestbed(authNotifier: authNotifier));
        await tester.enterText(emailInputFinder, testEmail);
        await tester.enterText(passwordInputFinder, testPassword);
        await tester.tap(submitButtonFinder);

        verify(authNotifier.signInWithEmailAndPassword(testEmail, testPassword))
            .called(equals(1));
      },
    );

    testWidgets(
      "shows an auth error text if the login process went wrong",
      (WidgetTester tester) async {
        await tester.pumpWidget(_AuthFormTestbed(
          authNotifier: SignInErrorAuthNotifierStub(),
        ));
        await tester.enterText(emailInputFinder, 'test@email.com');
        await tester.enterText(passwordInputFinder, 'testPassword');
        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();

        expect(
          find.text(SignInErrorAuthNotifierStub.errorMessage),
          findsOneWidget,
        );
      },
    );
  });
}

/// A testbed widget, used to test the [AuthForm] widget.
class _AuthFormTestbed extends StatelessWidget {
  /// An [AuthNotifier] used in tests.
  final AuthNotifier authNotifier;

  /// Creates the [_AuthFormTestbed] with the given [authNotifier].
  const _AuthFormTestbed({
    this.authNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      authNotifier: authNotifier,
      child: MaterialApp(
        home: Scaffold(
          body: AuthForm(),
        ),
      ),
    );
  }
}

/// Stub of the [AuthNotifier] that emulates presence of auth message error.
class SignInErrorAuthNotifierStub extends ChangeNotifier
    implements AuthNotifier {
  /// An error message, thrown during the login process.
  static const errorMessage = "Unknown error message";

  @override
  bool get isLoggedIn => false;

  @override
  String get authErrorMessage => _authExceptionDescription;

  /// Contains text description of any authentication exception that may occur.
  String _authExceptionDescription;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _authExceptionDescription = errorMessage;
    notifyListeners();
  }

  @override
  void subscribeToAuthenticationUpdates() {}

  @override
  Future<void> signOut() async {}
}
