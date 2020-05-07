import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/features/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:provider/provider.dart';

import 'auth_notifier_stub.dart';
import 'project_metrics_notifier_stub.dart';
import 'signed_in_auth_notifier_stub.dart';

/// A testbed class that injects the stub [ChangeNotifier]s needed in tests.
class InjectionContainerTestbed extends StatelessWidget {
  /// A child widget to display.
  final Widget child;

  /// A [ProjectMetricsNotifier] that will be injected.
  final ProjectMetricsNotifier metricsNotifier;

  /// An [AuthNotifier] that will be injected.
  final AuthNotifier authNotifier;

  /// A [ThemeNotifier] that will be injected.
  final ThemeNotifier themeNotifier;

  /// Creates the [InjectionContainerTestbed] with the given notifiers.
  ///
  /// If [metricsNotifier] not passed, the [ProjectMetricsNotifierStub] used.
  /// If [authNotifier] not passed, the [SignedInAuthNotifierStub] used.
  /// If [themeNotifier] not passed, the [ThemeNotifier] used.
  const InjectionContainerTestbed({
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
