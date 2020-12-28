import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_factory.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:metrics/common/presentation/pages/loading_page.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/debug_menu/presentation/pages/debug_menu_page.dart';
import 'package:metrics/project_groups/presentation/pages/project_group_page.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

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
      ".create() returns the metrics page with a name equals to the given route configuration's path",
      () {
        const expectedName = 'test';
        const routeConfiguration = _RouteConfigurationStub(
          name: RouteName.loading,
          path: expectedName,
        );

        final actualName = metricsPageFactory.create(routeConfiguration).name;

        expect(actualName, equals(expectedName));
      },
    );

    test(
      ".create() returns the metrics page having the loading page widget as a child if the route configuration name is a loading",
      () {
        const routeConfiguration = _RouteConfigurationStub(
          name: RouteName.loading,
        );

        final page = metricsPageFactory.create(routeConfiguration);

        expect(
          page,
          isA<MetricsPage>().having(
            (metricsPage) => metricsPage.child,
            'LoadingPage',
            isA<LoadingPage>(),
          ),
        );
      },
    );

    test(
      ".create() returns the metrics page having the login page widget as a child if the route configuration name is a login",
      () {
        const routeConfiguration = _RouteConfigurationStub(
          name: RouteName.login,
        );

        final page = metricsPageFactory.create(routeConfiguration);

        expect(
          page,
          isA<MetricsPage>().having(
            (metricsPage) => metricsPage.child,
            'LoginPage',
            isA<LoginPage>(),
          ),
        );
      },
    );

    test(
      ".create() returns the metrics page having the dashboard page widget as a child if the route configuration name is a dashboard",
      () {
        const routeConfiguration = _RouteConfigurationStub(
          name: RouteName.dashboard,
        );

        final page = metricsPageFactory.create(routeConfiguration);

        expect(
          page,
          isA<MetricsPage>().having(
            (metricsPage) => metricsPage.child,
            'DashboardPage',
            isA<DashboardPage>(),
          ),
        );
      },
    );

    test(
      ".create() returns the metrics page having the debug menu page widget as a child if the route configuration name is a debug menu",
      () {
        const routeConfiguration = _RouteConfigurationStub(
          name: RouteName.debugMenu,
        );

        final page = metricsPageFactory.create(routeConfiguration);

        expect(
          page,
          isA<MetricsPage>().having(
            (metricsPage) => metricsPage.child,
            'DebugMenuPage',
            isA<DebugMenuPage>(),
          ),
        );
      },
    );

    test(
      ".create() returns the metrics page having the project group page widget as a child if the route configuration name is project groups",
      () {
        const routeConfiguration = _RouteConfigurationStub(
          name: RouteName.projectGroups,
        );

        final page = metricsPageFactory.create(routeConfiguration);

        expect(
          page,
          isA<MetricsPage>().having(
            (metricsPage) => metricsPage.child,
            'ProjectGroupPage',
            isA<ProjectGroupPage>(),
          ),
        );
      },
    );

    test(
      ".create() returns the metrics page having the dashboard page widget as a child if the route configuration name is unknown",
      () {
        final unknown = _RouteNameMock();
        when(unknown.value).thenReturn('unknown');

        final routeConfiguration = _RouteConfigurationStub(name: unknown);
        final page = metricsPageFactory.create(routeConfiguration);

        expect(
          page,
          isA<MetricsPage>().having(
            (metricsPage) => metricsPage.child,
            'DashboardPage',
            isA<DashboardPage>(),
          ),
        );
      },
    );
  });
}

/// Stub implementation of the [RouteConfiguration].
class _RouteConfigurationStub extends RouteConfiguration {
  const _RouteConfigurationStub({
    RouteName name,
    String path,
  }) : super(name: name, path: path, authorizationRequired: false);
}

class _RouteNameMock extends Mock implements RouteName {}
