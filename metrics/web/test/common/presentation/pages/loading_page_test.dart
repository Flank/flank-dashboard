import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/pages/loading_page.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/platform_brightness_observer.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:metrics/feature_config/presentation/view_models/debug_menu_feature_config_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/debug_menu_notifier_mock.dart';
import '../../../test_utils/feature_config_notifier_mock.dart';
import '../../../test_utils/matcher_util.dart';
import '../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LoadingPage", () {
    AuthNotifier authNotifier;
    FeatureConfigNotifier featureConfigNotifier;
    DebugMenuNotifier debugMenuNotifier;

    final observer = _NavigatorObserverMock();

    final dashboardRoute = MatcherUtil.metricsNamedRoute(
      equals(RouteName.dashboard),
    );
    final loginPageRoute = MatcherUtil.metricsNamedRoute(
      equals(RouteName.login),
    );
    final loadingPageRoute = MatcherUtil.metricsNamedRoute(isNull);

    const debugMenuViewModel = DebugMenuFeatureConfigViewModel(isEnabled: true);

    setUp(() {
      authNotifier = AuthNotifierMock();
      featureConfigNotifier = FeatureConfigNotifierMock();
      debugMenuNotifier = DebugMenuNotifierMock();
    });

    tearDown(() {
      reset(observer);
    });

    void setInitialRoute(WidgetTester tester, String initialRoute) {
      final defaultRouteBuffer = tester.binding.window.defaultRouteName;

      tester.binding.window.defaultRouteNameTestValue = initialRoute;
      addTearDown(() {
        tester.binding.window.defaultRouteNameTestValue = defaultRouteBuffer;
      });
    }

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
      "initializes feature config updates on init state",
      (tester) async {
        await tester.pumpWidget(_LoadingPageTestbed(
          featureConfigNotifier: featureConfigNotifier,
        ));

        verify(featureConfigNotifier.initializeConfig()).called(equals(1));
      },
    );

    testWidgets(
      "initializes local config on init state if the debug menu is enabled in the feature config",
      (tester) async {
        when(featureConfigNotifier.debugMenuFeatureConfigViewModel)
            .thenReturn(const DebugMenuFeatureConfigViewModel(isEnabled: true));

        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(true);

        await tester.pumpWidget(_LoadingPageTestbed(
          featureConfigNotifier: featureConfigNotifier,
          debugMenuNotifier: debugMenuNotifier,
        ));

        featureConfigNotifier.notifyListeners();

        verify(debugMenuNotifier.initializeLocalConfig()).called(1);
      },
    );

    testWidgets(
      "initializes local config with defaults on init state if the debug menu is not enabled in the feature config",
      (tester) async {
        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
            const DebugMenuFeatureConfigViewModel(isEnabled: false));

        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(true);

        await tester.pumpWidget(_LoadingPageTestbed(
          featureConfigNotifier: featureConfigNotifier,
          debugMenuNotifier: debugMenuNotifier,
        ));

        featureConfigNotifier.notifyListeners();

        verify(debugMenuNotifier.initializeDefaults()).called(1);
      },
    );

    testWidgets(
      "redirects to the login page if a user is not logged and all notifiers finished loading",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigatorObserver: observer,
          ),
        );

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        when(authNotifier.isLoggedIn).thenReturn(false);
        when(authNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(true);
        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(true);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verify(observer.didPush(
          argThat(loginPageRoute),
          argThat(loadingPageRoute),
        )).called(1);
      },
    );

    testWidgets(
      "redirects to the page with the given route name if a user is logged in and all notifiers finished loading",
      (WidgetTester tester) async {
        const routeName = RouteName.projectGroup;
        final projectGroupRoute = MatcherUtil.metricsNamedRoute(
          equals(routeName),
        );

        setInitialRoute(tester, routeName);
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigatorObserver: observer,
          ),
        );

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(true);
        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(true);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verify(observer.didPush(
          argThat(projectGroupRoute),
          argThat(loadingPageRoute),
        )).called(1);
      },
    );

    testWidgets(
      "redirects to the dashboard page if a user is logged in, all notifiers finished loading and the route name is null",
      (WidgetTester tester) async {
        setInitialRoute(tester, null);
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigatorObserver: observer,
          ),
        );

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(true);
        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(true);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verify(observer.didPush(
          argThat(dashboardRoute),
          argThat(loadingPageRoute),
        )).called(1);
      },
    );

    testWidgets(
      "does not redirect from the loading page if a user is logged in, local config is initialized, but the feature config is not initialized",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigatorObserver: observer,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(true);

        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(false);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verifyNever(observer.didPush(
          any,
          argThat(loadingPageRoute),
        ));
      },
    );

    testWidgets(
      "does not redirect from the loading page if a user is not logged in, local config is initialized, but the feature config is not initialized",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigatorObserver: observer,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(false);
        when(authNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(true);

        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(false);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verifyNever(observer.didPush(
          any,
          argThat(loadingPageRoute),
        ));
      },
    );

    testWidgets(
      "does not redirect from the loading page if a user is logged in, feature config is initialized, but the local config is not initialized",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigatorObserver: observer,
          ),
        );

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(true);

        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(false);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verifyNever(observer.didPush(
          any,
          argThat(loadingPageRoute),
        ));
      },
    );

    testWidgets(
      "does not redirect from the loading page if a user is not logged in, feature config is initialized, but the local config is not initialized",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigatorObserver: observer,
          ),
        );

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        when(authNotifier.isLoggedIn).thenReturn(false);
        when(authNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(true);

        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(false);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

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

  /// A [FeatureConfigNotifier] to use in tests.
  final FeatureConfigNotifier featureConfigNotifier;

  /// A [DebugMenuNotifier] to use in tests.
  final DebugMenuNotifier debugMenuNotifier;

  /// A [NavigatorObserver] to use in tests.
  final NavigatorObserver navigatorObserver;

  /// Creates the loading page testbed with the given parameters.
  ///
  /// If the given [navigatorObserver] is `null`,
  /// an instance of [NavigatorObserver] is used.
  _LoadingPageTestbed({
    NavigatorObserver navigatorObserver,
    this.authNotifier,
    this.featureConfigNotifier,
    this.debugMenuNotifier,
  }) : navigatorObserver = navigatorObserver ?? NavigatorObserver();

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      authNotifier: authNotifier,
      featureConfigNotifier: featureConfigNotifier,
      debugMenuNotifier: debugMenuNotifier,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: CommonStrings.metrics,
            initialRoute: '/',
            onGenerateInitialRoutes: (String initialRoute) {
              final isLoggedIn = Provider.of<AuthNotifier>(
                context,
                listen: false,
              ).isLoggedIn;

              return [
                RouteGenerator.generateRoute(
                  settings: RouteSettings(name: initialRoute),
                  isLoggedIn: isLoggedIn,
                ),
              ];
            },
            onGenerateRoute: (settings) {
              return RouteGenerator.generateRoute(
                settings: settings,
                isLoggedIn: Provider.of<AuthNotifier>(context, listen: false)
                    .isLoggedIn,
              );
            },
            navigatorObservers: [navigatorObserver],
          );
        },
      ),
    );
  }
}

class _NavigatorObserverMock extends Mock implements NavigatorObserver {}
