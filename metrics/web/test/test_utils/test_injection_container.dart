import 'package:flutter/material.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/state/projects_notifier.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/instant_config/presentation/state/instant_config_notifier.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:provider/provider.dart';

import 'analytics_notifier_stub.dart';
import 'auth_notifier_stub.dart';
import 'instant_config_notifier_stub.dart';
import 'project_groups_notifier_stub.dart';
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

  /// An [AnalyticsNotifier] to inject.
  final AnalyticsNotifier analyticsNotifier;

  /// A [ThemeNotifier] to inject.
  final ThemeNotifier themeNotifier;

  /// A [ProjectsNotifier] to inject.
  final ProjectsNotifier projectsNotifier;

  /// A [ProjectGroupsNotifier] to inject.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// A [InstantConfigNotifier] to inject.
  final InstantConfigNotifier instantConfigNotifier;

  /// Creates the [TestInjectionContainer] with the given notifiers.
  ///
  /// If the [metricsNotifier] is `null`, the [ProjectMetricsNotifierStub] is used.
  /// If the [authNotifier] is `null`, the [SignedInAuthNotifierStub] is used.
  /// If the [analyticsNotifier] is `null`, the [AnalyticsNotifierStub] is used.
  /// If the [themeNotifier] is `null`, the [ThemeNotifier] is used.
  /// If the [projectsNotifier] is `null`, the [ProjectsNotifierStub] is used.
  /// If the [projectGroupsNotifier] is `null`, the [ProjectGroupsNotifierStub] is used.
  /// If the [instantConfigNotifier] is `null`, the [InstantConfigNotifierStub] is used.
  const TestInjectionContainer({
    Key key,
    this.child,
    this.metricsNotifier,
    this.authNotifier,
    this.analyticsNotifier,
    this.themeNotifier,
    this.projectsNotifier,
    this.projectGroupsNotifier,
    this.instantConfigNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>(
          create: (_) => authNotifier ?? AuthNotifierStub(),
        ),
        ChangeNotifierProvider<AnalyticsNotifier>(
          create: (_) => analyticsNotifier ?? AnalyticsNotifierStub(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => themeNotifier ?? ThemeNotifier(),
        ),
        ChangeNotifierProvider<ProjectMetricsNotifier>(
          create: (_) => metricsNotifier ?? ProjectMetricsNotifierStub(),
        ),
        ChangeNotifierProvider<ProjectsNotifier>(
          create: (_) => projectsNotifier ?? ProjectsNotifierStub(),
        ),
        ChangeNotifierProvider<ProjectGroupsNotifier>(
          create: (_) => projectGroupsNotifier ?? ProjectGroupsNotifierStub(),
        ),
        ChangeNotifierProvider<InstantConfigNotifier>(
          create: (_) => instantConfigNotifier ?? InstantConfigNotifierStub(),
        ),
      ],
      child: child,
    );
  }
}
