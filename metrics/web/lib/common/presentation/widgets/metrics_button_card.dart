import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/metrics_card.dart';

/// The widget that represents metrics card with the ability 
/// to control touch events.
class MetricsButtonCard extends StatelessWidget {
  /// An icon, that displays in the center of the card.
  final IconData iconData;

  /// A size of the icon.
  final double iconSize;

  /// A color of the icon.
  final Color iconColor;

  /// A padding, around the icon.
  final EdgeInsets iconPadding;

  /// A text description of the [MetricsButtonCard].
  final Widget title;

  /// A padding around the title.
  final EdgeInsets titlePadding;

  /// A callback, that triggers after tap on the [MetricsButtonCard].
  final VoidCallback onTap;

  /// A background color of the [MetricsButtonCard].
  final Color backgroundColor;

  /// A [MetricsButtonCard]'s elevation.
  final double elevation;

  /// A margin around the [MetricsButtonCard].
  final EdgeInsetsGeometry margin;

  /// Creates a [MetricsButtonCard].
  /// 
  /// The [title], the [iconData], the [backgroundColor] and the [onTap]
  /// must not be null.
  const MetricsButtonCard({
    Key key,
    @required this.title,
    @required this.iconData,
    @required this.onTap,
    @required this.backgroundColor,
    this.titlePadding = EdgeInsets.zero,
    this.iconSize,
    this.iconColor,
    this.iconPadding = EdgeInsets.zero,
    this.margin,
    this.elevation,
  })  : assert(title != null),
        assert(iconData != null),
        assert(onTap != null),
        assert(backgroundColor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: MetricsCard(
        elevation: elevation,
        margin: margin,
        backgroundColor: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: iconPadding,
              child: Icon(
                iconData,
                size: iconSize,
                color: iconColor,
              ),
            ),
            Padding(
              padding: titlePadding,
              child: title,
            ),
          ],
        ),
      ),
    );
  }
}
