// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/state/timer_notifier.dart';
import 'package:provider/provider.dart';

/// A widget that provides an ability to rebuild periodically using
/// the [TimerNotifier].
///
/// This widget rebuilds on each [TimerNotifier] tick, if the given
/// [shouldSubscribe] is `true`. Otherwise, the widget does not rebuild.
class TimerNotifierBuilder extends StatelessWidget {
  /// A flag that indicates whether this widget should subscribe
  /// to [TimerNotifier]'s ticks.
  final bool shouldSubscribe;

  /// A [WidgetBuilder] used to build a child of this builder.
  final WidgetBuilder builder;

  /// Creates a new instance of the [TimerNotifierBuilder] with the given
  /// [builder] and [shouldSubscribe].
  ///
  /// The [shouldSubscribe] defaults to `true`.
  ///
  /// Throws an [AssertionError] if the [builder] or [shouldSubscribe]
  /// is `null`.
  const TimerNotifierBuilder({
    Key key,
    @required this.builder,
    this.shouldSubscribe = true,
  })  : assert(builder != null),
        assert(shouldSubscribe != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!shouldSubscribe) return builder(context);

    return Consumer<TimerNotifier>(
      builder: (context, _, __) {
        return builder(context);
      },
    );
  }
}
