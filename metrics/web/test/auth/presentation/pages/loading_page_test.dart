import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/pages/loading_page.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/platform_brightness_observer.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/instant_config/presentation/state/instant_config_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/instant_config_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("LoadingPage", () {
    testWidgets(
      "displayed while the authentication status is unknown",
      (WidgetTester tester) async {
        await tester.pumpWidget(_LoadingPageTestbed());

        expect(find.byType(LoadingPage), findsOneWidget);
      },
    );

    testWidgets(
      "subscribes to authentication updates on init state",
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
      "redirects to the login page if a user is not logged in and the remote config is initialized",
      (WidgetTester tester) async {
        final authNotifier = AuthNotifierMock();
        final instantConfigNotifier = InstantConfigNotifierMock();

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            instantConfigNotifier: instantConfigNotifier,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(false);
        when(authNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isLoading).thenReturn(false);

        authNotifier.notifyListeners();

        await mockNetworkImagesFor(() {
          return tester.pumpAndSettle();
        });

        expect(find.byType(LoginPage), findsOneWidget);
      },
    );

    testWidgets(
      "redirects to the dashboard page if a user is logged in and the remote config is initialized",
      (WidgetTester tester) async {
        final authNotifier = AuthNotifierMock();
        final instantConfigNotifier = InstantConfigNotifierMock();

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            instantConfigNotifier: instantConfigNotifier,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isLoading).thenReturn(false);

        authNotifier.notifyListeners();

        await mockNetworkImagesFor(() {
          return tester.pumpAndSettle();
        });

        expect(find.byType(DashboardPage), findsOneWidget);
      },
    );

    testWidgets(
      "does not redirect from the loading page if a user is logged in and the remote config is not initialized",
      (WidgetTester tester) async {
        final authNotifier = AuthNotifierMock();
        final instantConfigNotifier = InstantConfigNotifierMock();
        final navigatorObserver = _NavigatorObserverMock();

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            instantConfigNotifier: instantConfigNotifier,
            navigatorObserver: navigatorObserver,
          ),
        );

        reset(navigatorObserver);

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isLoading).thenReturn(true);

        authNotifier.notifyListeners();

        await mockNetworkImagesFor(() {
          return tester.pump();
        });

        verifyNever(navigatorObserver.didPush(any, any));
      },
    );

    testWidgets(
      "does not redirect from the loading page if a user is not logged in and the remote config is not initialized",
      (WidgetTester tester) async {
        final authNotifier = AuthNotifierMock();
        final instantConfigNotifier = InstantConfigNotifierMock();
        final navigatorObserver = _NavigatorObserverMock();

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            instantConfigNotifier: instantConfigNotifier,
            navigatorObserver: navigatorObserver,
          ),
        );

        reset(navigatorObserver);

        when(authNotifier.isLoggedIn).thenReturn(false);
        when(authNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isLoading).thenReturn(true);

        authNotifier.notifyListeners();

        await mockNetworkImagesFor(() {
          return tester.pump();
        });

        verifyNever(navigatorObserver.didPush(any, any));
      },
    );

    testWidgets(
      "displays the PlatformBrightnessObserver widget",
      (tester) async {
        await tester.pumpWidget(_LoadingPageTestbed());

        expect(find.byType(PlatformBrightnessObserver), findsOneWidget);
      },
    );
  });
}

/// A testbed widget, used to test the [LoadingPage] widget.
class _LoadingPageTestbed extends StatelessWidget {
  /// An [AuthNotifier] used in tests.
  final AuthNotifier authNotifier;

  /// An [InstantConfigNotifier] used in tests.
  final InstantConfigNotifier instantConfigNotifier;

  /// A [Navigator] observer used in tests.
  final NavigatorObserver navigatorObserver;

  /// Creates the loading page testbed with the given [authNotifier]
  /// and [instantConfigNotifier].
  _LoadingPageTestbed({
    this.authNotifier,
    this.instantConfigNotifier,
    NavigatorObserver navigatorObserver,
  }) : navigatorObserver = navigatorObserver ?? NavigatorObserver();

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      authNotifier: authNotifier,
      instantConfigNotifier: instantConfigNotifier,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: CommonStrings.metrics,
            onGenerateRoute: (settings) => RouteGenerator.generateRoute(
              settings: settings,
              isLoggedIn:
                  Provider.of<AuthNotifier>(context, listen: false).isLoggedIn,
            ),
            navigatorObservers: [navigatorObserver],
          );
        },
      ),
    );
  }
}

class _NavigatorObserverMock extends Mock implements NavigatorObserver {}
