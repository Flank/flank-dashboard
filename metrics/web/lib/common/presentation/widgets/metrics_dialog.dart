import 'package:flutter/material.dart';

/// The widget that represents metrics dialog.
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

  /// Creates an [MetricsDialog].
  ///
  /// [backgroundColor] is a background color of the surface of this [MetricsDialog].
  /// [elevation] is an elevation of this [MetricsDialog].
  /// [shape] is a shape of this [MetricsDialog] border.
  /// [padding] is a padding around the [MetricsDialog] child.
  /// [maxWidth] is a maximum available width of this [MetricsDialog].
  /// [title] is a title of this [MetricsDialog].
  /// [titlePadding] is a padding around the title.
  /// [content] is a content of this [MetricsDialog].
  /// [contentPadding] is a padding around the content.
  /// [actions] is a set of actions that are displayed at the bottom of this [MetricsDialog].
  /// [actionsPadding] is a padding around the actions.
  /// [actionsAlignment] is a main axis alignment of the [MetricsDialog]'s actions.
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
      child: SingleChildScrollView(
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
      ),
    );
  }
}
