import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/pages/loading_page.dart';
import 'package:metrics/common/presentation/widgets/platform_brightness_observer.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:metrics/feature_config/presentation/view_models/debug_menu_feature_config_view_model.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/debug_menu_notifier_mock.dart';
import '../../../test_utils/feature_config_notifier_mock.dart';
import '../../../test_utils/navigation_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LoadingPage", () {
    AuthNotifier authNotifier;
    FeatureConfigNotifier featureConfigNotifier;
    DebugMenuNotifier debugMenuNotifier;

    const debugMenuViewModel = DebugMenuFeatureConfigViewModel(isEnabled: true);

    setUp(() {
      authNotifier = AuthNotifierMock();
      featureConfigNotifier = FeatureConfigNotifierMock();
      debugMenuNotifier = DebugMenuNotifierMock();
    });

    testWidgets(
      "displayed while the authentication status is unknown",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _LoadingPageTestbed());

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
      "initializes local config if the debug menu is enabled",
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
        verifyNever(debugMenuNotifier.initializeDefaults());
      },
    );

    testWidgets(
      "initializes local config with defaults if the debug menu is not enabled",
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
        verifyNever(debugMenuNotifier.initializeLocalConfig());
      },
    );

    testWidgets(
      "delegates to the navigation notifier once the application finishes initialization",
      (tester) async {
        final navigationNotifier = NavigationNotifierMock();

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(true);
        when(featureConfigNotifier.isInitialized).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isLoading).thenReturn(false);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verify(navigationNotifier.handleAppInitialized(
                isAppInitialized: anyNamed('isAppInitialized')))
            .called(equals(1));
      },
    );

    testWidgets(
      "does not delegate to the navigation notifier if the feature config is loading",
      (WidgetTester tester) async {
        final navigationNotifier = NavigationNotifierMock();

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        when(featureConfigNotifier.isLoading).thenReturn(true);

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(true);
        when(featureConfigNotifier.isInitialized).thenReturn(true);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verifyNever(navigationNotifier.handleAppInitialized(
            isAppInitialized: anyNamed('isAppInitialized')));
      },
    );

    testWidgets(
      "does not delegate to the navigation notifier if the debug menu is loading",
      (WidgetTester tester) async {
        final navigationNotifier = NavigationNotifierMock();

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        when(debugMenuNotifier.isLoading).thenReturn(true);

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(true);
        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(true);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verifyNever(navigationNotifier.handleAppInitialized(
            isAppInitialized: anyNamed('isAppInitialized')));
      },
    );

    testWidgets(
      "does not delegate to the navigation notifier if the auth notifier is not initialized",
      (WidgetTester tester) async {
        final navigationNotifier = NavigationNotifierMock();

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        when(authNotifier.isLoggedIn).thenReturn(null);

        when(authNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(true);
        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(true);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verifyNever(navigationNotifier.handleAppInitialized(
            isAppInitialized: anyNamed('isAppInitialized')));
      },
    );

    testWidgets(
      "does not delegate to the navigation notifier if the feature config is not initialized",
      (WidgetTester tester) async {
        final navigationNotifier = NavigationNotifierMock();

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        when(featureConfigNotifier.isInitialized).thenReturn(false);

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isInitialized).thenReturn(true);
        when(featureConfigNotifier.isLoading).thenReturn(false);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verifyNever(navigationNotifier.handleAppInitialized(
            isAppInitialized: anyNamed('isAppInitialized')));
      },
    );

    testWidgets(
      "does not delegate to the navigation notifier if the debug menu is not initialized",
      (WidgetTester tester) async {
        final navigationNotifier = NavigationNotifierMock();

        when(featureConfigNotifier.debugMenuFeatureConfigViewModel).thenReturn(
          debugMenuViewModel,
        );

        await tester.pumpWidget(
          _LoadingPageTestbed(
            authNotifier: authNotifier,
            featureConfigNotifier: featureConfigNotifier,
            debugMenuNotifier: debugMenuNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        when(debugMenuNotifier.isInitialized).thenReturn(false);

        when(authNotifier.isLoggedIn).thenReturn(true);
        when(authNotifier.isLoading).thenReturn(false);
        when(debugMenuNotifier.isLoading).thenReturn(true);
        when(featureConfigNotifier.isLoading).thenReturn(false);
        when(featureConfigNotifier.isInitialized).thenReturn(true);

        authNotifier.notifyListeners();
        featureConfigNotifier.notifyListeners();
        debugMenuNotifier.notifyListeners();

        verifyNever(navigationNotifier.handleAppInitialized(
            isAppInitialized: anyNamed('isAppInitialized')));
      },
    );

    testWidgets(
      "displays the PlatformBrightnessObserver widget",
      (tester) async {
        await tester.pumpWidget(const _LoadingPageTestbed());

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

  /// A [NavigationNotifier] used in tests.
  final NavigationNotifier navigationNotifier;

  /// Creates the loading page testbed with the given parameters.
  ///
  /// If the given [navigatorObserver] is `null`,
  /// an instance of [NavigatorObserver] is used.
  const _LoadingPageTestbed({
    this.authNotifier,
    this.featureConfigNotifier,
    this.debugMenuNotifier,
    this.navigationNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      authNotifier: authNotifier,
      featureConfigNotifier: featureConfigNotifier,
      debugMenuNotifier: debugMenuNotifier,
      navigationNotifier: navigationNotifier,
      child: Builder(
        builder: (context) {
          return const MaterialApp(
            home: LoadingPage(),
          );
        },
      ),
    );
  }
}
