// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// An [Enum] that represents the page names.
class PageName extends Enum<String> {
  /// A [PageName] that represents the login page name.
  static const PageName loginPage = PageName._('/login');

  /// A [PageName] that represents the dashboard page name.
  static const PageName dashboardPage = PageName._('/dashboard');

  /// A [PageName] that represents the project groups page name.
  static const PageName projectGroupsPage = PageName._('/projectGroups');

  /// A [PageName] that represents the debug menu page name.
  static const PageName debugMenuPage = PageName._('/debugMenu');

  /// A [Set] that contains all available [PageName]s.
  static const Set<PageName> values = {
    loginPage,
    dashboardPage,
    projectGroupsPage,
    debugMenuPage,
  };

  /// Creates a new instance of the [PageName].
  const PageName._(String value) : super(value);
}
