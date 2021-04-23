// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:provider/provider.dart';

/// A [WidgetBuilder] that provides a [ThemeNotifier.isDark] value
/// and a [BuildContext] to the child of the [ThemeTypeBuilder].
typedef ThemeTypeWidgetBuilder = Widget Function(
  BuildContext context,
  bool isDark,
);

/// A widget that provides an ability to build widgets that depend on the
/// [ThemeNotifier.isDark] value.
class ThemeTypeBuilder extends StatelessWidget {
  /// A [ThemeTypeWidgetBuilder] used to build a child of this builder.
  final ThemeTypeWidgetBuilder builder;

  /// Creates a new instance of the [ThemeTypeBuilder] with the given [builder].
  ///
  /// Throws an [AssertionError] if the given [builder] is `null`.
  const ThemeTypeBuilder({
    Key key,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ThemeNotifier, bool>(
      selector: (_, notifier) => notifier.isDark,
      builder: (_, isDark, __) {
        return builder(context, isDark);
      },
    );
  }
}
