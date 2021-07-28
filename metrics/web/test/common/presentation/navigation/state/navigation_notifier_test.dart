// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:metrics/common/presentation/navigation/constants/default_routes.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_factory.dart';
import 'package:metrics/common/presentation/navigation/models/factory/page_parameters_factory.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/metrics_page_route_configuration_factory.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_location_converter.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/pages/loading_page.dart';
import 'package:metrics/dashboard/presentation/models/dashboard_page_parameters_model.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';
import '../../../../test_utils/navigation_state_mock.dart';

void main() {
  group("NavigationNotifier", () {
    final routeConfigurationLocationConverter =
        _RouteConfigurationLocationConverterMock();
    const pageParametersModel = DashboardPageParametersModel(
      projectGroupId: 'projectGroupId',
      projectFilter: 'projectFilter',
    );
    final pageFactory = MetricsPageFactory();
    final navigationState = NavigationStateMock();
    final pageParametersFactory = _PageParametersFactoryMock();
    final pageRouteConfigurationFactory =
        _MetricsPageRouteConfigurationFactoryMock();

    final routeConfiguration = RouteConfiguration.dashboard(
      parameters: pageParametersModel.toMap(),
    );

    NavigationNotifier notifier;

    void prepareNotifier() {
      notifier.handleAppInitialized(isAppInitialized: true);

      notifier.handleLoggedIn();
    }

    setUp(() {
      notifier = NavigationNotifier(
        pageFactory,
        pageParametersFactory,
        pageRouteConfigurationFactory,
        routeConfigurationLocationConverter,
        navigationState,
      );
      prepareNotifier();
      reset(pageParametersFactory);
      reset(pageRouteConfigurationFactory);
      reset(routeConfigurationLocationConverter);
    });

    final isLoginPageName = equals(DefaultRoutes.login.path);
    final isDashboardPageName = equals(DefaultRoutes.dashboard.path);
    final isProjectGroupsPageName = equals(DefaultRoutes.projectGroups.path);
    final isLoadingPageName = equals(DefaultRoutes.loading.path);

    test(
      "throws an AssertionError if the given page factory is null",
      () {
        expect(
          () => NavigationNotifier(
            null,
            pageParametersFactory,
            pageRouteConfigurationFactory,
            routeConfigurationLocationConverter,
            navigationState,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given page parameters factory is null",
      () {
        expect(
          () => NavigationNotifier(
            pageFactory,
            null,
            pageRouteConfigurationFactory,
            routeConfigurationLocationConverter,
            navigationState,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given page route configuration factory is null",
      () {
        expect(
          () => NavigationNotifier(
            pageFactory,
            pageParametersFactory,
            null,
            routeConfigurationLocationConverter,
            navigationState,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given route configuration location converter is null",
      () {
        expect(
          () => NavigationNotifier(
            pageFactory,
            pageParametersFactory,
            pageRouteConfigurationFactory,
            null,
            navigationState,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given navigation state is null",
      () {
        expect(
          () => NavigationNotifier(
            pageFactory,
            pageParametersFactory,
            pageRouteConfigurationFactory,
            routeConfigurationLocationConverter,
            null,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        expect(
          () => NavigationNotifier(
            pageFactory,
            pageParametersFactory,
            pageRouteConfigurationFactory,
            routeConfigurationLocationConverter,
            navigationState,
          ),
          returnsNormally,
        );
      },
    );

    test(
      ".pages is an unmodifiable list view",
      () {
        expect(notifier.pages, isA<UnmodifiableListView>());
      },
    );

    test(
      ".handleLoggedOut() clears pages and pushes to the login page when a user logs out",
      () {
        notifier.push(DefaultRoutes.dashboard);

        notifier.handleLoggedOut();

        final pages = notifier.pages;
        final currentPage = pages.last;

        expect(pages, hasLength(1));
        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".handleLoggedOut() does not clear pages and push to the login page when a user logs out from the login page",
      () {
        notifier.push(DefaultRoutes.login);

        notifier.handleLoggedOut();

        final loginPagesCount = notifier.pages
            .where(
              (page) => page.routeName == RouteName.login,
            )
            .length;

        expect(notifier.pages, hasLength(2));
        expect(loginPagesCount, equals(1));
      },
    );

    test(
      ".handleLoggedIn() pushes the dashboard route if the current redirect route is null",
      () {
        notifier.handleLoggedIn();

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isDashboardPageName);
      },
    );

    test(
      ".handleLoggedIn() pushes the redirect route if the current redirect route is not null",
      () {
        const expectedRouteConfiguration = DefaultRoutes.loading;

        notifier.handleAppInitialized(isAppInitialized: false);
        notifier.handleInitialRoutePath(expectedRouteConfiguration);

        notifier.handleLoggedIn();

        final currentPage = notifier.pages.last;

        expect(currentPage.routeName, expectedRouteConfiguration.name);
      },
    );

    test(
      ".handleAppInitialized() throws an argument error if the given is app initialized is null",
      () {
        expect(
          () => notifier.handleAppInitialized(isAppInitialized: null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".handleAppInitialized() redirects to the dashboard page when the app is initialized and the redirect route is loading page",
      () {
        notifier.handleAppInitialized(isAppInitialized: false);
        notifier.handleLoggedIn();

        notifier.handleInitialRoutePath(DefaultRoutes.loading);

        notifier.handleAppInitialized(isAppInitialized: true);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isDashboardPageName);
      },
    );

    test(
      ".handleAppInitialized() redirects to the dashboard page when the app is initialized and the redirect route is null",
      () {
        notifier.handleLoggedIn();

        notifier.handleAppInitialized(isAppInitialized: true);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isDashboardPageName);
      },
    );

    test(
      ".handleAppInitialized() redirects to the redirect route when the app is initialized",
      () {
        notifier.handleAppInitialized(isAppInitialized: false);
        notifier.handleLoggedIn();

        notifier.handleInitialRoutePath(DefaultRoutes.projectGroups);

        notifier.handleAppInitialized(isAppInitialized: true);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isProjectGroupsPageName);
      },
    );

    test(
      ".handleAppInitialized() clears the redirect route after redirect",
      () {
        notifier.handleAppInitialized(isAppInitialized: false);
        notifier.handleLoggedIn();

        notifier.handleInitialRoutePath(DefaultRoutes.projectGroups);

        notifier.handleAppInitialized(isAppInitialized: true);
        notifier.handleAppInitialized(isAppInitialized: true);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isDashboardPageName);
      },
    );

    test(
      ".handleAppInitialized() clears pages before redirect",
      () {
        notifier.handleAppInitialized(isAppInitialized: false);
        notifier.handleLoggedIn();

        notifier.handleInitialRoutePath(DefaultRoutes.loading);
        notifier.push(DefaultRoutes.dashboard);

        notifier.handleAppInitialized(isAppInitialized: true);

        final pages = notifier.pages;

        expect(pages, hasLength(equals(1)));
      },
    );

    test(
      ".handlePageParametersUpdates() does not change the current page parameters if the given page parameters model is null",
      () {
        when(pageParametersFactory.create(any)).thenReturn(pageParametersModel);

        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        final initialPageParameters = notifier.currentPageParameters;

        notifier.handlePageParametersUpdates(null);

        expect(notifier.currentPageParameters, equals(initialPageParameters));
      },
    );

    test(
      ".handlePageParametersUpdates() does not change the current route configuration if the given page parameters model is null",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        final currentConfiguration = notifier.currentConfiguration;

        notifier.handlePageParametersUpdates(null);

        expect(notifier.currentConfiguration, equals(currentConfiguration));
      },
    );

    test(
      ".handlePageParametersUpdates() does not update the last page if the given page parameters model is null",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        final lastPage = notifier.pages.last;
        final initialPagesLength = notifier.pages.length;

        notifier.handlePageParametersUpdates(null);

        expect(notifier.pages.last, equals(lastPage));
        expect(notifier.pages.length, equals(initialPagesLength));
      },
    );

    test(
      ".handlePageParametersUpdates() does not convert the given parameters to the location if the given page parameters model is null",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        notifier.handlePageParametersUpdates(null);

        verifyNever(routeConfigurationLocationConverter.convert(any));
      },
    );

    test(
      ".handlePageParametersUpdates() does not update the browser URL if the given page parameters model is null",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.projectGroups);

        notifier.handlePageParametersUpdates(null);

        verifyNever(
          navigationState.replaceState(
            any,
            any,
            DefaultRoutes.projectGroups.path,
          ),
        );
      },
    );

    test(
      ".handlePageParametersUpdates() does not change the current route configuration if the given page parameters model is equal to the current page parameters",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        final currentPageParameters = notifier.currentPageParameters;
        final currentConfiguration = notifier.currentConfiguration;

        notifier.handlePageParametersUpdates(currentPageParameters);

        expect(notifier.currentConfiguration, equals(currentConfiguration));
      },
    );

    test(
      ".handlePageParametersUpdates() does not update the last page if the given page parameters model is equal to the current page parameters",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        final currentPageParameters = notifier.currentPageParameters;
        final lastPage = notifier.pages.last;
        final initialPagesLength = notifier.pages.length;

        notifier.handlePageParametersUpdates(currentPageParameters);

        expect(notifier.pages.last, equals(lastPage));
        expect(notifier.pages.length, equals(initialPagesLength));
      },
    );

    test(
      ".handlePageParametersUpdates() does not convert the given parameters to the location if the given page parameters model is equal to the current page parameters",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        final currentPageParameters = notifier.currentPageParameters;

        notifier.handlePageParametersUpdates(currentPageParameters);

        verifyNever(routeConfigurationLocationConverter.convert(any));
      },
    );

    test(
      ".handlePageParametersUpdates() does not update the browser URL if the given page parameters model is equal to the current page parameters",
      () {
        notifier.handleLoggedIn();

        notifier.push(DefaultRoutes.projectGroups);

        final currentPageParameters = notifier.currentPageParameters;

        notifier.handlePageParametersUpdates(currentPageParameters);

        verifyNever(navigationState.replaceState(
            any, any, DefaultRoutes.projectGroups.path));
      },
    );

    test(
      ".handlePageParametersUpdates() updates a current page parameters model with the given one",
      () {
        notifier.handlePageParametersUpdates(pageParametersModel);

        expect(notifier.currentPageParameters, equals(pageParametersModel));
      },
    );

    test(
      ".handlePageParametersUpdates() updates a current configuration with the given page parameters",
      () {
        final expectedConfiguration = notifier.currentConfiguration.copyWith(
          parameters: pageParametersModel.toMap(),
        );

        notifier.handlePageParametersUpdates(pageParametersModel);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".handlePageParametersUpdates() updates the current page arguments to the given page parameters",
      () {
        final initialPagesLength = notifier.pages.length;

        notifier.handlePageParametersUpdates(pageParametersModel);

        final currentPage = notifier.pages.last;
        final actualPagesLength = notifier.pages.length;

        expect(currentPage.arguments, equals(pageParametersModel));
        expect(actualPagesLength, equals(initialPagesLength));
      },
    );

    test(
      ".handlePageParametersUpdates() uses the given route configuration location converter to create an updated path",
      () {
        notifier.handlePageParametersUpdates(pageParametersModel);

        final currentConfiguration = notifier.currentConfiguration;

        verify(
          routeConfigurationLocationConverter.convert(currentConfiguration),
        ).called(once);
      },
    );

    test(
      ".handlePageParametersUpdates() replaces the current navigation state using the given page parameters",
      () {
        const path = 'test';
        when(routeConfigurationLocationConverter.convert(any)).thenReturn(path);

        notifier.handlePageParametersUpdates(pageParametersModel);

        verify(navigationState.replaceState(any, any, path)).called(once);
      },
    );

    test(
      ".pop() does nothing if pages are empty",
      () {
        final expectedPages = notifier.pages;

        notifier.pop();

        final actualPages = notifier.pages;

        expect(actualPages, equals(expectedPages));
      },
    );

    test(
      ".pop() does nothing if pages contain one page",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        final expectedPages = notifier.pages;

        notifier.pop();

        final actualPages = notifier.pages;

        expect(actualPages, equals(expectedPages));
      },
    );

    test(
      ".pop() removes the current page",
      () {
        notifier.handleLoggedIn();

        notifier.push(DefaultRoutes.dashboard);
        notifier.push(DefaultRoutes.projectGroups);

        notifier.pop();

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isDashboardPageName);
      },
    );

    test(
      ".pop() sets the previous rote configuration to current configuration",
      () {
        final expectedConfiguration = DefaultRoutes.dashboard;

        final pageMatcher = predicate<MetricsPage>(
          (page) => page.routeName == RouteName.dashboard,
        );

        when(pageRouteConfigurationFactory.create(captureThat(pageMatcher)))
            .thenReturn(expectedConfiguration);

        notifier.handleAppInitialized(isAppInitialized: true);
        notifier.handleLoggedIn();

        notifier.push(expectedConfiguration);
        notifier.push(DefaultRoutes.projectGroups);

        notifier.pop();

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".pop() updates the current page parameters",
      () {
        notifier.push(DefaultRoutes.projectGroups);

        final initialPageParameters = notifier.currentPageParameters;

        when(pageParametersFactory.create(any)).thenReturn(pageParametersModel);

        notifier.pop();

        expect(
          notifier.currentPageParameters,
          isNot(equals(initialPageParameters)),
        );
      },
    );

    test(
      ".pop() uses the given page parameters factory to create a page parameters",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.projectGroups);
        notifier.pop();

        final currentConfiguration = notifier.currentConfiguration;

        verify(pageParametersFactory.create(currentConfiguration)).called(once);
      },
    );

    test(
      ".pop() uses the given page route configuration factory to create a route configuration",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.projectGroups);

        notifier.pop();

        final currentPage = notifier.pages.last;

        verify(pageRouteConfigurationFactory.create(currentPage)).called(once);
      },
    );

    test(
      ".canPop() returns true if there are more than one page in the pages list",
      () {
        notifier.push(DefaultRoutes.projectGroups);

        final actualValue = notifier.canPop();

        expect(actualValue, isTrue);
      },
    );

    test(
      ".canPop() returns false if there is one page in the pages list",
      () {
        final actualValue = notifier.canPop();

        expect(actualValue, isFalse);
      },
    );

    test(
      ".canPop() returns false if the pages list is empty",
      () {
        final notifier = NavigationNotifier(
          pageFactory,
          pageParametersFactory,
          pageRouteConfigurationFactory,
          routeConfigurationLocationConverter,
          navigationState,
        );

        notifier.handleLoggedIn();

        final actualValue = notifier.canPop();

        expect(actualValue, isFalse);
      },
    );

    test(
      ".push() pushes the loading page if the app is not initialized",
      () {
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.push(DefaultRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.child, isA<LoadingPage>());
      },
    );

    test(
      ".push() pushes the loading page with the given route path as a name if the app is not initialized",
      () {
        final configuration = DefaultRoutes.dashboard;

        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.push(configuration);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, equals(configuration.path));
      },
    );

    test(
      ".push() pushes the given page if the user is logged in and the app is initialized",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isDashboardPageName);
      },
    );

    test(
      ".push() pushes the login page if the user is not logged in, the given page requires authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".push() pushes the given page if the user is not logged in, the given page does not require authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.loading);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoadingPageName);
      },
    );

    test(
      ".push() updates the current configuration",
      () {
        final expectedConfiguration = DefaultRoutes.dashboard;
        notifier.handleLoggedIn();

        notifier.push(expectedConfiguration);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".push() updates the current page parameters",
      () {
        final initialPageParameters = notifier.currentPageParameters;

        when(pageParametersFactory.create(any)).thenReturn(pageParametersModel);

        notifier.push(routeConfiguration);

        expect(
          notifier.currentPageParameters,
          isNot(equals(initialPageParameters)),
        );
      },
    );

    test(
      ".push() uses the given page parameters factory to create a page parameters",
      () {
        notifier.push(routeConfiguration);

        verify(pageParametersFactory.create(any)).called(once);
      },
    );

    test(
      ".push() uses the given metrics page factory to create a metrics page",
      () {
        final pageFactory = _MetricsPageFactoryMock();
        final notifier = NavigationNotifier(
          pageFactory,
          pageParametersFactory,
          pageRouteConfigurationFactory,
          routeConfigurationLocationConverter,
          navigationState,
        );
        notifier.handleAppInitialized(isAppInitialized: true);
        notifier.handleLoggedIn();

        notifier.push(routeConfiguration);

        verify(pageFactory.create(routeConfiguration, null)).called(once);
      },
    );

    test(
      ".pushReplacement() pushes the loading page if the app is not initialized",
      () {
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.pushReplacement(DefaultRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.child, isA<LoadingPage>());
      },
    );

    test(
      ".pushReplacement() pushes the loading page with the given route path as a name if the app is not initialized",
      () {
        final configuration = DefaultRoutes.dashboard;
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.pushReplacement(configuration);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, equals(configuration.path));
      },
    );

    test(
      ".pushReplacement() replaces the current page if pages are not empty",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        final expectedLength = notifier.pages.length;

        notifier.pushReplacement(DefaultRoutes.projectGroups);

        final actualLength = notifier.pages.length;

        expect(actualLength, equals(expectedLength));
      },
    );

    test(
      ".pushReplacement() adds the new page if pages are empty",
      () {
        final notifier = NavigationNotifier(
          pageFactory,
          pageParametersFactory,
          pageRouteConfigurationFactory,
          routeConfigurationLocationConverter,
          navigationState,
        );
        notifier.handleLoggedIn();

        final expectedLength = notifier.pages.length;

        notifier.pushReplacement(DefaultRoutes.projectGroups);

        final actualLength = notifier.pages.length;

        expect(actualLength, equals(expectedLength));
      },
    );

    test(
      ".pushReplacement() replaces the current page with the given one if the user is logged in and the app is initialized",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        notifier.pushReplacement(DefaultRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isProjectGroupsPageName);
      },
    );

    test(
      ".pushReplacement() replaces the current page with the login page if the user is not logged in, the given page requires authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.loading);

        notifier.pushReplacement(DefaultRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".pushReplacement() replaces the current page with the given page if the user is not logged in, the given page does not require authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.loading);

        notifier.pushReplacement(DefaultRoutes.login);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".pushReplacement() updates the current configuration",
      () {
        const expectedConfiguration = DefaultRoutes.loading;
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.login);

        notifier.pushReplacement(expectedConfiguration);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".pushStateReplacement() pushes the loading page if the app is not initialized",
      () {
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.pushStateReplacement(DefaultRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.child, isA<LoadingPage>());
      },
    );

    test(
      ".pushStateReplacement() pushes the loading page with the given route path as a name if the app is not initialized",
      () {
        final configuration = DefaultRoutes.dashboard;
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.pushStateReplacement(configuration);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, equals(configuration.path));
      },
    );

    test(
      ".pushStateReplacement() replaces the current page if pages are not empty",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        final expectedLength = notifier.pages.length;

        notifier.pushStateReplacement(DefaultRoutes.projectGroups);

        final actualLength = notifier.pages.length;

        expect(actualLength, equals(expectedLength));
      },
    );

    test(
      ".pushStateReplacement() adds the new page if pages are empty",
      () {
        final notifier = NavigationNotifier(
          pageFactory,
          pageParametersFactory,
          pageRouteConfigurationFactory,
          routeConfigurationLocationConverter,
          navigationState,
        );
        notifier.handleLoggedIn();

        final expectedLength = notifier.pages.length;

        notifier.pushStateReplacement(DefaultRoutes.projectGroups);

        final actualLength = notifier.pages.length;

        expect(actualLength, equals(expectedLength));
      },
    );

    test(
      ".pushStateReplacement() replaces the current page with the given one if the user is logged in and the app is initialized",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.dashboard);

        notifier.pushStateReplacement(DefaultRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isProjectGroupsPageName);
      },
    );

    test(
      ".pushStateReplacement() replaces the current page with the login page if the user is not logged in, the given page requires authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.loading);

        notifier.pushStateReplacement(DefaultRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".pushStateReplacement() replaces the current page with the given page if the user is not logged in, the given page does not require authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.loading);

        notifier.pushStateReplacement(DefaultRoutes.login);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".pushStateReplacement() updates the current configuration",
      () {
        const expectedConfiguration = DefaultRoutes.loading;
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.login);

        notifier.pushStateReplacement(expectedConfiguration);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".pushStateReplacement() replaces the navigation state path with the pushed route configuration path",
      () {
        const expectedConfiguration = DefaultRoutes.loading;
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.login);

        notifier.pushStateReplacement(expectedConfiguration);

        verify(navigationState.replaceState(
          any,
          any,
          notifier.currentConfiguration.path,
        ));
      },
    );

    test(
      ".pushAndRemoveUntil() pushes the loading page if the app is not initialized",
      () {
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.pushAndRemoveUntil(
          DefaultRoutes.dashboard,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.child, isA<LoadingPage>());
      },
    );

    test(
      ".pushAndRemoveUntil() pushes the loading page with the given route path as a name if the app is not initialized",
      () {
        final configuration = DefaultRoutes.dashboard;
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.pushAndRemoveUntil(
          configuration,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.name, equals(configuration.path));
      },
    );

    test(
      ".pushAndRemoveUntil() removes all underlying routes that don't satisfy the given predicate",
      () {
        notifier.handleLoggedIn();

        notifier.push(DefaultRoutes.projectGroups);
        notifier.push(DefaultRoutes.login);
        notifier.push(DefaultRoutes.debugMenu);

        notifier.pushAndRemoveUntil(
          DefaultRoutes.dashboard,
          (page) => page.name == DefaultRoutes.dashboard.path,
        );

        final pages = notifier.pages;

        final containsNotDashboard = pages.any(
          (page) => page.name != DefaultRoutes.dashboard.path,
        );

        expect(containsNotDashboard, isFalse);
      },
    );

    test(
      ".pushAndRemoveUntil() does not remove the underlying routes after the predicate meets satisfying route",
      () {
        notifier.handleLoggedIn();

        notifier.push(DefaultRoutes.projectGroups);
        notifier.push(DefaultRoutes.dashboard);
        notifier.push(DefaultRoutes.login);
        notifier.push(DefaultRoutes.debugMenu);

        notifier.pushAndRemoveUntil(
          DefaultRoutes.dashboard,
          (page) => page.name.contains(RouteName.dashboard.value),
        );

        final pages = notifier.pages;

        final containsProjectGroups = pages.any(
          (page) => page.name == DefaultRoutes.projectGroups.path,
        );

        expect(containsProjectGroups, isTrue);
      },
    );

    test(
      ".pushAndRemoveUntil() does not remove the route that satisfies predicate",
      () {
        notifier.handleLoggedIn();

        notifier.push(DefaultRoutes.projectGroups);
        notifier.push(DefaultRoutes.dashboard);
        notifier.push(DefaultRoutes.login);
        notifier.push(DefaultRoutes.debugMenu);

        notifier.pushAndRemoveUntil(
          DefaultRoutes.dashboard,
          (page) => page.name.contains(RouteName.dashboard.value),
        );

        final pages = notifier.pages;

        final containsDashboardPage = pages.any(
          (page) => page.name == DefaultRoutes.dashboard.path,
        );

        expect(containsDashboardPage, isTrue);
      },
    );

    test(
      ".pushAndRemoveUntil() pushes the given page if the user is logged in and the app is initialized",
      () {
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.projectGroups);

        notifier.pushAndRemoveUntil(
          DefaultRoutes.dashboard,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isDashboardPageName);
      },
    );

    test(
      ".pushAndRemoveUntil() pushes the login page if the user is not logged in, the given page requires authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.loading);

        notifier.pushAndRemoveUntil(
          DefaultRoutes.dashboard,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".pushAndRemoveUntil() pushes the given page if the user is not logged in, the given page does not require authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();
        notifier.push(DefaultRoutes.loading);

        notifier.pushAndRemoveUntil(
          DefaultRoutes.login,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".pushAndRemoveUntil() updates the current configuration",
      () {
        final expectedConfiguration = DefaultRoutes.dashboard;
        notifier.handleLoggedIn();
        notifier.push(DefaultRoutes.projectGroups);

        notifier.pushAndRemoveUntil(
          expectedConfiguration,
          (page) => true,
        );

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".handleInitialRoutePath() pushes the loading page if the app is not initialized",
      () {
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.handleInitialRoutePath(DefaultRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.child, isA<LoadingPage>());
      },
    );

    test(
      ".handleInitialRoutePath() pushes the loading page with the given route path as a name if the app is not initialized",
      () {
        final configuration = DefaultRoutes.dashboard;
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.handleInitialRoutePath(configuration);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, equals(configuration.path));
      },
    );

    test(
      ".handleInitialRoutePath() pushes the given page if the user is logged in and the app is initialized",
      () {
        notifier.handleLoggedIn();

        notifier.handleInitialRoutePath(DefaultRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isProjectGroupsPageName);
      },
    );

    test(
      ".handleInitialRoutePath() pushes the login page if the user is not logged in, the given page requires authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();

        notifier.handleInitialRoutePath(DefaultRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".handleInitialRoutePath() pushes the given page if the user is not logged in, the given page does not require authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();

        notifier.handleInitialRoutePath(DefaultRoutes.login);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".handleInitialRoutePath() updates the current configuration",
      () {
        final expectedConfiguration = DefaultRoutes.projectGroups;

        notifier.handleLoggedIn();

        notifier.handleInitialRoutePath(expectedConfiguration);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".handleInitialRoutePath() updates the current page parameters",
      () {
        final initialPageParameters = notifier.currentPageParameters;

        when(pageParametersFactory.create(any)).thenReturn(pageParametersModel);

        notifier.handleInitialRoutePath(routeConfiguration);

        expect(
          notifier.currentPageParameters,
          isNot(equals(initialPageParameters)),
        );
      },
    );

    test(
      ".handleInitialRoutePath() uses the given page parameters factory to create a page parameters",
      () {
        notifier.handleInitialRoutePath(routeConfiguration);

        verify(pageParametersFactory.create(any)).called(once);
      },
    );

    test(
      ".handleInitialRoutePath() uses the given metrics page factory to create a metrics page",
      () {
        final pageFactory = _MetricsPageFactoryMock();
        final notifier = NavigationNotifier(
          pageFactory,
          pageParametersFactory,
          pageRouteConfigurationFactory,
          routeConfigurationLocationConverter,
          navigationState,
        );
        notifier.handleAppInitialized(isAppInitialized: true);
        notifier.handleLoggedIn();

        notifier.handleInitialRoutePath(routeConfiguration);

        verify(pageFactory.create(routeConfiguration, null)).called(once);
      },
    );

    test(
      ".handleNewRoutePath() pushes the loading page if the app is not initialized",
      () {
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.handleNewRoutePath(DefaultRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.child, isA<LoadingPage>());
      },
    );

    test(
      ".handleNewRoutePath() pushes the loading page with the given route path as a name if the app is not initialized",
      () {
        final configuration = DefaultRoutes.dashboard;
        notifier.handleAppInitialized(isAppInitialized: false);

        notifier.handleNewRoutePath(configuration);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, equals(configuration.path));
      },
    );

    test(
      ".handleNewRoutePath() pushes the given page if the user is logged in and the app is initialized",
      () {
        notifier.handleLoggedIn();

        notifier.handleNewRoutePath(DefaultRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isProjectGroupsPageName);
      },
    );

    test(
      ".handleNewRoutePath() pushes the login page if the user is not logged in, the given page requires authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();

        notifier.handleNewRoutePath(DefaultRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".handleNewRoutePath() pushes the given page if the user is not logged in, the given page does not require authorization, and the app is initialized",
      () {
        notifier.handleLoggedOut();

        notifier.handleNewRoutePath(DefaultRoutes.login);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".handleNewRoutePath() updates the current configuration",
      () {
        final expectedConfiguration = DefaultRoutes.projectGroups;

        notifier.handleLoggedIn();

        notifier.handleNewRoutePath(expectedConfiguration);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".replaceState() delegates to the navigation state",
      () {
        const data = 'data';
        const title = 'title';
        const path = '/test';

        notifier.replaceState(data: data, title: title, path: path);

        verify(
          navigationState.replaceState(data, title, path),
        ).called(once);
      },
    );
  });
}

class _PageParametersFactoryMock extends Mock implements PageParametersFactory {
}

class _MetricsPageFactoryMock extends Mock implements MetricsPageFactory {}

class _MetricsPageRouteConfigurationFactoryMock extends Mock
    implements MetricsPageRouteConfigurationFactory {}

class _RouteConfigurationLocationConverterMock extends Mock
    implements RouteConfigurationLocationConverter {}
