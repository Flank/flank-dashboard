// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/state/timer_notifier.dart';
import 'package:provider/provider.dart';

/// A widget that provides an ability to rebuild periodically using
/// the [TimerNotifier].
class MetricsTimerBuilder extends StatelessWidget {
  /// A flag that indicates whether this widget should rebuild
  /// on a [TimerNotifier]'s tick.
  final bool rebuildsEnabled;

  /// A [WidgetBuilder] used to build a child of this builder.
  final WidgetBuilder builder;

  /// Creates a new instance of the [MetricsTimerBuilder] with the given
  /// [builder] and [rebuildsEnabled].
  ///
  /// This widget rebuilds on each [TimerNotifier] tick, if the given
  /// [rebuildsEnabled] is `true`. Otherwise, the widget does not rebuild.
  ///
  /// The [rebuildsEnabled] defaults to `true`.
  ///
  /// Throws an [AssertionError] if the [builder] or [rebuildsEnabled]
  /// is `null`.
  const MetricsTimerBuilder({
    Key key,
    @required this.builder,
    this.rebuildsEnabled = true,
  })  : assert(builder != null),
        assert(rebuildsEnabled != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerNotifier>(
      builder: (_, __, child) {
        if (!rebuildsEnabled) return child;

        return builder.call(context);
      },
      child: builder.call(context),
    );
  }
}
