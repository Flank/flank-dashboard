import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../../../test_utils/auth_notifier_mock.dart';
import '../../../../test_utils/signed_in_auth_notifier_stub.dart';
import '../../../../test_utils/test_injection_container.dart';
import '../../../../test_utils/theme_notifier_mock.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("MetricsDrawer", () {
    testWidgets(
      "calls the ThemeNotifier.changeTheme() on tap on a checkbox",
      (WidgetTester tester) async {
        final themeNotifier = ThemeNotifierMock();

        when(themeNotifier.isDark).thenReturn(false);

        await tester.pumpWidget(MetricsDrawerTestbed(
          themeNotifier: themeNotifier,
        ));

        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        verify(themeNotifier.changeTheme()).called(equals(1));
      },
    );

    testWidgets(
      "applies a hand cursor to the theme checkbox",
      (WidgetTester tester) async {
        final themeNotifier = ThemeNotifierMock();

        when(themeNotifier.isDark).thenReturn(false);

        await tester.pumpWidget(MetricsDrawerTestbed(
          themeNotifier: themeNotifier,
        ));

        final finder = find.ancestor(
          of: find.text(CommonStrings.darkTheme),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "applies a hand cursor to the 'Project groups' tile",
      (WidgetTester tester) async {
        final themeNotifier = ThemeNotifierMock();

        when(themeNotifier.isDark).thenReturn(false);

        await tester.pumpWidget(MetricsDrawerTestbed(
          themeNotifier: themeNotifier,
        ));

        final finder = find.ancestor(
          of: find.text(CommonStrings.projectGroups),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "applies a hand cursor to the 'Log out' tile",
      (WidgetTester tester) async {
        final themeNotifier = ThemeNotifierMock();

        when(themeNotifier.isDark).thenReturn(false);

        await tester.pumpWidget(MetricsDrawerTestbed(
          themeNotifier: themeNotifier,
        ));

        final finder = find.ancestor(
          of: find.text(CommonStrings.logOut),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "calls the AuthNotifier.signOut() on tap on 'Log out'",
      (tester) async {
        final authNotifier = AuthNotifierMock();

        when(authNotifier.isLoggedIn).thenReturn(true);

        await tester.pumpWidget(MetricsDrawerTestbed(
          authNotifier: authNotifier,
        ));

        await tester.tap(find.text(CommonStrings.logOut));

        await mockNetworkImagesFor(() {
          return tester.pump();
        });

        verify(authNotifier.signOut()).called(equals(1));
      },
    );

    testWidgets(
      "after a user taps on 'Log out' - application navigates back to the login screen",
      (WidgetTester tester) async {
        await tester.pumpWidget(MetricsDrawerTestbed(
          authNotifier: SignedInAuthNotifierStub(),
        ));

        await tester.tap(find.text(CommonStrings.logOut));
        await tester.pumpAndSettle();

        expect(find.byType(LoginPage), findsOneWidget);
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsDrawer] widget.
class MetricsDrawerTestbed extends StatelessWidget {
  /// A [ThemeNotifier] used in tests.
  final ThemeNotifier themeNotifier;

  /// A [ProjectMetricsNotifier] used in tests.
  final ProjectMetricsNotifier metricsNotifier;

  /// An [AuthNotifier] used in tests.
  final AuthNotifier authNotifier;

  /// Creates a [MetricsDrawerTestbed].
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
