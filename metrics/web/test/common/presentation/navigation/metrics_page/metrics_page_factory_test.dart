// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_factory.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:metrics/common/presentation/pages/loading_page.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/debug_menu/presentation/pages/debug_menu_page.dart';
import 'package:metrics/project_groups/presentation/pages/project_group_page.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/route_configuration_stub.dart';

void main() {
  group("MetricsPageFactory", () {
    final metricsPageFactory = MetricsPageFactory();

    test(
      ".create() returns the dashboard metrics page if the given route configuration is null",
      () {
        final page = metricsPageFactory.create(null);

        expect(page.child, isA<DashboardPage>());
      },
    );

    test(
      ".create() returns the loading metrics page with a name equals to the given route configuration path",
      () {
        const routeConfiguration = MetricsRoutes.loading;
        final expectedName = routeConfiguration.path;

        final actualName = metricsPageFactory.create(routeConfiguration).name;

        expect(actualName, equals(expectedName));
      },
    );

    test(
      ".create() returns the login metrics page with a name equals to the given route configuration path",
      () {
        final routeConfiguration = MetricsRoutes.login;
        final expectedName = routeConfiguration.path;

        final actualName = metricsPageFactory.create(routeConfiguration).name;

        expect(actualName, equals(expectedName));
      },
    );

    test(
      ".create() returns the dashboard metrics page with a name equals to the given route configuration path",
      () {
        final routeConfiguration = MetricsRoutes.dashboard;
        final expectedName = routeConfiguration.path;

        final actualName = metricsPageFactory.create(routeConfiguration).name;

        expect(actualName, equals(expectedName));
      },
    );

    test(
      ".create() returns the project groups metrics page with a name equals to the given route configuration path",
      () {
        final routeConfiguration = MetricsRoutes.projectGroups;
        final expectedName = routeConfiguration.path;

        final actualName = metricsPageFactory.create(routeConfiguration).name;

        expect(actualName, equals(expectedName));
      },
    );

    test(
      ".create() returns the debug menu metrics page with a name equals to the given route configuration path",
      () {
        final routeConfiguration = MetricsRoutes.debugMenu;
        final expectedName = routeConfiguration.path;

        final actualName = metricsPageFactory.create(routeConfiguration).name;

        expect(actualName, equals(expectedName));
      },
    );

    test(
      ".create() returns the dashboard metrics page with a name equals to the given route configuration path if the configuration name is unknown",
      () {
        const testName = 'test';

        final unknown = _RouteNameMock();
        when(unknown.value).thenReturn('unknown');

        final routeConfiguration = RouteConfigurationStub(
          name: unknown,
          path: testName,
        );

        final actualName = metricsPageFactory.create(routeConfiguration).name;

        expect(actualName, equals(testName));
      },
    );

    test(
      ".create() returns the loading metrics page if the given route configuration name is a loading",
      () {
        final page = metricsPageFactory.create(MetricsRoutes.loading);

        expect(page.child, isA<LoadingPage>());
      },
    );

    test(
      ".create() returns the login metrics page if the given route configuration name is a login",
      () {
        final page = metricsPageFactory.create(MetricsRoutes.login);

        expect(page.child, isA<LoginPage>());
      },
    );

    test(
      ".create() returns the dashboard metrics page if the given route configuration name is a dashboard",
      () {
        final page = metricsPageFactory.create(MetricsRoutes.dashboard);

        expect(page.child, isA<DashboardPage>());
      },
    );

    test(
      ".create() returns the project group metrics page if the given route configuration name is project groups",
      () {
        final page = metricsPageFactory.create(MetricsRoutes.projectGroups);

        expect(page.child, isA<ProjectGroupPage>());
      },
    );

    test(
      ".create() returns the debug menu metrics page if the given route configuration name is a debug menu",
      () {
        final page = metricsPageFactory.create(MetricsRoutes.debugMenu);

        expect(page.child, isA<DebugMenuPage>());
      },
    );

    test(
      ".create() returns the project group metrics page if the given route configuration name is unknown",
      () {
        final unknown = _RouteNameMock();
        when(unknown.value).thenReturn('unknown');

        final routeConfiguration = RouteConfigurationStub(name: unknown);
        final page = metricsPageFactory.create(routeConfiguration);

        expect(page.child, isA<DashboardPage>());
      },
    );
  });
}

class _RouteNameMock extends Mock implements RouteName {}
