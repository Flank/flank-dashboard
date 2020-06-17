import 'package:flutter/material.dart';

/// The widget that represents a specific version of [Dialog].
class InfoDialog extends StatelessWidget {
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

  /// Creates a [InfoDialog].
  ///
  /// [title], [content], [actions] and [maxWidth] must not be null.
  const InfoDialog({
    @required this.title,
    this.content,
    @required this.actions,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.titlePadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsAlignment = MainAxisAlignment.start,
    this.maxWidth = 500.0,
  })  : assert(title != null),
        assert(actions != null);

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
                child: content ?? Container(),
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
