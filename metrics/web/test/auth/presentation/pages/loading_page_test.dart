import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/pages/loading_page.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/binding_util.dart';
import '../../../test_utils/test_injection_container.dart';
import '../../../test_utils/theme_notifier_mock.dart';

void main() {
  group("LoadingPage", () {
    testWidgets(
      "displayed while the authentication status is unknown",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _LoadingPageTestbed());

        expect(find.byType(LoadingPage), findsOneWidget);
      },
    );

    testWidgets(
      "subscribes to authentication updates on initState",
      (tester) async {
        final authNotifier = AuthNotifierMock();

        await tester.pumpWidget(_LoadingPageTestbed(
          authNotifier: authNotifier,
        ));

        verify(authNotifier.subscribeToAuthenticationUpdates())
            .called(equals(1));
      },
    );

    testWidgets(
      "redirects to the LoginPage if a user is not logged in",
      (WidgetTester tester) async {
        final authNotifier = AuthNotifierMock();

        await tester
            .pumpWidget(_LoadingPageTestbed(authNotifier: authNotifier));

        when(authNotifier.isLoggedIn).thenReturn(false);
        when(authNotifier.isLoading).thenReturn(false);
        authNotifier.notifyListeners();

        await mockNetworkImagesFor(() {
          return tester.pumpAndSettle();
        });

        expect(find.byType(LoginPage), findsOneWidget);
      },
    );

    testWidgets(
      "redirects to the DashboardPage if a user is logged in",
      (WidgetTester tester) async {
        final authNotifier = AuthNotifierMock();

        await tester.pumpWidget(
          _LoadingPageTestbed(authNotifier: authNotifier),
        );

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        authNotifier.notifyListeners();

        await mockNetworkImagesFor(() {
          return tester.pumpAndSettle();
        });

        expect(find.byType(DashboardPage), findsOneWidget);
      },
    );

    testWidgets(
      "sets the application theme based on the platform brightness once opened",
      (tester) async {
        final themeNotifier = ThemeNotifierMock();
        final currentBrightness = tester.binding.window.platformBrightness;

        await tester.pumpWidget(
          _LoadingPageTestbed(themeNotifier: themeNotifier),
        );

        verify(themeNotifier.setTheme(currentBrightness)).called(equals(1));
      },
    );

    testWidgets(
      "updates the application theme based on the platform brightness once brightness changed",
      (tester) async {
        const brightness = Brightness.dark;
        final themeNotifier = ThemeNotifierMock();
        BindingUtil.setPlatformBrightness(tester, Brightness.light);

        await tester.pumpWidget(_LoadingPageTestbed(
          themeNotifier: themeNotifier,
        ));

        BindingUtil.setPlatformBrightness(tester, brightness);
        await tester.pump();

        verify(themeNotifier.setTheme(brightness)).called(equals(1));
      },
    );
  });
}

/// A testbed widget, used to test the [LoadingPage] widget.
class _LoadingPageTestbed extends StatelessWidget {
  /// An [AuthNotifier] used in tests.
  final AuthNotifier authNotifier;

  /// A [ThemeNotifier] used in tests.
  final ThemeNotifier themeNotifier;

  /// Creates the [_LoadingPageTestbed] with the given [authNotifier].
  const _LoadingPageTestbed({
    this.authNotifier,
    this.themeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      authNotifier: authNotifier,
      themeNotifier: themeNotifier,
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
