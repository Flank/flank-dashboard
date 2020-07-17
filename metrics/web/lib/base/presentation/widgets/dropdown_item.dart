import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_menu.dart';

/// A widget that used with a [DropdownMenu] to display the dropdown
/// items that can be selected.
///
/// Changes it's background color on pointer hover changed
/// from [backgroundColor] to [hoverColor] and vice versa.
class DropdownItem extends StatefulWidget {
  /// A child widget to display.
  final Widget child;

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

  /// Creates the [DropdownItem].
  ///
  /// The [child] must not be `null`.
  const DropdownItem({
    Key key,
    @required this.child,
    this.width,
    this.height,
    this.alignment,
    this.padding,
    this.backgroundColor,
    this.hoverColor,
  })  : assert(child != null),
        super(key: key);

  @override
  _DropdownItemState createState() => _DropdownItemState();
}

class _DropdownItemState extends State<DropdownItem> {
  /// Indicates whether this widget is hovered or not.
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = _isHovered ? widget.hoverColor : widget.backgroundColor;

    return MouseRegion(
      onEnter: (_) => _changeHover(true),
      onExit: (_) => _changeHover(false),
      child: Container(
        width: widget.width,
        height: widget.height,
        color: color,
        padding: widget.padding,
        alignment: widget.alignment,
        child: widget.child,
      ),
    );
  }

  /// Changes [_isHovered] value to the given [value].
  void _changeHover(bool value) {
    setState(() => _isHovered = value);
  }
}
