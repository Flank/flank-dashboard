import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/metrics_card.dart';

/// The widget that represents metrics card.
class MetricsTileCard extends StatelessWidget {
  final Widget title;
  final EdgeInsetsGeometry titlePadding;
  final Widget subtitle;
  final EdgeInsetsGeometry subtitlePadding;
  final List<Widget> actions;
  final EdgeInsetsGeometry actionsPadding;
  final Color backgroundColor;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double elevation;

  /// Creates an [MetricsTileCard].
  ///
  /// [title] is a title of this [MetricsTileCard].
  /// [titlePadding] is a padding around the title.
  /// [subtitle]  is a subtitle of this [MetricsTileCard].
  /// [subtitlePadding] is a padding around the subtitle.
  /// [actions] is a set of actions that are displayed at the bottom of this [MetricsTileCard].
  /// [actionsPadding] is a padding around the actions.
  /// [backgroundColor] is background color of this [MetricsTileCard].
  /// [margin] is an empty space that surrounds the [MetricsTileCard].
  /// [padding] is a padding around the [MetricsTileCard]'s content.
  /// [elevation] is a elevation of this [MetricsTileCard].
  const MetricsTileCard({
    Key key,
    @required this.backgroundColor,
    @required this.title,
    this.titlePadding = EdgeInsets.zero,
    @required this.subtitle,
    this.subtitlePadding = EdgeInsets.zero,
    @required this.actions,
    this.actionsPadding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsCard(
      elevation: elevation,
      margin: margin,
      padding: padding,
      backgroundColor: backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: titlePadding,
              child: title,
            ),
            Padding(
              padding: subtitlePadding,
              child: subtitle,
            ),
            Padding(
              padding: actionsPadding,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: actions,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
