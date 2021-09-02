// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/navigation/widgets/page_parameters_proxy.dart';
import 'package:metrics/common/presentation/state/page_notifier.dart';
import 'package:metrics/dashboard/presentation/models/dashboard_page_parameters_model.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_utils/matchers.dart';
import '../../../../test_utils/navigation_notifier_mock.dart';
import '../../../../test_utils/page_notifier_mock.dart';
import '../../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("PageParametersProxy", () {
    PageNotifier pageNotifier;
    RouteConfiguration dashboardConfiguration;
    RouteConfiguration loginConfiguration;
    NavigationNotifier navigationNotifier;

    setUp((){
      pageNotifier = PageNotifierMock();
      dashboardConfiguration = RouteConfiguration.dashboard();
      navigationNotifier = NavigationNotifierMock();
      loginConfiguration = RouteConfiguration.login();
    });

    tearDown(() {
      reset(pageNotifier);
    });

     void whenNavigationNotifierConfiguration(RouteConfiguration configuration){
      return when(navigationNotifier.currentConfiguration)
          .thenReturn(configuration);
    }

    testWidgets(
      "throws an AssertionError if the given child is null",
      (tester) async {
        await tester.pumpWidget(
          _PageParametersProxyTestbed(pageNotifier: pageNotifier, child: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given page notifier is null",
      (tester) async {
        await tester.pumpWidget(
          const _PageParametersProxyTestbed(pageNotifier: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given child",
      (tester) async {
        const textWidget = Text('test');

        when(navigationNotifier.currentConfiguration)
            .thenReturn(dashboardConfiguration);

        await tester.pumpWidget(
          _PageParametersProxyTestbed(
            pageNotifier: pageNotifier,
            navigationNotifier: navigationNotifier,
            child: textWidget,
          ),
        );

        final child = find.descendant(
          of: find.byType(PageParametersProxy),
          matching: find.byWidget(textWidget),
        );

        expect(child, findsOneWidget);
      },
    );

    testWidgets(
      "delegates to the page notifier when this widget is created",
      (tester) async {
        whenNavigationNotifierConfiguration(dashboardConfiguration);

        await tester.pumpWidget(
          _PageParametersProxyTestbed(
            pageNotifier: pageNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        verify(pageNotifier.handlePageParameters(any)).called(once);
      },
    );

    testWidgets(
      "delegates to the page notifier if the navigation notifier notifies about changes",
      (tester) async {
        const pageParameters = DashboardPageParametersModel();

       whenNavigationNotifierConfiguration(dashboardConfiguration);

        await tester.pumpWidget(
          _PageParametersProxyTestbed(
            pageNotifier: pageNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        when(navigationNotifier.currentPageParameters)
            .thenReturn(pageParameters);

        navigationNotifier.notifyListeners();
        verify(pageNotifier.handlePageParameters(pageParameters))
            .called(once);
      },
    );

    testWidgets(
      "delegates to the navigation notifier if the page notifier notifies about changes",
      (tester) async {
        whenNavigationNotifierConfiguration(dashboardConfiguration);

        await tester.pumpWidget(
          _PageParametersProxyTestbed(
            pageNotifier: pageNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        pageNotifier.notifyListeners();

        verify(navigationNotifier.handlePageParametersUpdates(any))
            .called(once);
      },
    );

    testWidgets(
      "calls handle page parameters update if can handle returns true",
      (tester) async {
        whenNavigationNotifierConfiguration(dashboardConfiguration);

        await tester.pumpWidget(
          _PageParametersProxyTestbed(
            pageNotifier: pageNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        verify(pageNotifier.handlePageParameters(any)).called(once);
      },
    );

    testWidgets(
      "does not call handle page parameters to update if can handle returns false",
          (tester) async {
        whenNavigationNotifierConfiguration(loginConfiguration);

          await tester.pumpWidget(
            _PageParametersProxyTestbed(
                pageNotifier: pageNotifier,
                navigationNotifier: navigationNotifier,
            ),
          );

          verifyNever(pageNotifier.handlePageParameters(any));
      },
    );

    testWidgets(
      "calls check page parameters on quit update if can handle returns false",
          (tester) async {
        whenNavigationNotifierConfiguration(loginConfiguration);

        await tester.pumpWidget(
          _PageParametersProxyTestbed(
            pageNotifier: pageNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        verify(pageNotifier.handlePageParametersOnQuit(any)).called(once);
      },
    );

    testWidgets(
      "does not call check page parameters on quit update if can handle returns true",
          (tester) async {
        whenNavigationNotifierConfiguration(dashboardConfiguration);

        await tester.pumpWidget(
          _PageParametersProxyTestbed(
            pageNotifier: pageNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        verifyNever(pageNotifier.handlePageParametersOnQuit(any));
      },
    );
  });
}

/// A testbed class required to test the [PageParametersProxy] widget.
class _PageParametersProxyTestbed extends StatelessWidget {
  /// A default child widget used in tests.
  static const Widget _defaultChild = Text('default text');

  /// A child [Widget] to display.
  final Widget child;

  /// A [PageNotifier] used in tests.
  final PageNotifier pageNotifier;

  /// A [NavigationNotifier] used in tests.
  final NavigationNotifier navigationNotifier;

  /// Creates an instance of this testbed with the given parameters.
  ///
  /// The [child] defaults to [_defaultChild].
  const _PageParametersProxyTestbed({
    Key key,
    this.child = _defaultChild,
    this.pageNotifier,
    this.navigationNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      pageNotifier: pageNotifier,
      navigationNotifier: navigationNotifier,
      child: MaterialApp(
        home: Scaffold(
          body: PageParametersProxy(
            pageNotifier: pageNotifier,
            child: child,
          ),
        ),
      ),
    );
  }
}
