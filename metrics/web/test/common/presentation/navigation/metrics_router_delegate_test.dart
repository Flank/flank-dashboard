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
    final pages = UnmodifiableListView<MetricsPage>([]);

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
      ".navigatorKey provides the global object key with a value equals to the navigator notifier",
      () {
        final navigationNotifier = NavigationNotifier(MetricsPageFactory());
        final routerDelegate = MetricsRouterDelegate(navigationNotifier);

        final expectedKey = GlobalObjectKey<NavigatorState>(navigationNotifier);
        final actualKey = routerDelegate.navigatorKey;

        expect(actualKey, equals(expectedKey));
      },
    );

    test(
      "notifies listeners once the given navigation notifier notifies listeners",
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
      ".setInitialRoutePath() delegates call to the navigation notifier",
      () async {
        await metricsRouterDelegate.setInitialRoutePath(configuration);

        verify(navigationNotifierMock.handleInitialRoutePath(configuration))
            .called(equals(1));
      },
    );

    test(
      ".setNewRoutePath() delegates call to the navigation notifier",
      () async {
        await metricsRouterDelegate.setNewRoutePath(configuration);

        verify(navigationNotifierMock.handleNewRoutePath(configuration))
            .called(equals(1));
      },
    );

    test(
      ".build() returns the navigator widget",
      () {
        when(navigationNotifierMock.pages).thenReturn(pages);

        final actualWidget = metricsRouterDelegate.build(null);

        expect(actualWidget, isA<Navigator>());
      },
    );

    test(
      "applies the navigator key to the navigator widget",
      () {
        when(navigationNotifierMock.pages).thenReturn(pages);

        final expectedKey = metricsRouterDelegate.navigatorKey;

        final navigatorWidget = metricsRouterDelegate.build(null) as Navigator;

        final actualKey = navigatorWidget.key;

        expect(actualKey, equals(expectedKey));
      },
    );

    test(
      "applies a list of pages from the navigation notifier to the navigator widget",
      () {
        final expectedPages = UnmodifiableListView(
          const [MetricsPage(child: Text('test'))],
        );
        when(navigationNotifierMock.pages).thenReturn(expectedPages);

        final metricsRouterDelegate = MetricsRouterDelegate(
          navigationNotifierMock,
        );

        final navigatorWidget = metricsRouterDelegate.build(null) as Navigator;

        final actualPages = navigatorWidget.pages;

        expect(actualPages, equals(expectedPages));
      },
    );

    test(
      "applies the given navigator observers to the navigator widget",
      () {
        when(navigationNotifierMock.pages).thenReturn(pages);

        final expectedNavigatorObservers = [NavigatorObserver()];

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
