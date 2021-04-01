// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/negative_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/neutral_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/positive_graph_indicator.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays the [BuildResultBar], a corresponding [GraphIndicator]
/// and a [BuildResultPopupCard].
class BuildResultBarComponent extends StatelessWidget {
  /// A width of the [BuildResultPopupCard] this bar component displays
  /// in a popup.
  static const double _popupWidth = 162.0;

  /// A [BuildResultViewModel] with data to display.
  final BuildResultViewModel buildResult;

  /// A class that provides an [EdgeInsets] padding to apply to this bar based
  /// on the [buildResult] position among other results.
  final BuildResultBarPaddingStrategy paddingStrategy;

  /// Creates a new instance of the [BuildResultBarComponent] with the given
  /// [buildResult] and [paddingStrategy].
  const BuildResultBarComponent({
    Key key,
    this.paddingStrategy,
    this.buildResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const barWidth = DimensionsConfig.graphBarWidth;
    const indicatorDiameter = DimensionsConfig.graphIndicatorOuterDiameter;
    const indicatorRadius = indicatorDiameter / 2.0;
    const indicatorHorizontalOffset = (barWidth - indicatorDiameter) / 2.0;

    if (buildResult == null) {
      final inactiveTheme = MetricsTheme.of(context).inactiveWidgetTheme;

      return PlaceholderBar(
        width: barWidth,
        height: 4.0,
        color: inactiveTheme.primaryColor,
      );
    }

    return BasePopup(
      popupOpaque: false,
      closeOnTapOutside: false,
      popupConstraints: const BoxConstraints(
        minWidth: _popupWidth,
        maxWidth: _popupWidth,
      ),
      offsetBuilder: (triggerSize) => _calculatePopupOffset(
        triggerSize,
        indicatorRadius,
      ),
      triggerBuilder: (context, openPopup, closePopup, isOpened) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => openPopup(),
          onExit: (_) => closePopup(),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTap,
            child: Padding(
              padding: _barPadding,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.passthrough,
                children: [
                  BuildResultBar(
                    buildResult: buildResult,
                  ),
                  if (isOpened)
                    Positioned(
                      right: indicatorHorizontalOffset,
                      bottom: -indicatorRadius,
                      child: _graphIndicator,
                    ),
                ],
              ),
            ),
          ),
        );
      },
      popup: BuildResultPopupCard(
        buildResultPopupViewModel: buildResult.buildResultPopupViewModel,
      ),
    );
  }

  /// A [GraphIndicator] widget to use based on the [buildResult.buildStatus].
  Widget get _graphIndicator {
    switch (buildResult?.buildStatus) {
      case BuildStatus.successful:
        return const PositiveGraphIndicator();
      case BuildStatus.failed:
        return const NegativeGraphIndicator();
      case BuildStatus.unknown:
        return const NeutralGraphIndicator();
      case BuildStatus.inProgress:
        return const NeutralGraphIndicator();
    }

    return null;
  }

  /// An [EdgeInsets] to apply to this bar component.
  EdgeInsets get _barPadding {
    return paddingStrategy.getBarPadding(buildResult);
  }

  /// Calculates the [Offset] for the bar popup.
  Offset _calculatePopupOffset(
    Size triggerSize,
    double indicatorRadius,
  ) {
    final paddingOffset = _barPadding.left - _barPadding.right;
    final dx = triggerSize.width / 2 - _popupWidth / 2 + paddingOffset / 2;
    final dy = triggerSize.height + indicatorRadius + 4.0;

    return Offset(dx, dy);
  }

  /// Opens the [BuildResultViewModel.url].
  Future<void> _onTap() async {
    final url = buildResult.url;
    if (url == null) return;

    final canLaunchUrl = await canLaunch(url);

    if (canLaunchUrl) {
      await launch(url);
    }
  }
}
