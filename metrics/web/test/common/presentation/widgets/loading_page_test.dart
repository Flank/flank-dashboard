import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/loading_page.dart';
import 'package:metrics/common/presentation/widgets/platform_brightness_observer.dart';
import 'package:metrics/instant_config/presentation/state/instant_config_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/instant_config_notifier_mock.dart';
import '../../../test_utils/matcher_util.dart';
import '../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LoadingPage", () {
    AuthNotifier authNotifier;
    InstantConfigNotifier instantConfigNotifier;
    final observer = _NavigatorObserverMock();

    final dashboardRoute = MatcherUtil.metricsNamedRoute(
      equals(RouteName.dashboard),
    );
    final loginPageRoute = MatcherUtil.metricsNamedRoute(
      equals(RouteName.login),
    );
    final loadingPageRoute = isA<MaterialPageRoute>().having(
      (route) => route?.settings?.name,
      'route name',
      Navigator.defaultRouteName,
    );

    setUp(() {
      authNotifier = AuthNotifierMock();
      instantConfigNotifier = InstantConfigNotifierMock();
    });

    tearDown(() {
      reset(observer);
    });

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
        await tester.pumpWidget(_LoadingPageTestbed(
          authNotifier: authNotifier,
        ));

        verify(authNotifier.subscribeToAuthenticationUpdates())
            .called(equals(1));
      },
    );

    testWidgets(
      "initializes instant config updates on init state",
      (tester) async {
        await tester.pumpWidget(_LoadingPageTestbed(
          instantConfigNotifier: instantConfigNotifier,
        ));

        verify(instantConfigNotifier.initializeInstantConfig())
            .called(equals(1));
      },
    );

    testWidgets(
      "redirects to the login page if a user is not logged in and the remote config is initialized",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            instantConfigNotifier: instantConfigNotifier,
            navigatorObserver: observer,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(false);
        when(authNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isInitialized).thenReturn(true);

        authNotifier.notifyListeners();
        instantConfigNotifier.notifyListeners();

        verify(observer.didPush(
          argThat(loginPageRoute),
          argThat(loadingPageRoute),
        )).called(1);
      },
    );

    testWidgets(
      "redirects to the page with the given route name if a user is logged in and the remote config is initialized",
      (WidgetTester tester) async {
        const routeName = RouteName.projectGroup;
        final projectGroupRoute = MatcherUtil.metricsNamedRoute(
          equals(routeName),
        );

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            instantConfigNotifier: instantConfigNotifier,
            navigatorObserver: observer,
            routeName: routeName,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isInitialized).thenReturn(true);

        authNotifier.notifyListeners();
        instantConfigNotifier.notifyListeners();

        verify(observer.didPush(
          argThat(projectGroupRoute),
          argThat(loadingPageRoute),
        )).called(1);
      },
    );

    testWidgets(
      "redirects to the dashboard page if a user is logged in, the remote config is initialized and the route name is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            instantConfigNotifier: instantConfigNotifier,
            navigatorObserver: observer,
            routeName: null,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isInitialized).thenReturn(true);

        authNotifier.notifyListeners();
        instantConfigNotifier.notifyListeners();

        verify(observer.didPush(
          argThat(dashboardRoute),
          argThat(loadingPageRoute),
        )).called(1);
      },
    );

    testWidgets(
      "does not redirect from the loading page if a user is logged in and the remote config is not initialized",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            instantConfigNotifier: instantConfigNotifier,
            navigatorObserver: observer,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isInitialized).thenReturn(false);

        authNotifier.notifyListeners();
        instantConfigNotifier.notifyListeners();

        verifyNever(observer.didPush(
          any,
          argThat(loadingPageRoute),
        ));
      },
    );

    testWidgets(
      "does not redirect from the loading page if a user is not logged in and the remote config is not initialized",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            instantConfigNotifier: instantConfigNotifier,
            navigatorObserver: observer,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(false);
        when(authNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isLoading).thenReturn(false);
        when(instantConfigNotifier.isInitialized).thenReturn(false);

        authNotifier.notifyListeners();
        instantConfigNotifier.notifyListeners();

        verifyNever(observer.didPush(
          any,
          argThat(loadingPageRoute),
        ));
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
  /// An [AuthNotifier] to use in tests.
  final AuthNotifier authNotifier;

  /// An [InstantConfigNotifier] to use in tests.
  final InstantConfigNotifier instantConfigNotifier;

  /// A [NavigatorObserver] to use in tests.
  final NavigatorObserver navigatorObserver;

  /// A route name to push when loading is completed and
  /// the current user is logged in.
  final String routeName;

  /// Creates the loading page testbed with the given parameters.
  ///
  /// If the given [navigatorObserver] is `null`,
  /// an instance of [NavigatorObserver] is used.
  _LoadingPageTestbed({
    NavigatorObserver navigatorObserver,
    this.authNotifier,
    this.instantConfigNotifier,
    this.routeName,
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
            home: LoadingPage(
              routeName: routeName,
            ),
          );
        },
      ),
    );
  }
}

class _NavigatorObserverMock extends Mock implements NavigatorObserver {}
