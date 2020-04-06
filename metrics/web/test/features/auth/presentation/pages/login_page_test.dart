import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/pages/login_page.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  group('Login page', () {
    testWidgets('contains project\'s title', (WidgetTester tester) async {
      await tester.pumpWidget(LoginPageTestbed());

      final Finder title = find.text(CommonStrings.metrics);

      expect(title, findsOneWidget);
    });

    testWidgets('contains authentication form', (WidgetTester tester) async {
      await tester.pumpWidget(LoginPageTestbed());

      final Finder emailInput =
          find.widgetWithText(AuthInputField, LoginStrings.email);
      expect(emailInput, findsOneWidget);

      final Finder passwordInput =
          find.widgetWithText(AuthInputField, LoginStrings.password);
      expect(passwordInput, findsOneWidget);

      final Finder signInButton =
          find.widgetWithText(RaisedButton, LoginStrings.signIn);
      expect(signInButton, findsOneWidget);
    });
  });
}

class LoginPageTestbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<UserStore>(() => UserStore()),
      ],
      initState: () {
        Injector.getAsReactive<UserStore>().setState(
          (store) => store.subscribeToUserUpdates(),
        );
      },
      builder: (BuildContext context) => MaterialApp(
        title: 'Login Page',
        home: LoginPage(),
      ),
    );
  }
}
