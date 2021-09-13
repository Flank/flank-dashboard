// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/page_title/widgets/metrics_page_title.dart';

/// A common [Scaffold] widget for metrics pages.
class MetricsScaffold extends StatelessWidget {
  /// A panel that slides in horizontally from the edge of
  /// a Scaffold to show navigation links in an application.
  final Widget drawer;

  /// A primary content of this scaffold.
  final Widget body;

  /// A general padding around the [body].
  final EdgeInsets padding;

  /// A title for the body of this scaffold.
  final String title;

  /// Creates the [MetricsScaffold] widget.
  ///
  /// The [drawer] default value is [MetricsDrawer].
  /// The [padding] default value is [EdgeInsets.zero].
  ///
  /// The [body] argument must not be null.
  const MetricsScaffold({
    Key key,
    @required this.body,
    this.drawer = const MetricsDrawer(),
    this.padding = EdgeInsets.zero,
    this.title,
  })  : assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const _pageElementsPadding = EdgeInsets.only(bottom: 40.0);

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints.tight(
            const Size.fromWidth(DimensionsConfig.contentWidth),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: _pageElementsPadding,
                child: MetricsAppBar(),
              ),
              if (title != null)
                Padding(
                  padding: _pageElementsPadding,
                  child: MetricsPageTitle(
                    title: title,
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
