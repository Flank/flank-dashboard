import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:metrics/features/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:mockito/mockito.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  final emailInputFinder =
      find.widgetWithText(AuthInputField, AuthStrings.email);
  final passwordInputFinder =
      find.widgetWithText(AuthInputField, AuthStrings.password);
  final signInButtonFinder =
      find.widgetWithText(RaisedButton, AuthStrings.signIn);

  const testEmail = 'test@email.com';
  const testPassword = 'testPassword';

  group("AuthForm", () {
    testWidgets("email input shows error message if value is empty",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthFormTestbed());

      await tester.tap(signInButtonFinder);
      await tester.pump();

      expect(find.text(AuthStrings.emailIsRequired), findsOneWidget);
    });

    testWidgets("email input shows error message if value is not a valid email",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthFormTestbed());
      await tester.enterText(emailInputFinder, 'notAnEmail');

      await tester.tap(signInButtonFinder);
      await tester.pump();

      expect(find.text(AuthStrings.emailIsInvalid), findsOneWidget);
    });

    testWidgets("password input shows error message if value is empty",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthFormTestbed());

      await tester.tap(signInButtonFinder);
      await tester.pump();

      expect(find.text(AuthStrings.passwordIsRequired), findsOneWidget);
    });

    testWidgets("password input shows error message if value is less then 6",
        (WidgetTester tester) async {
      const _minPasswordLength = 6;
      await tester.pumpWidget(const _AuthFormTestbed());

      await tester.enterText(passwordInputFinder, '12345');
      await tester.tap(signInButtonFinder);
      await tester.pump();

      expect(
        find.text(
            AuthStrings.getPasswordMinLengthErrorMessage(_minPasswordLength)),
        findsOneWidget,
      );
    });

    testWidgets("password input text is obscure", (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthFormTestbed());

      final passwordField =
          tester.widget(passwordInputFinder) as AuthInputField;

      expect(passwordField.obscureText, isTrue);
    });

    testWidgets("integrated with AuthStore", (WidgetTester tester) async {
      final authStore = AuthStoreMock();

      await tester.pumpWidget(_AuthFormTestbed(authStore: authStore));
      await tester.enterText(emailInputFinder, testEmail);
      await tester.enterText(passwordInputFinder, testPassword);
      await tester.tap(signInButtonFinder);

      verify(authStore.signInWithEmailAndPassword(testEmail, testPassword))
          .called(equals(1));
    });

    testWidgets("shows an auth error text if the login process went wrong",
        (WidgetTester tester) async {
      final authStore = AuthStoreMock();
      const errorMessage = 'Unknown Error';
      when(authStore.authErrorMessage).thenReturn(errorMessage);

      await tester.pumpWidget(_AuthFormTestbed(authStore: authStore));
      await tester.enterText(emailInputFinder, 'test@email.com');
      await tester.enterText(passwordInputFinder, 'testPassword');
      await tester.tap(signInButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
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

/// Mock implementation of the [AuthStore].
class AuthStoreMock extends Mock implements AuthStore {}
