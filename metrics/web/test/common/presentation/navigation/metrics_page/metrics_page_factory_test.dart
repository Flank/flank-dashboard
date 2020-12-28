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
    test(
      ".create() returns the metrics page having the dashboard page widget as a child if the route configuration is null",
      () {
        final page = MetricsPageFactory.create(null);

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
      ".create() returns the metrics page having the loading page widget as a child if the route configuration name is a loading",
      () {
        const routeConfiguration = RouteConfiguration(
          name: RouteName.loading,
          authorizationRequired: false,
        );

        final page = MetricsPageFactory.create(routeConfiguration);

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
        const routeConfiguration = RouteConfiguration(
          name: RouteName.login,
          authorizationRequired: false,
        );

        final page = MetricsPageFactory.create(routeConfiguration);

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
        const routeConfiguration = RouteConfiguration(
          name: RouteName.dashboard,
          authorizationRequired: false,
        );

        final page = MetricsPageFactory.create(routeConfiguration);

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
        const routeConfiguration = RouteConfiguration(
          name: RouteName.debugMenu,
          authorizationRequired: false,
        );

        final page = MetricsPageFactory.create(routeConfiguration);

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
        const routeConfiguration = RouteConfiguration(
          name: RouteName.projectGroups,
          authorizationRequired: false,
        );

        final page = MetricsPageFactory.create(routeConfiguration);

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
        when(unknown.value).thenReturn(null);

        final routeConfiguration = RouteConfiguration(
          name: unknown,
          authorizationRequired: false,
        );

        final page = MetricsPageFactory.create(routeConfiguration);

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

class _RouteNameMock extends Mock implements RouteName {}
