// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A [Enum] that holds the route names of the Metrics application.
class RouteName extends Enum<String> {
  /// A route name of the dashboard page.
  static const dashboard = RouteName._('dashboard');

  /// A route name of the login page.
  static const login = RouteName._('login');

  /// A route name of the project groups page.
  static const projectGroups = RouteName._('projectGroups');

  /// A route name of the loading page.
  static const loading = RouteName._('loading');

  /// A route name of the debug menu page.
  static const debugMenu = RouteName._('debugMenu');

  /// Creates a new instance of the [RouteName].
  const RouteName._(String value) : super(value);

  /// A [Set] that contains all available [RouteName]s.
  static const Set<RouteName> values = {
    dashboard,
    login,
    projectGroups,
    loading,
  };

  @override
  String toString() => value;
}
