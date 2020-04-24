import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';

/// Represents the placeholder bar of the [BarGraph].
class PlaceholderBar extends StatelessWidget {
  final double width;

  /// Creates the [PlaceholderBar].
  ///
  /// This bar displays the missing/empty build in [BarGraph].
  /// [width] is the width of this bar.
  ///
  /// Applies the colors from the [MetricsThemeData.inactiveWidgetTheme].
  const PlaceholderBar({
    Key key,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetTheme = MetricsTheme.of(context).inactiveWidgetTheme;

    return Container(
      alignment: Alignment.bottomCenter,
      height: 6.0,
      child: ColoredBar(
        color: widgetTheme.primaryColor,
        width: width,
        border: Border.all(
          color: widgetTheme.primaryColor,
          width: 2.0,
        ),
      ),
    );
  }
}
