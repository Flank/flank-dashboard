import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/features/common/presentation/drawer/widget/metrics_drawer.dart';

/// The default [Scaffold] widget for metrics pages.
class MetricsScaffold extends StatelessWidget {
  final Widget drawer;
  final Widget body;

  /// Creates the [MetricsScaffold] widget.
  ///
  /// Throws an [AssertionError] is the [body] is null.
  ///
  /// [body] is the primary content of the scaffold.
  /// [drawer] is the panel, displayed on the right side of the [body].
  /// If nothing is passed the [MetricsDrawer] will be used.
  const MetricsScaffold({
    Key key,
    @required this.body,
    this.drawer = const MetricsDrawer(),
  })  : assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MetricsAppBar(),
      endDrawer: drawer,
      body: SafeArea(
        child: body,
      ),
    );
  }
}
