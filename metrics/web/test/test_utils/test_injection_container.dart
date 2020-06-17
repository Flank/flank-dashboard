import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:provider/provider.dart';

import 'auth_notifier_stub.dart';
import 'project_metrics_notifier_stub.dart';
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

  /// Creates the [TestInjectionContainer] with the given notifiers.
  ///
  /// If [metricsNotifier] not passed, the [ProjectMetricsNotifierStub] used.
  /// If [authNotifier] not passed, the [SignedInAuthNotifierStub] used.
  /// If [themeNotifier] not passed, the [ThemeNotifier] used.
  const TestInjectionContainer({
    Key key,
    this.child,
    this.metricsNotifier,
    this.authNotifier,
    this.themeNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>(
          create: (_) => authNotifier ?? AuthNotifierStub(),
        ),
        ChangeNotifierProvider<ProjectMetricsNotifier>(
          create: (_) => metricsNotifier ?? ProjectMetricsNotifierStub(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => themeNotifier ?? ThemeNotifier(),
        ),
      ],
      child: child,
    );
  }
}
