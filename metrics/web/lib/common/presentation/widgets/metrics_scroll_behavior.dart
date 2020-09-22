import 'package:flutter/material.dart';

/// A [ScrollBehavior] that disable the stretching effect.
class MetricsScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
