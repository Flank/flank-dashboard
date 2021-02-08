// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/decoration/bubble_shape_border.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that displays a tooltip popup with specific shape.
class TooltipPopup extends StatelessWidget {
  /// A tooltip text to display.
  final String tooltip;

  /// Create a new instance of the [TooltipPopup].
  ///
  /// The [tooltip] must not be `null`.
  const TooltipPopup({
    Key key,
    @required this.tooltip,
  })  : assert(tooltip != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const arrowWidth = 10.0;
    const arrowHeight = 5.0;
    final theme = MetricsTheme.of(context).tooltipPopupTheme;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 8.0),
            blurRadius: 12.0,
            color: theme.shadowColor,
          ),
        ],
      ),
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.zero,
        color: theme.backgroundColor,
        shape: BubbleShapeBorder(
          borderRadius: BorderRadius.circular(1.0),
          arrowSize: const Size(arrowWidth, arrowHeight),
          position: BubblePosition.top,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ).copyWith(top: 14.0 + arrowHeight),
          child: Text(
            tooltip,
            style: theme.textStyle,
          ),
        ),
      ),
    );
  }
}
