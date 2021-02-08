// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/tooltip_icon/widgets/tooltip_icon.dart';

/// A widget that displays a [title] and [TooltipIcon] popup with
/// a [tooltip] text and an image from [src].
class TooltipTitle extends StatelessWidget {
  /// A title of the tooltip.
  final String title;

  /// A tooltip text to display.
  final String tooltip;

  /// A source of the icon to display.
  final String src;

  /// Creates a new instance of the [TooltipTitle].
  ///
  /// The [tooltip], [title] and [src] must not be `null`.
  const TooltipTitle({
    Key key,
    @required this.title,
    @required this.tooltip,
    @required this.src,
  })  : assert(title != null),
        assert(tooltip != null),
        assert(src != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final metricsTableHeaderTheme = MetricsTheme.of(context)
        .projectMetricsTableTheme
        .metricsTableHeaderTheme;
    final textStyle = metricsTableHeaderTheme.textStyle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Text(
              title,
              style: textStyle,
            ),
          ),
        ),
        TooltipIcon(
          src: src,
          tooltip: tooltip,
        ),
      ],
    );
  }
}
