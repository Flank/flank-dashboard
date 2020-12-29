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

    Matcher pageMatcher(RouteName name) => contains(name?.value);

    final loginPageMatcher = pageMatcher(RouteName.login);
    final dashboardPageMatcher = pageMatcher(RouteName.dashboard);
    final projectGroupsPageMatcher = pageMatcher(RouteName.projectGroups);
    final loadingPageMatcher = isNull;

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
      ".handleAuthenticationUpdates throws an ArgumentError if the given is logged in is null",
      () {
        expect(
          () => notifier.handleAuthenticationUpdates(isLoggedIn: null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".handleAuthenticationUpdates clears pages when the user logs out",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.dashboard);

        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        final pages = notifier.pages;

        expect(pages, isEmpty);
      },
    );

    test(
      ".pop() does nothing if pages are empty",
      () {
        final initialPages = notifier.pages;

        notifier.pop();

        final actualPages = notifier.pages;

        expect(initialPages, equals(actualPages));
      },
    );

    test(
      ".pop() does nothing if pages contain one page",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.dashboard);

        final initialPages = notifier.pages;

        notifier.pop();

        final actualPages = notifier.pages;

        expect(initialPages, equals(actualPages));
      },
    );

    test(
      ".pop() pops the last page",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.dashboard);
        notifier.pushNamed(MetricsRoutes.projectGroups);

        notifier.pop();

        final currentPage = notifier.pages.last;

        expect(currentPage.name, dashboardPageMatcher);
      },
    );

    test(
      ".pop() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.dashboard;

        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.dashboard);
        notifier.pushNamed(MetricsRoutes.projectGroups);

        notifier.pop();

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".pushNamed() pushes the given page if the user is logged in",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, dashboardPageMatcher);
      },
    );

    test(
      ".pushNamed() pushes the login page if the user is not logged in and the given page requires authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.pushNamed(MetricsRoutes.dashboard);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, loginPageMatcher);
      },
    );

    test(
      ".pushNamed() pushes the login page if the user is not logged in and the given page does not require authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.pushNamed(MetricsRoutes.loading);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, loadingPageMatcher);
      },
    );

    test(
      ".pushNamed() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.dashboard;

        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.dashboard);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".pushReplacementNamed() replaces the current page if pages are not empty",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.dashboard);

        final initialLength = notifier.pages.length;

        notifier.pushReplacementNamed(MetricsRoutes.projectGroups);

        final actualLength = notifier.pages.length;

        expect(actualLength, equals(initialLength));
      },
    );

    test(
      ".pushReplacementNamed() adds the new page if pages are empty",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        final initialLength = notifier.pages.length;

        notifier.pushReplacementNamed(MetricsRoutes.projectGroups);

        final actualLength = notifier.pages.length;

        expect(actualLength, equals(initialLength + 1));
      },
    );

    test(
      ".pushReplacementNamed() replaces the current page with the given one if the user is logged in",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.dashboard);

        notifier.pushReplacementNamed(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, projectGroupsPageMatcher);
      },
    );

    test(
      ".pushReplacementNamed() replaces the current page with the login page if the user is not logged in the given page requires authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.pushNamed(MetricsRoutes.loading);

        notifier.pushReplacementNamed(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, loginPageMatcher);
      },
    );

    test(
      ".pushReplacementNamed() replaces the current page with the given page if the user is not logged in the given page does not require authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.pushNamed(MetricsRoutes.login);

        notifier.pushReplacementNamed(MetricsRoutes.loading);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, loadingPageMatcher);
      },
    );

    test(
      ".pushReplacementNamed() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.loading;

        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.pushNamed(MetricsRoutes.login);

        notifier.pushReplacementNamed(MetricsRoutes.loading);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".pushNamedAndRemoveUntil() removes all underlying routes that don't satisfy the given predicate",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.projectGroups);
        notifier.pushNamed(MetricsRoutes.login);
        notifier.pushNamed(MetricsRoutes.debugMenu);

        notifier.pushNamedAndRemoveUntil(
          MetricsRoutes.dashboard,
          (page) => page.name.contains(RouteName.dashboard.value),
        );

        final pages = notifier.pages;

        final containsNotDashboard = pages.any(
          (page) => !page.name.contains(RouteName.dashboard.value),
        );

        expect(containsNotDashboard, isFalse);
      },
    );

    test(
      ".pushNamedAndRemoveUntil() does not remove the underlying routes after the predicate meets satisfying route",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.projectGroups);
        notifier.pushNamed(MetricsRoutes.dashboard);
        notifier.pushNamed(MetricsRoutes.login);
        notifier.pushNamed(MetricsRoutes.debugMenu);

        notifier.pushNamedAndRemoveUntil(
          MetricsRoutes.dashboard,
          (page) => page.name.contains(RouteName.dashboard.value),
        );

        final pages = notifier.pages;
        final containsProjectGroups = pages.any(
          (page) => page.name.contains(RouteName.projectGroups.value),
        );

        expect(containsProjectGroups, isTrue);
      },
    );

    test(
      ".pushNamedAndRemoveUntil() pushes the given page if the user is logged in",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.projectGroups);

        notifier.pushNamedAndRemoveUntil(
          MetricsRoutes.dashboard,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.name, dashboardPageMatcher);
      },
    );

    test(
      ".pushNamedAndRemoveUntil() pushes the login page if the user is not logged in and the given page requires authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.pushNamed(MetricsRoutes.loading);

        notifier.pushNamedAndRemoveUntil(
          MetricsRoutes.dashboard,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.name, loginPageMatcher);
      },
    );

    test(
      ".pushNamedAndRemoveUntil() pushes the login page if the user is not logged in and the given page does not require authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.pushNamed(MetricsRoutes.login);

        notifier.pushNamedAndRemoveUntil(
          MetricsRoutes.loading,
          (page) => true,
        );

        final currentPage = notifier.pages.last;

        expect(currentPage.name, loadingPageMatcher);
      },
    );

    test(
      ".pushNamedAndRemoveUntil() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.dashboard;

        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.pushNamed(MetricsRoutes.projectGroups);

        notifier.pushNamedAndRemoveUntil(
          MetricsRoutes.dashboard,
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

        expect(currentPage.name, projectGroupsPageMatcher);
      },
    );

    test(
      ".handleInitialRoutePath() pushes the login page if the user is not logged in and the given page requires authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.handleInitialRoutePath(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, loginPageMatcher);
      },
    );

    test(
      ".handleInitialRoutePath() pushes the login page if the user is not logged in and the given page does not require authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.handleInitialRoutePath(MetricsRoutes.loading);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, loadingPageMatcher);
      },
    );

    test(
      ".handleInitialRoutePath() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.projectGroups;

        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.handleInitialRoutePath(MetricsRoutes.projectGroups);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );

    test(
      ".handleNewRoutePath() pushes the given page if the user is logged in",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.handleNewRoutePath(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, projectGroupsPageMatcher);
      },
    );

    test(
      ".handleNewRoutePath() pushes the login page if the user is not logged in and the given page requires authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.handleNewRoutePath(MetricsRoutes.projectGroups);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, loginPageMatcher);
      },
    );

    test(
      ".handleNewRoutePath() pushes the login page if the user is not logged in and the given page does not require authorization",
      () {
        notifier.handleAuthenticationUpdates(isLoggedIn: false);

        notifier.handleNewRoutePath(MetricsRoutes.loading);

        final currentPage = notifier.pages.last;

        expect(currentPage.name, loadingPageMatcher);
      },
    );

    test(
      ".handleNewRoutePath() updates the current configuration",
      () {
        final expectedConfiguration = MetricsRoutes.projectGroups;

        notifier.handleAuthenticationUpdates(isLoggedIn: true);

        notifier.handleNewRoutePath(MetricsRoutes.projectGroups);

        expect(notifier.currentConfiguration, equals(expectedConfiguration));
      },
    );
  });
}
