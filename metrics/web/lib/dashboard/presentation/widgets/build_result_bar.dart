import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/base/presentation/widgets/circle_graph_indicator.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/circle_graph_indicator/widgets/metrics_cancelled_circle_graph_indicator.dart';
import 'package:metrics/common/presentation/circle_graph_indicator/widgets/metrics_failed_circle_graph_indicator.dart';
import 'package:metrics/common/presentation/circle_graph_indicator/widgets/metrics_successful_circle_graph_indicator.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_result_bar_popup_card.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A single bar for a [BarGraph] widget that displays the
/// result of a [BuildResultViewModel] instance.
///
/// Displays the [PlaceholderBar] if either [buildResult] or
/// [BuildResultViewModel.buildStatus] is `null`.
class BuildResultBar extends StatefulWidget {
  /// A [BuildResultViewModel] to display.
  final BuildResultViewModel buildResult;

  /// Creates the [BuildResultBar] with the given [buildResult].
  const BuildResultBar({Key key, this.buildResult}) : super(key: key);

  @override
  _BuildResultBarState createState() => _BuildResultBarState();
}

class _BuildResultBarState extends State<BuildResultBar> {
  /// A border radius of this bar.
  static const _borderRadius = Radius.circular(1.0);

  /// A width of this bar.
  static const _barWidth = 10.0;

  /// A width of the [BasePopup.popup].
  static const _popupWidth = 146.0;

  /// A top padding of the [BasePopup.popup] from the [CircleGraphIndicator].
  static const _topPadding = 4.0;

  /// A [UniqueKey] for the [VisibilityDetector].
  final _uniqueKey = UniqueKey();

  /// Indicates whether the [CircleGraphIndicator] is visible.
  bool _isCircleIndicatorVisible = true;

  @override
  Widget build(BuildContext context) {
    const radius = DimensionsConfig.circleGraphIndicatorOuterDiameter / 2.0;
    final metricsTheme = MetricsTheme.of(context);
    final widgetThemeData = metricsTheme.buildResultTheme;

    if (widget.buildResult == null || widget.buildResult.buildStatus == null) {
      final inactiveTheme = metricsTheme.inactiveWidgetTheme;
      return PlaceholderBar(
        width: _barWidth,
        height: 4.0,
        color: inactiveTheme.primaryColor,
      );
    }

    final barColor = _getBuildResultColor(
      widget.buildResult.buildStatus,
      widgetThemeData,
    );
    final barBackgroundColor = _getBuildResultBackgroundColor(
      widget.buildResult.buildStatus,
      widgetThemeData,
    );
    final circleGraphIndicator = _getCircleGraphIndicator(
      widget.buildResult.buildStatus,
    );

    return LayoutBuilder(builder: (
      BuildContext context,
      BoxConstraints constraints,
    ) {
      final barHeight = constraints.minHeight;

      return BasePopup(
        isPopupOpaque: false,
        closePopupWhenTapOutside: false,
        popupConstraints: const BoxConstraints(
          minWidth: _popupWidth,
          maxWidth: _popupWidth,
        ),
        offsetBuilder: (Size childSize) {
          final height = childSize.height;
          final dx = childSize.width / 2.0 - _popupWidth / 2.0;
          final dy = _isCircleIndicatorVisible
              ? height - barHeight + _topPadding + radius
              : height;

          return Offset(dx, dy);
        },
        triggerBuilder: (context, openPopup, closePopup, _) {
          return MouseRegion(
            onEnter: (_) => openPopup(),
            onExit: (_) => closePopup(),
            child: TappableArea(
              onTap: _onBarTap,
              builder: (context, isHovered, _) {
                final hoverColor = isHovered ? barBackgroundColor : null;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: _barWidth,
                      color: hoverColor,
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: barHeight,
                        child: ColoredBar(
                          width: _barWidth,
                          borderRadius: const BorderRadius.only(
                            topLeft: _borderRadius,
                            topRight: _borderRadius,
                          ),
                          color: barColor,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: barHeight - radius,
                      child: VisibilityDetector(
                        key: _uniqueKey,
                        onVisibilityChanged: (VisibilityInfo info) {
                          _isCircleIndicatorVisible =
                              info.visibleFraction != 0.0;

                          if (isHovered) {
                            closePopup();
                            openPopup();
                          }
                        },
                        child: Opacity(
                          opacity: isHovered ? 1.0 : 0.0,
                          child: circleGraphIndicator,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
        popup: MetricsResultBarPopupCard(
          dashboardPopupCardViewModel:
              widget.buildResult.dashboardPopupCardViewModel,
        ),
      );
    });
  }

  /// Selects the color for the bar from the [widgetTheme]
  /// based on [buildStatus].
  Color _getBuildResultColor(
    BuildStatus buildStatus,
    BuildResultsThemeData widgetTheme,
  ) {
    switch (buildStatus) {
      case BuildStatus.successful:
        return widgetTheme.successfulColor;
      case BuildStatus.cancelled:
        return widgetTheme.canceledColor;
      case BuildStatus.failed:
        return widgetTheme.failedColor;
      default:
        return null;
    }
  }

  /// Selects the color for the bar background from the [widgetTheme]
  /// based on [buildStatus].
  Color _getBuildResultBackgroundColor(
    BuildStatus buildStatus,
    BuildResultsThemeData widgetTheme,
  ) {
    switch (buildStatus) {
      case BuildStatus.successful:
        return widgetTheme.successfulBackgroundColor;
      case BuildStatus.cancelled:
        return widgetTheme.canceledBackgroundColor;
      case BuildStatus.failed:
        return widgetTheme.failedBackgroundColor;
      default:
        return null;
    }
  }

  /// Select the [MetricsCircleGraphIndicator] widget to use
  /// based on [buildStatus].
  Widget _getCircleGraphIndicator(BuildStatus buildStatus) {
    switch (buildStatus) {
      case BuildStatus.successful:
        return const MetricsSuccessfulCircleGraphIndicator();
      case BuildStatus.cancelled:
        return const MetricsCancelledCircleGraphIndicator();
      case BuildStatus.failed:
        return const MetricsFailedCircleGraphIndicator();
      default:
        return null;
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