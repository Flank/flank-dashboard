import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

/// A widget that displays the button with given [iconBuilder] and [labelBuilder] widgets.
class IconLabelButton extends StatelessWidget {
  /// The callback that is called when the button is tapped.
  final VoidCallback onPressed;

  /// The padding around this button.
  final EdgeInsets contentPadding;

  /// The builder of this button's icon.
  final HoverWidgetBuilder iconBuilder;

  /// The builder of this button's label.
  final HoverWidgetBuilder labelBuilder;

  /// The padding around the [iconBuilder].
  final EdgeInsets iconPadding;

  /// Creates a new instance of the [IconLabelButton].
  ///
  /// Both [iconPadding] and [contentPadding] defaults to [EdgeInsets.zero].
  ///
  /// The [labelBuilder] and [iconBuilder] must not be null.
  const IconLabelButton({
    Key key,
    @required this.labelBuilder,
    @required this.iconBuilder,
    this.iconPadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.onPressed,
  })  : assert(labelBuilder != null),
        assert(iconBuilder != null),
        assert(contentPadding != null),
        assert(iconPadding != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      onTap: onPressed,
      hitTestBehavior: HitTestBehavior.opaque,
      builder: (context, isHovered, _) {
        return Padding(
          padding: contentPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: iconPadding,
                child: iconBuilder(context, isHovered),
              ),
              labelBuilder(context, isHovered),
            ],
          ),
        );
      },
    );
  }
}
