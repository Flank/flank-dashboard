import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/pages/login_page.dart';
import 'package:metrics/features/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/features/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../test_utils/auth_notifier_stub.dart';
import '../../../../test_utils/injection_container_testbed.dart';

void main() {
  group("LoginPage", () {
    testWidgets(
      "contains project's title",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _LoginPageTestbed());

        expect(find.text(CommonStrings.metrics), findsOneWidget);
      },
    );

    testWidgets(
      "contains authentication form",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _LoginPageTestbed());

        expect(find.byType(AuthForm), findsOneWidget);
      },
    );

    testWidgets(
      "navigates to the dashboard page if the login was successful",
      (WidgetTester tester) async {
        await tester.pumpWidget(_LoginPageTestbed(
          authNotifier: AuthNotifierStub(),
        ));

        await _signIn(tester);
        await tester.pumpAndSettle();

        expect(find.byType(DashboardPage), findsOneWidget);
      },
    );
  });
}

Future<void> _signIn(WidgetTester tester) async {
  await tester.enterText(
    find.widgetWithText(AuthInputField, AuthStrings.email),
    'test@email.com',
  );
  await tester.enterText(
    find.widgetWithText(AuthInputField, AuthStrings.password),
    'testPassword',
  );
  await tester.tap(find.widgetWithText(RaisedButton, AuthStrings.signIn));
}

class _LoginPageTestbed extends StatelessWidget {
  final AuthNotifier authNotifier;
  final ProjectMetricsNotifier metricsNotifier;

  const _LoginPageTestbed({
    this.authNotifier,
    this.metricsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return InjectionContainerTestbed(
      authNotifier: authNotifier,
      metricsNotifier: metricsNotifier,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: CommonStrings.metrics,
            home: LoginPage(),
            onGenerateRoute: (settings) => RouteGenerator.generateRoute(
              settings: settings,
              isLoggedIn:
                  Provider.of<AuthNotifier>(context, listen: false).isLoggedIn,
            ),
          );
        },
      ),
    );
  }
}
