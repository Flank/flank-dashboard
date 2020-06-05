import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/metrics_card.dart';

/// The widget that represents metrics button card.
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

  /// Creates an [MetricsButtonCard].
  ///
  /// [iconData] is a description of an icon fulfilled by a font glyph.
  /// [iconSize] is a size of the icon in logical pixels.
  /// [iconColor] is a color to use when drawing the icon.
  /// [iconPadding] is a padding around the icon.
  /// [title] is a title of this [MetricsButtonCard].
  /// [titlePadding] is a padding around the title.
  /// [onTap] is callback that called when the user taps this [MetricsButtonCard].
  /// [backgroundColor] is a background color of this [MetricsButtonCard].
  /// [elevation] is an elevation of this [MetricsButtonCard].
  /// [margin] is an empty space that surrounds the [MetricsButtonCard].
  const MetricsButtonCard({
    Key key,
    this.title,
    this.onTap,
    this.iconData,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.titlePadding,
    this.backgroundColor,
    this.margin,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: MetricsCard(
        elevation: elevation,
        margin: margin,
        backgroundColor: backgroundColor,
        child: SingleChildScrollView(
          child: Center(
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
        ),
      ),
    );
  }
}
