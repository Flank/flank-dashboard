// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

/// The widget that displays a specific version of the [Dialog].
class InfoDialog extends StatelessWidget {
  /// A shape of this dialog's border.
  final ShapeBorder shape;

  /// A background color of this dialog.
  final Color backgroundColor;

  /// A widget that is displayed as a close button for this dialog.
  final Widget closeIcon;

  /// An empty space between the main content and dialog's edges.
  final EdgeInsetsGeometry padding;

  /// An empty space that surrounds the [closeIcon].
  final EdgeInsetsGeometry closeIconPadding;

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

  /// A [BoxConstraints] to apply to this dialog.
  final BoxConstraints constraints;

  /// Creates an [InfoDialog].
  ///
  /// The [padding], the [titlePadding], the [contentPadding]
  /// and the [actionsPadding] and the [closeIconPadding]
  /// default value is [EdgeInsets.zero].
  ///
  /// The [actionsAlignment] default value is [MainAxisAlignment.start].
  /// If the [closeIcon] is null, the [Icon] with [Icons.close] is used.
  /// The [shape] default value is a [RoundedRectangleBorder] default instance.
  ///
  /// The [title] and [actions] must not be null.
  const InfoDialog({
    Key key,
    Widget closeIcon,
    @required this.title,
    @required this.actions,
    this.shape = const RoundedRectangleBorder(),
    this.content,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.titlePadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.actionsPadding = EdgeInsets.zero,
    this.closeIconPadding = EdgeInsets.zero,
    this.actionsAlignment = MainAxisAlignment.start,
    this.constraints,
  })  : assert(title != null),
        assert(actions != null),
        closeIcon = closeIcon ?? const Icon(Icons.close),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: shape,
      backgroundColor: backgroundColor,
      child: Container(
        constraints: constraints,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
            Positioned(
              right: 0.0,
              top: 0.0,
              child: Padding(
                padding: closeIconPadding,
                child: TappableArea(
                  onTap: () => Navigator.of(context).pop(),
                  builder: (context, isHovered, child) => child,
                  child: closeIcon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
