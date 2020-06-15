import 'package:flutter/material.dart';

/// The widget that represents a metrics dialog.
class MetricsDialog extends StatelessWidget {
  /// A background color of the dialog.
  final Color backgroundColor;

  /// An empty space between the main content and dialog's edges.
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry padding;

  /// A max width of the dialog.
  final double maxWidth;

  /// A text title of the dialog.
  final Widget title;

  /// An empty space surrounds the [title].
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry titlePadding;

  /// A content of the dialog.
  final Widget content;

  /// An empty space surrounds the [content].
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry contentPadding;

  /// An action bar at the bottom of the dialog.
  final List<Widget> actions;

  /// An empty space surrounds the [actions].
  ///
  /// Has a default value of [EdgeInsets.zero].
  final EdgeInsetsGeometry actionsPadding;

  /// A horizontal alignment of the [actions].
  ///
  /// Has a default value of [MainAxisAlignment.start].
  final MainAxisAlignment actionsAlignment;

  /// Creates a [MetricsDialog].
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
                  child: const Icon(Icons.close),
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
