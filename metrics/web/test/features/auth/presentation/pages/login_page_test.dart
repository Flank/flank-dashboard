import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:metrics/features/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../test_utils/metrics_store_stub.dart';
import '../../../../test_utils/signed_in_auth_store_fake.dart';

void main() {
  group("LoginPage", () {
    testWidgets("contains project's title", (WidgetTester tester) async {
      await tester.pumpWidget(const _LoginPageTestbed());

      expect(find.text(CommonStrings.metrics), findsOneWidget);
    });

    testWidgets("contains authentication form", (WidgetTester tester) async {
      await tester.pumpWidget(const _LoginPageTestbed());

      expect(find.byType(AuthForm), findsOneWidget);
    });

    testWidgets("navigates to the dashboard page if the login was successful",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _LoginPageTestbed());

      await tester.enterText(
        find.widgetWithText(AuthInputField, AuthStrings.email),
        'test@email.com',
      );
      await tester.enterText(
        find.widgetWithText(AuthInputField, AuthStrings.password),
        'testPassword',
      );
      await tester.tap(find.widgetWithText(RaisedButton, AuthStrings.signIn));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets(
        "redirects to the dashboard page if a user is already signed in",
        (WidgetTester tester) async {
      await tester.pumpWidget(_LoginPageTestbed(
        authStore: SignedInAuthStoreFake(),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });
  });
}

class _LoginPageTestbed extends StatelessWidget {
  final AuthStore authStore;

  const _LoginPageTestbed({
    this.authStore,
  });

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<AuthStore>(() => authStore ?? AuthStore()),
        Inject<ProjectMetricsStore>(() => const MetricsStoreStub()),
      ],
      initState: () {
        Injector.getAsReactive<AuthStore>().setState(
          (store) => store.subscribeToAuthenticationUpdates(),
        );
        Injector.getAsReactive<ProjectMetricsStore>().setState(
          (store) => store.subscribeToProjects(),
          catchError: true,
        );
      },
      builder: (BuildContext context) {
        return MaterialApp(
          title: 'Login Page',
          onGenerateRoute: (settings) =>
              RouteGenerator.generateRoute(settings: settings),
        );
      },
    );
  }
}
