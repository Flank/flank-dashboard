import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

/// A widget that displays the button with given [icon] and [label] text.
class IconLabelButton extends StatelessWidget {
  /// The callback that is called when the button is tapped.
  final VoidCallback onPressed;

  /// The padding around this button.
  final EdgeInsets contentPadding;

  /// The clipping radius of the containing rect.
  final BorderRadius borderRadius;

  /// The icon this button is to display.
  final Widget icon;

  /// The padding around the [icon].
  final EdgeInsets iconPadding;

  /// The label this button is to display.
  final String label;

  /// The [TextStyle] of the [label].
  final TextStyle labelStyle;

  /// Creates a new instance of the [IconLabelButton].
  ///
  /// Both [iconPadding] and [contentPadding] defaults to [EdgeInsets.zero].
  /// The [borderRadius] defaults to [BorderRadius.zero].
  ///
  /// The [label] and [icon] must not be null.
  const IconLabelButton({
    Key key,
    @required this.label,
    @required this.icon,
    this.iconPadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
    this.onPressed,
    this.labelStyle,
  })  : assert(label != null),
        assert(icon != null),
        assert(contentPadding != null),
        assert(iconPadding != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      onTap: onPressed,
      builder: (context, isHovered, child) => child,
      child: Padding(
        padding: contentPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: iconPadding,
              child: icon,
            ),
            Text(
              label,
              style: labelStyle,
            ),
          ],
        ),
      ),
    );
  }
}
