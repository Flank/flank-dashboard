import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/state/projects_notifier.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/project_groups/presentation/pages/project_group_page.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/new_test_injection_container.dart';

void main() {
  group("ProjectGroupPage", () {
    testWidgets(
      "contains the ProjectGroupCardGridView widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupPageTestbed());

        expect(find.byType(ProjectGroupCardGridView), findsOneWidget);
      },
    );
    testWidgets(
      "contains the project groups text",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectGroupPageTestbed());

        expect(find.text(ProjectGroupsStrings.projectGroups), findsOneWidget);
      },
    );
  });
}

/// A testbed widget, used to test the [ProjectGroupPage] widget.
class _ProjectGroupPageTestbed extends StatelessWidget {
  /// The [ThemeNotifier] to inject and use to test the [ProjectGroupPage].
  final ThemeNotifier themeNotifier;

  /// The [ProjectMetricsNotifier] to inject and use to test the [ProjectGroupPage].
  final ProjectMetricsNotifier metricsNotifier;

  /// The [AuthNotifier] to inject and use to test the [ProjectGroupPage].
  final AuthNotifier authNotifier;

  /// The [ProjectsNotifier] to inject and use to test the [ProjectGroupPage].
  final ProjectsNotifier projectsNotifier;

  /// The [ProjectGroupsNotifier] to inject and use to test the [ProjectGroupPage].
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// Creates the [_DashboardTestbed] with the given [themeNotifier].
  const _ProjectGroupPageTestbed({
    Key key,
    this.themeNotifier,
    this.metricsNotifier,
    this.authNotifier,
    this.projectsNotifier,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewTestInjectionContainer(
      themeNotifier: themeNotifier,
      metricsNotifier: metricsNotifier,
      authNotifier: authNotifier,
      projectsNotifier: projectsNotifier,
      projectGroupsNotifier: projectGroupsNotifier,
      child: Builder(builder: (context) {
        return MaterialApp(
          onGenerateRoute: (settings) => RouteGenerator.generateRoute(
              settings: settings,
              isLoggedIn:
                  Provider.of<AuthNotifier>(context, listen: false).isLoggedIn),
          home: MetricsThemeBuilder(
            builder: (_, __) => ProjectGroupPage(),
          ),
        );
      }),
    );
  }
}
