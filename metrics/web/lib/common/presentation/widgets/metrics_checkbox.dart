// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

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

    return TappableArea(
      onTap: () => onChanged?.call(!value),
      builder: (_, __, child) => child,
      child: AnimatedCrossFade(
        crossFadeState: state,
        duration: const Duration(milliseconds: 100),
        firstChild: SvgImage(
          isHovered ? 'icons/check-box-hovered.svg' : 'icons/check-box.svg',
          width: 20.0,
          height: 20.0,
          fit: BoxFit.contain,
        ),
        secondChild: SvgImage(
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
