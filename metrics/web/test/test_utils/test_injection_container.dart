// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/state/page_notifier.dart';
import 'package:metrics/common/presentation/state/projects_notifier.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/state/timer_notifier.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:provider/provider.dart';

import 'analytics_notifier_stub.dart';
import 'auth_notifier_stub.dart';
import 'debug_menu_notifier_stub.dart';
import 'feature_config_notifier_stub.dart';
import 'navigation_notifier_mock.dart';
import 'page_notifier_mock.dart';
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

  /// A [FeatureConfigNotifier] to inject.
  final FeatureConfigNotifier featureConfigNotifier;

  /// A [DebugMenuNotifier] to inject.
  final DebugMenuNotifier debugMenuNotifier;

  /// A [NavigationNotifier] to inject.
  final NavigationNotifier navigationNotifier;

  /// A [TimerNotifier] to inject.
  final TimerNotifier timerNotifier;

  /// A [PageNotifier] to inject.
  final PageNotifier pageNotifier;

  /// Creates the [TestInjectionContainer] with the given notifiers.
  ///
  /// If the [metricsNotifier] is `null`, the [ProjectMetricsNotifierStub] is used.
  /// If the [authNotifier] is `null`, the [SignedInAuthNotifierStub] is used.
  /// If the [analyticsNotifier] is `null`, the [AnalyticsNotifierStub] is used.
  /// If the [themeNotifier] is `null`, the [ThemeNotifier] is used.
  /// If the [projectsNotifier] is `null`, the [ProjectsNotifierStub] is used.
  /// If the [projectGroupsNotifier] is `null`, the [ProjectGroupsNotifierStub] is used.
  /// If the [featureConfigNotifier] is `null`, the [FeatureConfigNotifierStub] is used.
  /// If the [debugMenuNotifier] is `null`, the [DebugMenuNotifierStub] is used.
  /// If the [navigationNotifier] is `null`, the [NavigationNotifierMock] is used.
  /// If the [timerNotifier] is `null`, the [TimerNotifier] is used.
  /// If the [pageNotifier] is `null`, the [PageNotifier] is used.
  const TestInjectionContainer({
    Key key,
    this.child,
    this.metricsNotifier,
    this.authNotifier,
    this.analyticsNotifier,
    this.themeNotifier,
    this.projectsNotifier,
    this.projectGroupsNotifier,
    this.featureConfigNotifier,
    this.debugMenuNotifier,
    this.navigationNotifier,
    this.timerNotifier,
    this.pageNotifier,
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
        ChangeNotifierProvider<FeatureConfigNotifier>(
          create: (_) => featureConfigNotifier ?? FeatureConfigNotifierStub(),
        ),
        ChangeNotifierProvider<DebugMenuNotifier>(
          create: (_) => debugMenuNotifier ?? DebugMenuNotifierStub(),
        ),
        ChangeNotifierProvider<NavigationNotifier>(
          create: (_) => navigationNotifier ?? NavigationNotifierMock(),
        ),
        ChangeNotifierProvider<TimerNotifier>(
          create: (_) => timerNotifier ?? TimerNotifier(),
        ),
        ChangeNotifierProvider<PageNotifier>(
          create: (_) => pageNotifier ?? PageNotifierMock(),
        ),
      ],
      child: child,
    );
  }
}
