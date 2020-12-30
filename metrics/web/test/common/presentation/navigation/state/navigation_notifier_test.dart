import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_factory.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';

void main() {
  group("NavigationNotifier", () {
    final pageFactory = MetricsPageFactory();

    NavigationNotifier notifier;

    setUp(() {
      notifier = NavigationNotifier(pageFactory);
    });

    Matcher pageMatcher(RouteName name) => contains(name.value);

    final isLoginPageName = pageMatcher(RouteName.login);
    final isDashboardPageName = pageMatcher(RouteName.dashboard);
    final isProjectGroupsName = pageMatcher(RouteName.projectGroups);
    final isLoadingPageName = isNull;

    test(
      "throws an AssertionError if the given page factory is null",
      () {
        expect(
          () => NavigationNotifier(null),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        expect(
          () => NavigationNotifier(pageFactory),
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
      ".handleAuthenticationUpdates clears pages when the user logs out",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);
        notifier.push(MetricsRoutes.dashboard);

        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        final pages = notifier.pages;

        expect(pages, isEmpty);
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
        notifier.handleAuthenticationUpdates(isLoggedIn: true);
        notifier.push(MetricsRoutes.dashboard);

        final expectedPages = notifier.pages;

        notifier.pop();

        final actualPages = notifier.pages;

        expect(actualPages, equals(expectedPages));
      },
    );

    test(
      ".pop() removes the current page",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.push(MetricsRoutes.dashboard);
        notifier.push(MetricsRoutes.projectGroups);

        notifier.pop();

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isDashboardPageName);
      },
    );

    test(
      ".pop() sets the previous rote configuration to current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.dashboard;
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.push(expectedConfiguration);
        notifier.push(MetricsRoutes.projectGroups);

        notifier.pop();

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".push() pushes the given page if the user is logged in",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);
        notifier.push(MetricsRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isDashboardPageName);
      },
    );

    test(
      ".push() pushes the login page if the user is not logged in and the given page requires authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);
        notifier.push(MetricsRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".push() pushes the given page if the user is not logged in and the given page does not require authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);
        notifier.push(MetricsRoutes.loading);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoadingPageName);
      },
    );

    test(
      ".push() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.dashboard;
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.push(expectedConfiguration);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".pushReplacement() replaces the current page if pages are not empty",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);
        notifier.push(MetricsRoutes.dashboard);

        final expectedLength = notifier.pages.length;

        notifier.pushReplacement(MetricsRoutes.projectGroups);

        final actualLength = notifier.pages.length;

        expect(actualLength, equals(expectedLength));
      },
    );

    test(
      ".pushReplacement() adds the new page if pages are empty",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        final expectedLength = notifier.pages.length + 1;

        notifier.pushReplacement(MetricsRoutes.projectGroups);

        final actualLength = notifier.pages.length;

        expect(actualLength, equals(expectedLength));
      },
    );

    test(
      ".pushReplacement() replaces the current page with the given one if the user is logged in",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);
        notifier.push(MetricsRoutes.dashboard);

        notifier.pushReplacement(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isProjectGroupsName);
      },
    );

    test(
      ".pushReplacement() replaces the current page with the login page if the user is not logged in and the given page requires authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);
        notifier.push(MetricsRoutes.loading);

        notifier.pushReplacement(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".pushReplacement() replaces the current page with the given page if the user is not logged in and the given page does not require authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);
        notifier.push(MetricsRoutes.login);

        notifier.pushReplacement(MetricsRoutes.loading);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoadingPageName);
      },
    );

    test(
      ".pushReplacement() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.loading;
        notifier.handleAuthenticationUpdates(isLoggedIn: false);
        notifier.push(MetricsRoutes.login);

        notifier.pushReplacement(expectedConfiguration);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".pushAndRemoveUntil() removes all underlying routes that don't satisfy the given predicate",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.push(MetricsRoutes.projectGroups);
        notifier.push(MetricsRoutes.login);
        notifier.push(MetricsRoutes.debugMenu);

        notifier.pushAndRemoveUntil(
          MetricsRoutes.dashboard,
          (page) => page.name == MetricsRoutes.dashboard.path,
        );

        final pages = notifier.pages;

        final containsNotDashboard = pages.any(
          (page) => page.name != MetricsRoutes.dashboard.path,
        );

        expect(containsNotDashboard, isFalse);
      },
    );

    test(
      ".pushAndRemoveUntil() does not remove the underlying routes after the predicate meets satisfying route",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.push(MetricsRoutes.projectGroups);
        notifier.push(MetricsRoutes.dashboard);
        notifier.push(MetricsRoutes.login);
        notifier.push(MetricsRoutes.debugMenu);

        notifier.pushAndRemoveUntil(
          MetricsRoutes.dashboard,
          (page) => page.name.contains(RouteName.dashboard.value),
        );

        final pages = notifier.pages;

        final containsProjectGroups = pages.any(
          (page) => page.name == MetricsRoutes.projectGroups.path,
        );

        expect(containsProjectGroups, isTrue);
      },
    );

    test(
      ".pushAndRemoveUntil() does not remove the route that satisfies predicate",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.push(MetricsRoutes.projectGroups);
        notifier.push(MetricsRoutes.dashboard);
        notifier.push(MetricsRoutes.login);
        notifier.push(MetricsRoutes.debugMenu);

        notifier.pushAndRemoveUntil(
          MetricsRoutes.dashboard,
          (page) => page.name.contains(RouteName.dashboard.value),
        );

        final pages = notifier.pages;

        final containsDashboardPage = pages.any(
          (page) => page.name == MetricsRoutes.dashboard.path,
        );

        expect(containsDashboardPage, isTrue);
      },
    );

    test(
      ".pushAndRemoveUntil() pushes the given page if the user is logged in",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);
        notifier.push(MetricsRoutes.projectGroups);

        notifier.pushAndRemoveUntil(
          MetricsRoutes.dashboard,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isDashboardPageName);
      },
    );

    test(
      ".pushAndRemoveUntil() pushes the login page if the user is not logged in and the given page requires authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);
        notifier.push(MetricsRoutes.loading);

        notifier.pushAndRemoveUntil(
          MetricsRoutes.dashboard,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".pushAndRemoveUntil() pushes the given page if the user is not logged in and the given page does not require authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);
        notifier.push(MetricsRoutes.login);

        notifier.pushAndRemoveUntil(
          MetricsRoutes.loading,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoadingPageName);
      },
    );

    test(
      ".pushAndRemoveUntil() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.dashboard;
        notifier.handleAuthenticationUpdates(isLoggedIn: true);
        notifier.push(MetricsRoutes.projectGroups);

        notifier.pushAndRemoveUntil(
          expectedConfiguration,
          (page) => true,
        );

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".handleInitialRoutePath() pushes the given page if the user is logged in",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.handleInitialRoutePath(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isProjectGroupsName);
      },
    );

    test(
      ".handleInitialRoutePath() pushes the login page if the user is not logged in and the given page requires authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.handleInitialRoutePath(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".handleInitialRoutePath() pushes the given page if the user is not logged in and the given page does not require authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.handleInitialRoutePath(MetricsRoutes.loading);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoadingPageName);
      },
    );

    test(
      ".handleInitialRoutePath() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.projectGroups;

        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.handleInitialRoutePath(expectedConfiguration);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".handleNewRoutePath() pushes the given page if the user is logged in",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.handleNewRoutePath(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isProjectGroupsName);
      },
    );

    test(
      ".handleNewRoutePath() pushes the login page if the user is not logged in and the given page requires authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.handleNewRoutePath(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoginPageName);
      },
    );

    test(
      ".handleNewRoutePath() pushes the given page if the user is not logged in and the given page does not require authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.handleNewRoutePath(MetricsRoutes.loading);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, isLoadingPageName);
      },
    );

    test(
      ".handleNewRoutePath() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.projectGroups;

        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.handleNewRoutePath(expectedConfiguration);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );
  });
}
