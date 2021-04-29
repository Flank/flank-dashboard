// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:provider/provider.dart';

/// A callback for building a widget depending on the given [context],
/// [isDark], and [child] values.
typedef ThemeModeWidgetBuilder = Widget Function(
  BuildContext context,
  bool isDark,
  Widget child,
);

/// A widget that rebuilds its content depending on the current
/// [ThemeNotifier.isDark] value using the given [builder] and [child].
class ThemeModeBuilder extends StatelessWidget {
  /// A [ThemeModeWidgetBuilder] used to build a child of this builder.
  final ThemeModeWidgetBuilder builder;

  /// A [Widget] of this builder that does not depend on the theme mode changes.
  final Widget child;

  /// Creates a new instance of the [ThemeModeBuilder] with the given [builder]
  /// and [child].
  ///
  /// Throws an [AssertionError] if the given [builder] is `null`.
  const ThemeModeBuilder({
    Key key,
    @required this.builder,
    this.child,
  })  : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ThemeNotifier, bool>(
      selector: (_, notifier) => notifier.isDark,
      builder: builder,
      child: child,
    );
  }
}
