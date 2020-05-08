import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/pages/loading_page.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/signed_in_auth_notifier_stub.dart';
import '../../../test_utils/test_injection_container.dart';

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

/// A testbed widget, used to test the [LoadingPage] widget.
class _LoadingPageTestbed extends StatelessWidget {
  final AuthNotifier authNotifier;
  final ProjectMetricsNotifier metricsNotifier;

  /// Creates the [_LoadingPageTestbed] with the given [authNotifier] and [metricsNotifier].
  const _LoadingPageTestbed({
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
