import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/common/presentation/drawer/widget/metrics_drawer.dart';

/// A common [Scaffold] widget for metrics pages.
class MetricsScaffold extends StatelessWidget {
  /// The panel that slides in horizontally from the edge of
  /// a Scaffold to show navigation links in an application.
  final Widget drawer;

  /// A primary content of this scaffold.
  final Widget body;

  /// A general padding around the [body].
  final EdgeInsets padding;

  /// Creates the [MetricsScaffold] widget.
  ///
  /// Throws an [AssertionError] if the [body] is null.
  /// If the [drawer] is not specified, the [MetricsDrawer] is used.
  const MetricsScaffold({
    Key key,
    @required this.body,
    this.drawer = const MetricsDrawer(),
    this.padding = const EdgeInsets.symmetric(horizontal: 124.0),
  })  : assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MetricsAppBar(),
      endDrawer: drawer,
      body: Padding(
        padding: padding,
        child: body,
      ),
    );
  }
}
