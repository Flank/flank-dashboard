import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/constants/mouse_cursor.dart';
import 'package:metrics/base/presentation/widgets/dropdown_menu.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

/// A widget that used with a [DropdownMenu] to display the dropdown
/// items that can be selected.
///
/// Changes it's background color on hover from [backgroundColor] to [hoverColor].
class DropdownItem extends StatefulWidget {
  /// A child widget to display.
  final Widget child;

  /// A child widget to display when this [DropdownItem] is hovered.
  final Widget hoverChild;

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
  /// The [child] must not be `null`.
  const DropdownItem({
    Key key,
    @required this.child,
    @required this.hoverChild,
    this.width,
    this.height,
    this.alignment,
    this.padding,
    this.backgroundColor,
    this.hoverColor,
  })  : assert(child != null),
        assert(hoverChild != null),
        super(key: key);

  @override
  _DropdownItemState createState() => _DropdownItemState();
}

class _DropdownItemState extends State<DropdownItem> {
  @override
  Widget build(BuildContext context) {
    return TappableArea(
      mouseCursor: MouseCursor.click,
      builder: (context, bool isHovered) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: isHovered ? widget.hoverColor : widget.backgroundColor,
          padding: widget.padding,
          alignment: widget.alignment,
          child: isHovered ? widget.hoverChild : widget.child,
        );
      },
    );
  }
}
