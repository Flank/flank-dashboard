import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:metrics/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/widgets/metrics_page_title.dart';

/// A common [Scaffold] widget for metrics pages.
class MetricsScaffold extends StatefulWidget {
  /// A panel that slides in horizontally from the edge of
  /// a Scaffold to show navigation links in an application.
  final Widget drawer;

  /// A metrics application [AppBar] widget.
  final Widget appBar;

  /// A primary content of this scaffold.
  final Widget body;

  /// A general padding around the [body].
  final EdgeInsets padding;

  /// A title for the body of this scaffold.
  final String title;

  /// Creates the [MetricsScaffold] widget.
  ///
  /// The [drawer] default value is [MetricsDrawer].
  /// The [appBar] default value is [MetricsAppBar].
  /// The [padding] default value is [EdgeInsets.zero].
  ///
  /// The [body] argument must not be null.
  const MetricsScaffold({
    Key key,
    @required this.body,
    this.drawer = const MetricsDrawer(),
    this.appBar = const MetricsAppBar(),
    this.padding = EdgeInsets.zero,
    this.title,
  })  : assert(body != null),
        super(key: key);

  @override
  _MetricsScaffoldState createState() => _MetricsScaffoldState();
}

class _MetricsScaffoldState extends State<MetricsScaffold> {
  @override
  Widget build(BuildContext context) {
    const _pageElementsPadding = EdgeInsets.only(bottom: 40.0);

    return Scaffold(
      endDrawer: widget.drawer,
      body: Center(
        child: Container(
          constraints: BoxConstraints.tight(
            const Size.fromWidth(DimensionsConfig.contentWidth),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.appBar != null)
                Padding(
                  padding: _pageElementsPadding,
                  child: widget.appBar,
                ),
              if (widget.title != null)
                Padding(
                  padding: _pageElementsPadding,
                  child: MetricsPageTitle(
                    title: widget.title,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: widget.padding,
                  child: widget.body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    ToastManager().dismissAll();
    super.deactivate();
  }
}
