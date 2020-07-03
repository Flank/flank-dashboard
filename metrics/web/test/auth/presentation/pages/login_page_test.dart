import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/auth_notifier_stub.dart';
import '../../../test_utils/test_injection_container.dart';

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

        await tester.enterText(
          find.widgetWithText(TextFormField, AuthStrings.email),
          'test@email.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, AuthStrings.password),
          'testPassword',
        );
        await tester.tap(find.widgetWithText(RaisedButton, AuthStrings.signIn));

        await tester.pumpAndSettle();

        expect(find.byType(DashboardPage), findsOneWidget);
      },
    );
  });
}

/// A testbed widget, used to test the [LoginPage] widget.
class _LoginPageTestbed extends StatelessWidget {
  /// An [AuthNotifier] used in tests.
  final AuthNotifier authNotifier;

  /// A [ProjectMetricsNotifier] used in tests.
  final ProjectMetricsNotifier metricsNotifier;

  /// Creates the [_LoginPageTestbed] with the given [authNotifier] and [metricsNotifier].
  const _LoginPageTestbed({
    this.authNotifier,
    this.metricsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
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
