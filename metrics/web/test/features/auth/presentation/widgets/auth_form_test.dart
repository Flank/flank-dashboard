import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:mockito/mockito.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

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

    testWidgets("password input shows error message if value is less then 6",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthFormTestbed());

      await tester.enterText(passwordInputFinder, '12345');
      await tester.tap(submitButtonFinder);
      await tester.pump();

      expect(find.text(LoginStrings.passwordMinLength), findsOneWidget);
    });

    testWidgets("password input shows a value replaced by bullets",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthFormTestbed());
      await tester.enterText(passwordInputFinder, 'x');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final String editText =
          _findRenderEditable(tester, passwordInputFinder).text.text;

      expect(editText, '\u2022');
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
        authStore: SignInErrorAuthStoreMock(),
      ));
      await tester.enterText(emailInputFinder, 'test@email.com');
      await tester.enterText(passwordInputFinder, 'testPassword');
      await tester.tap(submitButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text(SignInErrorAuthStoreMock.errorMessage), findsOneWidget);
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

/// Mock implementation of the [AuthStore] that emulates presence of auth message error.
class SignInErrorAuthStoreMock extends Mock implements AuthStore {
  static const String errorMessage = "Unknown error";

  SignInErrorAuthStoreMock() {
    when(authErrorMessage).thenReturn(errorMessage);
  }
}

/// Mock implementation of the [AuthStore].
class AuthStoreMock extends Mock implements AuthStore {}

/// Returns the first [RenderEditable].
RenderEditable _findRenderEditable(WidgetTester tester, Finder finder) {
  final RenderObject root = tester.renderObject(finder);

  RenderEditable renderEditable;
  void recursiveFinder(RenderObject child) {
    if (child is RenderEditable) {
      renderEditable = child;
      return;
    }
    child.visitChildren(recursiveFinder);
  }

  root.visitChildren(recursiveFinder);
  return renderEditable;
}
