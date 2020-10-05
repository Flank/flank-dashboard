import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/base/presentation/widgets/circle_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/cancelled_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/failed_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/successful_graph_indicator.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/colored_bar/widgets/metrics_colored_bar.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_style_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A single bar for a [BarGraph] widget that displays the
/// result of a [BuildResultViewModel] instance.
///
/// Displays the [PlaceholderBar] if either [buildResult] or
/// [BuildResultViewModel.buildStatus] is `null`.
class BuildResultBar extends StatefulWidget {
  /// A [BuildResultViewModel] with data to display.
  final BuildResultViewModel buildResult;

  /// A strategy for this bar appearance.
  final BuildResultBarAppearanceStrategy strategy;

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
  static const double _popupWidth = 146.0;

  /// A top padding of the [BasePopup.popup] from the [CircleGraphIndicator].
  static const double _topPadding = 4.0;

  /// A [UniqueKey] for the [VisibilityDetector].
  final UniqueKey _uniqueKey = UniqueKey();

  /// Indicates whether the [CircleGraphIndicator] is visible.
  bool _isIndicatorVisible = true;

  /// A [GraphIndicator] widget to use based on the [BuildResultBar.buildResult].
  Widget get _graphIndicator {
    switch (widget.buildResult.buildStatus) {
      case BuildStatus.successful:
        return const SuccessfulGraphIndicator();
      case BuildStatus.cancelled:
        return const CancelledGraphIndicator();
      case BuildStatus.failed:
        return const FailedGraphIndicator();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const radius = DimensionsConfig.graphIndicatorOuterDiameter / 2.0;
    final metricsTheme = MetricsTheme.of(context);

    if (widget.buildResult == null || widget.buildResult.buildStatus == null) {
      final inactiveTheme = metricsTheme.inactiveWidgetTheme;
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
          offsetBuilder: (Size childSize) {
            final height = childSize.height;
            final dx = childSize.width / 2.0 - _popupWidth / 2.0;
            final dy = _isIndicatorVisible
                ? height - barHeight + radius + _topPadding
                : height;

            return Offset(dx, dy);
          },
          triggerBuilder: (context, openPopup, closePopup, isOpened) {
            return MouseRegion(
              onEnter: (_) => openPopup(),
              onExit: (_) => closePopup(),
              child: InkWell(
                onTap: _onBarTap,
                hoverColor: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    MetricsColoredBar<BuildStatus>(
                      isHovered: isOpened,
                      height: barHeight,
                      strategy: widget.strategy,
                      value: widget.buildResult.buildStatus,
                    ),
                    Positioned(
                      bottom: barHeight - radius,
                      child: VisibilityDetector(
                        key: _uniqueKey,
                        onVisibilityChanged: (VisibilityInfo info) {
                          final visible = info.visibleFraction != 0.0;
                          final shouldReopen =
                              visible != _isIndicatorVisible && isOpened;
                          _setIndicatorVisibility(visible);

                          if (shouldReopen) {
                            closePopup();
                            openPopup();
                          }
                        },
                        child: Opacity(
                          opacity: isOpened ? 1.0 : 0.0,
                          child: _graphIndicator,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          popup: BuildResultPopupCard(
            buildResultPopupViewModel:
                widget.buildResult.buildResultPopupViewModel,
          ),
        );
      },
    );
  }

  /// Sets the [_isIndicatorVisible] to the given [value].
  void _setIndicatorVisibility(bool value) {
    if (mounted) {
      setState(() => _isIndicatorVisible = value);
    }
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
