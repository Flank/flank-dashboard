// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../../test_utils/project_metrics_notifier_mock.dart';
import '../../../../test_utils/signed_in_auth_notifier_stub.dart';
import '../../../../test_utils/test_injection_container.dart';

void main() {
  testWidgets(
    "Changes theme state on tap on a checkbox",
    (WidgetTester tester) async {
      final themeNotifier = ThemeNotifier();

      await tester.pumpWidget(MetricsDrawerTestbed(
        themeNotifier: themeNotifier,
      ));

      expect(themeNotifier.isDark, isTrue);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(themeNotifier.isDark, isFalse);
    },
  );

  testWidgets(
    "After a user taps on 'Log out' - application navigates back to the login screen",
    (WidgetTester tester) async {
      await tester.pumpWidget(MetricsDrawerTestbed(
        authNotifier: SignedInAuthNotifierStub(),
      ));

      await tester.tap(find.text(CommonStrings.logOut));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    },
  );

  testWidgets(
    "Unsubscribes from projects after logout",
    (tester) async {
      final metricsNotifier = ProjectMetricsNotifierMock();

      await tester.pumpWidget(MetricsDrawerTestbed(
        metricsNotifier: metricsNotifier,
      ));

      await tester.tap(find.text(CommonStrings.logOut));
      await tester.pump();

      verify(metricsNotifier.unsubscribeFromProjects()).called(equals(1));
    },
  );
}

/// A testbed widget, used to test the [MetricsDrawer] widget.
class MetricsDrawerTestbed extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final ProjectMetricsNotifier metricsNotifier;
  final AuthNotifier authNotifier;

  const MetricsDrawerTestbed({
    Key key,
    this.themeNotifier,
    this.metricsNotifier,
    this.authNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      themeNotifier: themeNotifier,
      metricsNotifier: metricsNotifier,
      authNotifier: authNotifier,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            home: Scaffold(
              body: MetricsDrawer(),
            ),
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
