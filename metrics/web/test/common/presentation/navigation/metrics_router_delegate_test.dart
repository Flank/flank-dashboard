import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_factory.dart';
import 'package:metrics/common/presentation/navigation/metrics_router_delegate.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import '../../../test_utils/matcher_util.dart';
import '../../../test_utils/route_configuration_stub.dart';

void main() {
  group("MetricsRouterDelegate", () {
    final navigationNotifierMock = _NavigationNotifierMock();
    const configuration = RouteConfigurationStub(name: RouteName.dashboard);
    final metricsRouterDelegate = MetricsRouterDelegate(navigationNotifierMock);

    tearDown(() {
      reset(navigationNotifierMock);
    });

    test(
      "throws an AssertionError if the given navigation notifier is null",
      () {
        expect(
          () => MetricsRouterDelegate(null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given navigation observers are null",
      () {
        expect(
          () => MetricsRouterDelegate(
            navigationNotifierMock,
            navigatorObservers: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "applies an empty list to the navigator observers if the parameter is not specified",
      () {
        final metricsRouterDelegate = MetricsRouterDelegate(
          navigationNotifierMock,
        );

        expect(metricsRouterDelegate.navigatorObservers, equals([]));
      },
    );

    test(
      ".currentConfiguration provides the current route configuration of the navigation notifier",
      () {
        when(navigationNotifierMock.currentConfiguration).thenReturn(
          configuration,
        );

        expect(
          metricsRouterDelegate.currentConfiguration,
          equals(configuration),
        );
      },
    );

    test(
      ".navigatorKey provides the global key for the navigator state",
      () {
        expect(
          metricsRouterDelegate.navigatorKey,
          isA<GlobalKey<NavigatorState>>(),
        );
      },
    );

    test(
      "calls the notifyListeners when the navigation notifier calls notifyListeners",
      () {
        final metricsPageFactory = MetricsPageFactory();
        final navigationNotifier = NavigationNotifier(metricsPageFactory);
        final metricsRouterDelegate = MetricsRouterDelegate(navigationNotifier);

        bool isCalled = false;
        metricsRouterDelegate.addListener(() => isCalled = true);

        navigationNotifier.notifyListeners();

        expect(isCalled, isTrue);
      },
    );

    test(
      ".setInitialRoutePath() delegates call to the handleInitialRoutePath method of the navigation notifier",
      () async {
        await metricsRouterDelegate.setInitialRoutePath(configuration);

        verify(navigationNotifierMock.handleInitialRoutePath(configuration))
            .called(equals(1));
      },
    );

    test(
      ".setNewRoutePath() delegates call to the handleNewRoutePath method of the navigation notifier",
      () async {
        await metricsRouterDelegate.setNewRoutePath(configuration);

        verify(navigationNotifierMock.handleNewRoutePath(configuration))
            .called(equals(1));
      },
    );

    test(
      ".build() returns the navigator widget",
      () {
        const page = MetricsPage(child: Text('test'));
        final pages = UnmodifiableListView([page]);

        when(navigationNotifierMock.pages).thenReturn(pages);

        final actualWidget = metricsRouterDelegate.build(null);

        expect(actualWidget, isA<Navigator>());
      },
    );

    test(
      "applies the given navigator observers to the navigator widget",
      () {
        const page = MetricsPage(child: Text('test'));
        final pages = UnmodifiableListView([page]);

        final expectedNavigatorObservers = [NavigatorObserver()];

        when(navigationNotifierMock.pages).thenReturn(pages);

        final metricsRouterDelegate = MetricsRouterDelegate(
          navigationNotifierMock,
          navigatorObservers: expectedNavigatorObservers,
        );

        final navigator = metricsRouterDelegate.build(null) as Navigator;

        expect(navigator.observers, equals(expectedNavigatorObservers));
      },
    );
  });
}

class _NavigationNotifierMock extends Mock implements NavigationNotifier {}
