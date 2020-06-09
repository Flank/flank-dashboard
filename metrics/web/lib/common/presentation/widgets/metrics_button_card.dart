import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/metrics_card.dart';

/// The widget that represents metrics card with the ability 
/// to control touch events.
class MetricsButtonCard extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final EdgeInsets iconPadding;
  final Widget title;
  final EdgeInsets titlePadding;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double elevation;
  final EdgeInsetsGeometry margin;

  /// Creates a [MetricsButtonCard].
  /// 
  /// The given [iconData] is an icon, that displays in the center of the card.
  /// The icon has the [iconSize], the [iconColor] and the [iconPadding].
  /// Under the icon lies the given [text],
  /// that has the [titlePadding] with an [EdgeInsets.zero] value as a default.
  /// The callback [onTap] can react to touch events on the card.
  /// The card has the [backgroundColor], the [margin] 
  /// and the [elevation] arguments.
  /// 
  /// The [title], the [iconData], the [backgroundColor] and the [onTap] should not be null.
  const MetricsButtonCard({
    Key key,
    @required this.title,
    this.titlePadding = EdgeInsets.zero,
    @required this.iconData,
    this.iconSize,
    this.iconColor,
    this.iconPadding = EdgeInsets.zero,
    @required this.onTap,
    @required this.backgroundColor,
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
