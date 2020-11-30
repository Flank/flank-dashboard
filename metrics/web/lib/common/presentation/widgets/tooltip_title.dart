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

  /// A source of the image to display.
  final String src;

  /// Creates a new instance of the [TooltipTitle].
  ///
  /// The [tooltip] and [title] must not be `null`.
  const TooltipTitle(
    this.src, {
    Key key,
    @required this.title,
    @required this.tooltip,
  })  : assert(title != null),
        assert(tooltip != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(right: 4.0);
    final metricsTableHeaderTheme = MetricsTheme.of(context)
        .projectMetricsTableTheme
        .metricsTableHeaderTheme;
    final textStyle = metricsTableHeaderTheme.textStyle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: padding,
            child: Text(
              title,
              style: textStyle,
            ),
          ),
        ),
        TooltipIcon(
          src,
          tooltip: tooltip,
        ),
        // add a field icon to the TooltipIcon
      ],
    );
  }
}
