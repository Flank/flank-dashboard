import 'package:flutter/material.dart';

/// A widget that displays a metrics styled checkbox.
class MetricsCheckbox extends StatelessWidget {
  /// Indicates whether this checkbox is checked.
  final bool value;

  /// The callback that is called when the checkbox has tapped.
  final ValueChanged<bool> onChanged;

  /// Indicates whether checkbox is hovered or not.
  final bool isHovered;

  /// Creates a new metrics checkbox instance.
  ///
  /// [isHovered] defaults to `false`.
  ///
  /// The [value] and [isHovered] must not be null.
  const MetricsCheckbox({
    Key key,
    @required this.value,
    this.onChanged,
    this.isHovered = false,
  })  : assert(value != null),
        assert(isHovered != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = value ? CrossFadeState.showFirst : CrossFadeState.showSecond;

    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedCrossFade(
        crossFadeState: state,
        duration: const Duration(milliseconds: 100),
        firstChild: Image.network(
          isHovered ? 'icons/check-box-hovered.svg' : 'icons/check-box.svg',
          width: 20.0,
          height: 20.0,
          fit: BoxFit.contain,
        ),
        secondChild: Image.network(
          isHovered
              ? 'icons/check-box-blank-hovered.svg'
              : 'icons/check-box-blank.svg',
          width: 20.0,
          height: 20.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
