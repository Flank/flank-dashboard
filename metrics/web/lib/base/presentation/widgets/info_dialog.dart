import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list.dart';

/// The widget that displays a specific version of the [Dialog].
class InfoDialog extends StatelessWidget {
  /// A background color of this dialog.
  final Color backgroundColor;

  /// An empty space between the main content and dialog's edges.
  final EdgeInsetsGeometry padding;

  /// A max width of this dialog.
  final double maxWidth;

  /// A text title of this dialog.
  final Widget title;

  /// An empty space that surrounds the [title].
  final EdgeInsetsGeometry titlePadding;

  /// A content of this dialog.
  final Widget content;

  /// An empty space that surrounds the [content].
  final EdgeInsetsGeometry contentPadding;

  /// An action bar at the bottom of this dialog.
  final List<Widget> actions;

  /// An empty space that surrounds the [actions].
  final EdgeInsetsGeometry actionsPadding;

  /// A horizontal alignment of the [actions].
  final MainAxisAlignment actionsAlignment;

  /// Creates an [InfoDialog].
  ///
  /// The [padding], the [titlePadding], the [contentPadding]
  /// and the [actionsPadding] default value is [EdgeInsets.zero].
  /// The [actionsAlignment] default value is [MainAxisAlignment.start].
  /// The [maxWidth] default value is 500.0.
  ///
  /// [title], [content], [actions] and [maxWidth] must not be null.
  const InfoDialog({
    Key key,
    @required this.title,
    @required this.actions,
    this.content,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.titlePadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsAlignment = MainAxisAlignment.start,
    this.maxWidth = 500.0,
  })  : assert(title != null),
        assert(actions != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
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
            Flexible(
              child: Padding(
                padding: contentPadding,
                child: content,
              ),
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
