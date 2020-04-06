import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  Finder emailInput;
  Finder submitButton;

  setUpAll(() async {
    emailInput = find.widgetWithText(AuthInputField, LoginStrings.email);
    submitButton = find.widgetWithText(RaisedButton, LoginStrings.signIn);
  });

  group('Authentication form', () {
    testWidgets('Email input shows error message if value is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(AuthFormTestbed());

      await tester.tap(submitButton);
      await tester.pump();

      final Finder errorText = find.text(LoginStrings.emailIsRequired);

      expect(errorText, findsOneWidget);
    });

    testWidgets('Email input shows error message if value is not a valid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(AuthFormTestbed());
      await tester.enterText(emailInput, 'notAnEmail');

      await tester.tap(submitButton);
      await tester.pump();

      final Finder errorText = find.text(LoginStrings.emailIsInvalid);

      expect(errorText, findsOneWidget);
    });

    testWidgets('Password input shows error message if value is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(AuthFormTestbed());

      await tester.tap(submitButton);
      await tester.pump();

      final Finder errorText = find.text(LoginStrings.passwordIsRequired);

      expect(errorText, findsOneWidget);
    });
  });
}

class AuthFormTestbed extends StatelessWidget {
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
        title: 'Auth form',
        home: Scaffold(
          body: AuthForm(),
        ),
      ),
    );
  }
}
