import 'package:flutter/material.dart';

/// A class that is responsible for replacing the entire screen
/// without transition animation.
class MetricsPageRoute<T> extends MaterialPageRoute<T> {
  MetricsPageRoute({
    @required WidgetBuilder builder,
    @required RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(settings != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
