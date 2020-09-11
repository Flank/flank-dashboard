import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/constants/mouse_cursor.dart';
import 'package:metrics/base/presentation/widgets/dropdown_menu.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

/// A widget that used with a [DropdownMenu] to display the dropdown
/// items that can be selected.
///
/// Changes it's background color on hover from [backgroundColor] to [hoverColor].
class DropdownItem extends StatefulWidget {
  /// A builder function used to build the child widget depending on the hover
  /// status of this widget.
  final HoverWidgetBuilder builder;

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
  _DropdownItemState createState() => _DropdownItemState();
}

class _DropdownItemState extends State<DropdownItem> {
  @override
  Widget build(BuildContext context) {
    return TappableArea(
      mouseCursor: MouseCursor.click,
      builder: (context, isHovered) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: isHovered ? widget.hoverColor : widget.backgroundColor,
          padding: widget.padding,
          alignment: widget.alignment,
          child: widget.builder(context, isHovered),
        );
      },
    );
  }
}
