// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_menu.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

/// A widget that used with a [DropdownMenu] to display the dropdown
/// items that can be selected.
///
/// Changes it's background color on hover from [backgroundColor] to [hoverColor].
class DropdownItem extends StatelessWidget {
  /// A builder function used to build the child widget depending on the hover
  /// status of this widget.
  final Widget Function(BuildContext, bool) builder;

  /// A width of this widget.
  final double width;

  /// A height of this widget.
  final double height;

  /// An alignment of this widget.
  final Alignment alignment;

  /// A padding of this widget.
  final EdgeInsets padding;

  /// A background [Color] of the widget, when hovered [hoverColor] is used instead.
  final Color backgroundColor;

  /// A background [Color] of the widget if it is hovered.
  final Color hoverColor;

  /// Creates a widget that displays a dropdown item of the [DropdownMenu].
  ///
  /// The [builder] must not be `null`.
  const DropdownItem({
    Key key,
    @required this.builder,
    this.width,
    this.height,
    this.alignment,
    this.padding,
    this.backgroundColor,
    this.hoverColor,
  })  : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      builder: (context, isHovered, _) {
        final color = isHovered ? hoverColor : backgroundColor;

        return Container(
          width: width,
          height: height,
          color: color,
          padding: padding,
          alignment: alignment,
          child: builder(context, isHovered),
        );
      },
    );
  }
}
