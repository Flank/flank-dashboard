import 'package:flutter/material.dart';

/// The widget that represents a metrics dialog.
class MetricsDialog extends StatelessWidget {
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  final Widget title;
  final EdgeInsetsGeometry titlePadding;

  final Widget content;
  final EdgeInsetsGeometry contentPadding;

  final List<Widget> actions;
  final EdgeInsetsGeometry actionsPadding;
  final MainAxisAlignment actionsAlignment;

  /// Creates a [MetricsDialog].
  ///
  /// The given [title] is a text, that displays at the top of the dialog.
  /// The title is surrounded by a [titlePadding],
  /// that is an [EdgeInsets.zero] value by default.
  /// The given [content] is the main part of the dialog.
  /// The content is surrounded by a [contentPadding],
  /// that is the [EdgeInsets.zero] value by default.
  /// There are [actions], at the bottom of the dialog.
  /// The corresponding [actionsPadding] is the [EdgeInsets.zero] value by default.
  /// The [actionsAlignment] controls the main axis alignment of the actions.
  /// The general [padding] is the [EdgeInsets.zero] value by default.
  /// The metrics dialog has the [backgroundColor] argument.
  ///
  /// [title], [content], [actions] and [maxWidth] must not be null.
  const MetricsDialog({
    @required this.title,
    @required this.content,
    @required this.actions,
    @required this.maxWidth,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.titlePadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsAlignment = MainAxisAlignment.start,
  })  : assert(title != null),
        assert(content != null),
        assert(actions != null),
        assert(maxWidth != null);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
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
