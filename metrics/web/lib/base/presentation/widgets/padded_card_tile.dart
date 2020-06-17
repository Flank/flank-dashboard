import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/padded_card.dart';

/// The widget that represents a tile card.
class PaddedCardTile extends StatelessWidget {
  /// A text, that displays at the top left corner of the card.
  final Widget title;

  /// An empty space surrounds the [title].
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry titlePadding;

  /// A text subtitle of the [PaddedCardTile].
  final Widget subtitle;

  /// An empty space surrounds the [subtitle].
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry subtitlePadding;

  /// An action bar at the bottom of the [PaddedCardTile].
  final List<Widget> actions;

  /// An empty space surrounds the [actions].
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry actionsPadding;

  /// A background color of the [PaddedCardTile].
  final Color backgroundColor;

  /// An empty space that surrounds the [PaddedCardTile].
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry margin;

  /// An empty space between the main content and card's edges.
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry padding;

  /// An elevation of the [PaddedCardTile].
  ///
  /// Has a default value of [0.0].
  final double elevation;

  /// Creates a [PaddedCardTile].
  ///
  /// [title], [subtitle], [actions] and [backgroundColor] must not be null.
  const PaddedCardTile({
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
    return PaddedCard(
      elevation: elevation,
      margin: margin,
      padding: padding,
      backgroundColor: backgroundColor,
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
            child: Row(
              children: actions,
            ),
          ),
        ],
      ),
    );
  }
}
