import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:metrics/common/presentation/pages/loading_page.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/project_groups/presentation/pages/project_group_page.dart';

/// A factory responsible for creating the [MetricsPage]
/// based on the [RouteConfiguration].
class MetricsPageFactory {
  /// Creates a [MetricsPage] from the given [RouteConfiguration].
  ///
  /// If the given [RouteConfiguration] contains the route name that
  /// does not match to any of [RouteName]s returns [DashboardPage].
  static MetricsPage create(RouteConfiguration configuration) {
    final routeName = configuration.name;
    if (routeName == RouteName.loading) {
      return MetricsPage(child: LoadingPage());
    }
    if (routeName == RouteName.login) {
      return const MetricsPage(child: LoginPage());
    }
    if (routeName == RouteName.dashboard) {
      return MetricsPage(child: DashboardPage());
    }
    if (routeName == RouteName.projectGroups) {
      return MetricsPage(child: ProjectGroupPage());
    }
    return MetricsPage(child: DashboardPage());
  }
}
