import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/common/presentation/widgets/metrics_page_title.dart';

/// A common [Scaffold] widget for metrics pages.
class MetricsScaffold extends StatelessWidget {
  /// The panel that slides in horizontally from the edge of
  /// a Scaffold to show navigation links in an application.
  final Widget drawer;

  /// A primary content of this scaffold.
  final Widget body;

  /// A general padding around the [body].
  final EdgeInsets padding;

  /// A title for the body of this scaffold.
  final String bodyTitle;

  /// Creates the [MetricsScaffold] widget.
  ///
  /// Throws an [AssertionError] if the [body] is null.
  /// If the [drawer] is not specified, the [MetricsDrawer] is used.
  const MetricsScaffold({
    Key key,
    @required this.body,
    this.drawer = const MetricsDrawer(),
    this.padding = EdgeInsets.zero,
    this.bodyTitle,
  })  : assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawer,
      body: Center(
        child: Container(
          constraints: BoxConstraints.tight(
            const Size.fromWidth(1140.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: MetricsAppBar(),
              ),
              if (bodyTitle != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: MetricsPageTitle(
                    title: bodyTitle,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: padding,
                  child: body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
