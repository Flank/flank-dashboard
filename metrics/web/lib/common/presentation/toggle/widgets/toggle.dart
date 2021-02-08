// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A toggle widget providing an ability to enable or disable state
/// by changing the [value].
class Toggle extends StatelessWidget {
  /// Indicates whether this toggle is enabled or not.
  final bool value;

  /// A [ValueChanged] callback used to notify about [value] changed.
  final ValueChanged<bool> onToggle;

  /// Creates a new instance of the [Toggle].
  ///
  /// The [value] must not be null.
  const Toggle({
    Key key,
    @required this.value,
    this.onToggle,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final toggleTheme = MetricsTheme.of(context).toggleTheme;

    return TappableArea(
      builder: (context, isHovered, child) {
        final inactiveColor = isHovered
            ? toggleTheme.inactiveHoverColor
            : toggleTheme.inactiveColor;
        final activeColor =
            isHovered ? toggleTheme.activeHoverColor : toggleTheme.activeColor;

        return FlutterSwitch(
          width: 35.0,
          height: 20.0,
          toggleSize: 16.0,
          padding: 2.0,
          onToggle: onToggle,
          value: value,
          inactiveColor: inactiveColor,
          activeColor: activeColor,
        );
      },
    );
  }
}
