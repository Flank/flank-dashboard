// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that is responsible for replacing the entire screen
/// without transition animation.
class MetricsPageRoute<T> extends MaterialPageRoute<T> {
  /// Creates the [MetricsPageRoute] whose contents are defined by [builder].
  ///
  /// The [maintainState] default value is `true`.
  /// The [fullscreenDialog] default value is `false`.
  ///
  /// The values of [builder], [maintainState], and [fullscreenDialog] must not
  /// be null.
  MetricsPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
