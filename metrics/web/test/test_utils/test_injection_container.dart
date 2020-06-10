import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/state/projects_notifier.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:provider/provider.dart';

import 'auth_notifier_stub.dart';
import 'project_group_notifier_stub.dart';
import 'project_metrics_notifier_stub.dart';
import 'projects_notifier_stub.dart';
import 'signed_in_auth_notifier_stub.dart';

/// A widget that injects the [ChangeNotifier]s needed in tests.
class TestInjectionContainer extends StatelessWidget {
  /// A child widget to display.
  final Widget child;

  /// A [ProjectMetricsNotifier] to inject.
  final ProjectMetricsNotifier metricsNotifier;

  /// An [AuthNotifier] to inject.
  final AuthNotifier authNotifier;

  /// A [ThemeNotifier] to inject.
  final ThemeNotifier themeNotifier;

  /// A [ProjectsNotifier] to inject.
  final ProjectsNotifier projectsNotifier;

  /// A [ProjectGroupsNotifier] to inject.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// Creates the [TestInjectionContainer] with the given notifiers.
  ///
  /// If [metricsNotifier] not passed, the [ProjectMetricsNotifierStub] used.
  /// If [authNotifier] not passed, the [SignedInAuthNotifierStub] used.
  /// If [themeNotifier] not passed, the [ThemeNotifier] used.
  /// If [projectsNotifier] not passed, the [ProjectsNotifierStub] used.
  /// If [projectGroupsNotifier] not passed, the [ProjectGroupsNotifierStub] used.
  const TestInjectionContainer({
    Key key,
    this.child,
    this.metricsNotifier,
    this.authNotifier,
    this.themeNotifier,
    this.projectsNotifier,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>(
          create: (_) => authNotifier ?? AuthNotifierStub(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => themeNotifier ?? ThemeNotifier(),
        ),
        ChangeNotifierProxyProvider<AuthNotifier, ProjectsNotifier>(
          create: (_) => projectsNotifier ?? ProjectsNotifierStub(),
          update: (_, authNotifier, projectsNotifier) {
            return projectsNotifier
              ..updateProjectsSubscription(
                isLoggedIn: authNotifier.isLoggedIn,
              );
          },
        ),
        ChangeNotifierProxyProvider<ProjectsNotifier, ProjectMetricsNotifier>(
          create: (_) => metricsNotifier ?? ProjectMetricsNotifierStub(),
          update: (_, projectsNotifier, metricsNotifier) {
            return metricsNotifier
              ..updateProjects(
                projectsNotifier.projects,
                projectsNotifier.projectsErrorMessage,
              );
          },
        ),
        ChangeNotifierProxyProvider<ProjectsNotifier, ProjectGroupsNotifier>(
          create: (_) => projectGroupsNotifier ?? ProjectGroupsNotifierStub(),
          update: (_, projectsNotifier, projectGroupsNotifier) {
            return projectGroupsNotifier
              ..updateProjects(
                projectsNotifier.projects,
                projectsNotifier.projectsErrorMessage,
              );
          },
        ),
      ],
      child: child,
    );
  }
}
