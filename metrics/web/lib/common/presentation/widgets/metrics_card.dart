import 'package:flutter/material.dart';

/// The widget that represents metrics card.
class MetricsCard extends StatelessWidget {
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

  /// Creates an [MetricsCard].
  ///
  /// [title] is a title of this [MetricsCard].
  /// [titlePadding] is a padding around the title.
  /// [subtitle]  is a subtitle of this [MetricsCard].
  /// [subtitlePadding] is a padding around the subtitle.
  /// [actions] is a set of actions that are displayed at the bottom of this [MetricsCard].
  /// [actionsPadding] is a padding around the actions.
  /// [backgroundColor] is background color of this [MetricsCard].
  /// [margin] is an empty space that surrounds the [MetricsCard].
  /// [padding] is a padding around the [MetricsCard]'s content.
  /// [elevation] is a elevation of this [MetricsCard].
  const MetricsCard({
    this.title,
    this.titlePadding = EdgeInsets.zero,
    this.subtitle,
    this.subtitlePadding = EdgeInsets.zero,
    this.actions,
    this.actionsPadding = EdgeInsets.zero,
    this.backgroundColor,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      margin: margin,
      elevation: elevation,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (title != null)
              Padding(
                padding: titlePadding,
                child: title,
              ),
            if (subtitle != null)
              Padding(
                padding: subtitlePadding,
                child: subtitle,
              ),
            if (actions != null)
              Padding(
                padding: actionsPadding,
                child: Row(
                  children: actions,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
