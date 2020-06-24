import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/text_placeholder.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that display the metrics placeholder.
///
/// Applies the text style from the [MetricsThemeData.inactiveWidgetTheme].
class MetricsTextPlaceholder extends StatelessWidget {
  /// A text to display.
  final String text;

  /// Creates a [MetricsTextPlaceholder].
  ///
  /// Throws an [AssertionError] is the given text is null.
  const MetricsTextPlaceholder({
    Key key,
    @required this.text,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final inactiveTheme = MetricsTheme.of(context).inactiveWidgetTheme;

    return TextPlaceholder(
      text: text,
      style: inactiveTheme.textStyle,
    );
  }
}
