import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/pages/loading_page.dart';
import 'package:metrics/features/auth/presentation/pages/login_page.dart';
import 'package:metrics/features/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../../test_utils/auth_notifier_mock.dart';
import '../../../../test_utils/injection_container_testbed.dart';
import '../../../../test_utils/signed_in_auth_notifier_stub.dart';

void main() {
  group("LoadingPage", () {
    testWidgets("displays on the application initial loading",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _LoadingPageTestbed());

      expect(find.byType(LoadingPage), findsOneWidget);
    });

    testWidgets("redirects to the LoginPage if a user is not signed in",
        (WidgetTester tester) async {
      final AuthNotifierMock authNotifier = AuthNotifierMock();

      when(authNotifier.isLoggedIn).thenReturn(false);

      await tester.pumpWidget(_LoadingPageTestbed(
        authNotifier: authNotifier,
      ));

      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets("redirects to the DashboardPage if a user is signed in",
        (WidgetTester tester) async {
      await tester.pumpWidget(_LoadingPageTestbed(
        authNotifier: SignedInAuthNotifierStub(),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });
  });
}

class _LoadingPageTestbed extends StatelessWidget {
  final AuthNotifier authNotifier;
  final ProjectMetricsNotifier metricsNotifier;

  const _LoadingPageTestbed({
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
