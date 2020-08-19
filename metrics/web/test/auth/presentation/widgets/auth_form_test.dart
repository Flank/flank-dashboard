import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/auth/presentation/widgets/sign_in_option_button.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_positive_button.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';
import '../state/auth_notifier_test.dart';

void main() {
  group("AuthForm", () {
    final emailInputFinder =
        find.widgetWithText(MetricsTextFormField, AuthStrings.email);
    final passwordInputFinder =
        find.widgetWithText(MetricsTextFormField, AuthStrings.password);
    final submitButtonFinder =
        find.widgetWithText(MetricsPositiveButton, AuthStrings.signIn);
    final googleSignInButtonFinder =
        find.widgetWithText(SignInOptionButton, AuthStrings.signInWithGoogle);

    const testEmail = 'test@email.com';
    const testPassword = 'testPassword';

    final signInUseCase = SignInUseCaseMock();
    final googleSignInUseCase = GoogleSignInUseCaseMock();
    final signOutUseCase = SignOutUseCaseMock();
    final receiveAuthUpdates = ReceiveAuthenticationUpdatesMock();

    AuthNotifier authNotifier;

    setUp(() {
      authNotifier = AuthNotifier(
        receiveAuthUpdates,
        signInUseCase,
        googleSignInUseCase,
        signOutUseCase,
      );
    });

    testWidgets(
      "email input shows an error message if a value is empty on submit",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _AuthFormTestbed(authNotifier: authNotifier),
          );
        });

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
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _AuthFormTestbed(authNotifier: authNotifier),
          );
        });

        await tester.enterText(emailInputFinder, 'notAnEmail');

        await tester.tap(submitButtonFinder);
        await tester.pump();

        expect(find.text(AuthStrings.invalidEmailErrorMessage), findsOneWidget);
      },
    );

    testWidgets(
      "password input shows an error message if a value is empty on submit",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _AuthFormTestbed(authNotifier: authNotifier),
          );
        });

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

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _AuthFormTestbed(authNotifier: authNotifier),
          );
        });

        await tester.enterText(emailInputFinder, testEmail);
        await tester.enterText(passwordInputFinder, testPassword);
        await tester.tap(submitButtonFinder);

        verify(authNotifier.signInWithEmailAndPassword(testEmail, testPassword))
            .called(equals(1));
      },
    );

    testWidgets(
      "uses the AuthNotifier to sign in a user with Google",
      (WidgetTester tester) async {
        final authNotifier = AuthNotifierMock();

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _AuthFormTestbed(authNotifier: authNotifier),
          );
        });

        await tester.tap(googleSignInButtonFinder);

        verify(authNotifier.signInWithGoogle()).called(equals(1));
      },
    );

    testWidgets(
      "shows an auth error text if the login process went wrong",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_AuthFormTestbed(
            authNotifier: SignInErrorAuthNotifierStub(),
          ));
        });

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

    testWidgets(
      "shows an auth error text if the sign in with Google process went wrong",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_AuthFormTestbed(
            authNotifier: SignInErrorAuthNotifierStub(),
          ));
        });

        await tester.tap(googleSignInButtonFinder);
        await tester.pumpAndSettle();

        expect(
          find.text(SignInErrorAuthNotifierStub.errorMessage),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the google sign in option button",
      (WidgetTester tester) async {
        final authNotifier = AuthNotifierMock();

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _AuthFormTestbed(authNotifier: authNotifier),
          );
        });

        expect(googleSignInButtonFinder, findsOneWidget);
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
  Future<void> signInWithGoogle() async {
    _authExceptionDescription = errorMessage;
    notifyListeners();
  }

  @override
  void subscribeToAuthenticationUpdates() {}

  @override
  Future<void> signOut() async {}
}
