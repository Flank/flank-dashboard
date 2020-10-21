import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/neutral_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/negative_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/positive_graph_indicator.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/colored_bar/widgets/metrics_colored_bar.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_appearance_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:url_launcher/url_launcher.dart';

/// A single bar for a [BarGraph] widget that displays the
/// result of a [BuildResultViewModel] instance.
///
/// Displays the [PlaceholderBar] if either [buildResult] or
/// [BuildResultViewModel.buildStatus] is `null`.
class BuildResultBar extends StatefulWidget {
  /// A [BuildResultViewModel] with data to display.
  final BuildResultViewModel buildResult;

  /// A class that provides an [EdgeInsets] padding to apply to this bar based
  /// on the [buildResult] position among other results.
  final BuildResultBarPaddingStrategy strategy;

  /// Creates the [BuildResultBar] with the given [buildResult].
  const BuildResultBar({
    Key key,
    this.buildResult,
    this.strategy,
  }) : super(key: key);

  @override
  _BuildResultBarState createState() => _BuildResultBarState();
}

class _BuildResultBarState extends State<BuildResultBar> {
  /// A width of the [BasePopup.popup].
  static const double _popupWidth = 162.0;

  /// A strategy for this bar appearance.
  final _strategy = const BuildResultBarAppearanceStrategy();

  /// An [EdgeInsets] to apply to this bar.
  EdgeInsets get _barPadding {
    return widget.strategy.getBarPadding(widget.buildResult);
  }

  /// A [GraphIndicator] widget to use based on the [BuildResultBar.buildResult].
  Widget get _graphIndicator {
    switch (widget.buildResult?.buildStatus) {
      case BuildStatus.successful:
        return const PositiveGraphIndicator();
      case BuildStatus.failed:
        return const NegativeGraphIndicator();
      case BuildStatus.unknown:
        return const NeutralGraphIndicator();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    const indicatorRadius = DimensionsConfig.graphIndicatorOuterDiameter / 2.0;

    if (widget.buildResult == null) {
      final inactiveTheme = MetricsTheme.of(context).inactiveWidgetTheme;
      return PlaceholderBar(
        width: DimensionsConfig.graphBarWidth,
        height: 4.0,
        color: inactiveTheme.primaryColor,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final barHeight = constraints.minHeight;

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
                onTap: _onBarTap,
                child: Padding(
                  padding: _barPadding,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      MetricsColoredBar<BuildStatus>(
                        isHovered: isOpened,
                        height: barHeight,
                        strategy: _strategy,
                        value: widget.buildResult.buildStatus,
                      ),
                      if (isOpened)
                        Positioned(
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
            buildResultPopupViewModel: widget.buildResult,
          ),
        );
      },
    );
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
  Future<void> _onBarTap() async {
    final url = widget.buildResult.url;
    if (url == null) return;

    final canLaunchUrl = await canLaunch(url);

    if (canLaunchUrl) {
      await launch(url);
    }
  }
}
