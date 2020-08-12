import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that display the text placeholder.
///
/// Applies the text style from the [MetricsThemeData.textPlaceholderTheme].
class TextPlaceholder extends StatelessWidget {
  /// A text to display.
  final String text;

  /// Creates a [TextPlaceholder].
  ///
  /// The [text] must not be null.
  const TextPlaceholder({
    Key key,
    @required this.text,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholderTheme = MetricsTheme.of(context).textPlaceholderTheme;

    return Text(
      text,
      textAlign: TextAlign.center,
      style: placeholderTheme.textStyle,
    );
  }
}
