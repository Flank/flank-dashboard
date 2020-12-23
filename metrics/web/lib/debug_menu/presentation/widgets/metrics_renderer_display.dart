import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/debug_menu/presentation/view_models/rendered_display_view_model.dart';

/// A widget that displays the current renderer.
class MetricsRendererDisplay extends StatelessWidget {
  /// A [RendererDisplayViewModel] with the current renderer to display.
  final RendererDisplayViewModel rendererDisplayViewModel;

  /// Creates a new instance of the [MetricsRendererDisplay]
  /// with the given [rendererDisplayViewModel].
  const MetricsRendererDisplay({
    Key key,
    this.rendererDisplayViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).debugMenuTheme;
    final contentTextStyle = theme.sectionContentTextStyle;
    final currentRenderer = rendererDisplayViewModel.currentRenderer;

    return Text(
      CommonStrings.getCurrentRenderer(currentRenderer),
      style: contentTextStyle,
    );
  }
}
