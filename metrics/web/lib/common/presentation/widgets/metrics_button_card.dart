import 'package:flutter/material.dart';

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
    this.margin = EdgeInsets.zero,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: margin,
        elevation: elevation,
        color: backgroundColor,
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
