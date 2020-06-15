import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/metrics_card.dart';

/// The widget that represents a metrics tile card.
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

  /// Creates a [MetricsTileCard].
  ///
  /// The metrics card tile has a specific [backgroundColor].
  /// The given [title] is a text, that displays at the top left corner of the card.
  /// The title is surrounded by a [titlePadding],
  /// that is [EdgeInsets.zero] value by default.
  /// The given [subtitle] is a text under the [title].
  /// The subtitle is surrounded by a [subtitlePadding],
  /// that is [EdgeInsets.zero] value by default.
  /// There are [actions], at the bottom of the card.
  /// The corresponding [actionsPadding] is [EdgeInsets.zero] value by default.
  /// The metrics card has a [margin] and a [padding] arguments,
  /// that have [EdgeInsets.zero] value as a default.
  /// The [elevation] argument has a default value of 0.0.
  ///
  /// [title], [subtitle], [actions] and [backgroundColor] should not be null.
  const MetricsTileCard({
    Key key,
    @required this.backgroundColor,
    @required this.title,
    @required this.subtitle,
    @required this.actions,
    this.titlePadding = EdgeInsets.zero,
    this.subtitlePadding = EdgeInsets.zero,
    this.actionsPadding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.elevation = 0.0,
  })  : assert(backgroundColor != null),
        assert(title != null),
        assert(subtitle != null),
        assert(actions != null),
        super(key: key);

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
