import 'package:flutter/material.dart';

class MetricsDialog extends StatelessWidget {
  final Color backgroundColor;
  final double elevation;
  final ShapeBorder shape;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  final Widget title;
  final EdgeInsetsGeometry titlePadding;

  final Widget content;
  final EdgeInsetsGeometry contentPadding;

  final List<Widget> actions;
  final EdgeInsetsGeometry actionsPadding;
  final MainAxisAlignment actionsAlignment;

  const MetricsDialog({
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.padding = EdgeInsets.zero,
    this.maxWidth,
    this.title,
    this.titlePadding = EdgeInsets.zero,
    this.content,
    this.contentPadding = EdgeInsets.zero,
    this.actions,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      child: Container(
        padding: padding,
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close),
              ),
            ),
            Padding(
              padding: titlePadding,
              child: title,
            ),
            Padding(
              padding: contentPadding,
              child: content,
            ),
            Padding(
              padding: actionsPadding,
              child: Row(
                mainAxisAlignment: actionsAlignment,
                children: actions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
