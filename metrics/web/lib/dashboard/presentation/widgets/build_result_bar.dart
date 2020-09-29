import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/base/presentation/widgets/circle_graph_indicator.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/dashboard_popup_card.dart';
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

  /// A height of this bar.
  final double barHeight;

  /// Creates the [BuildResultBar] with the given [buildResult].
  const BuildResultBar({Key key, this.buildResult, this.barHeight})
      : super(key: key);

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

  /// An outer diameter of the [CircleGraphIndicator].
  static const _circleOuterDiameter = 10.0;

  /// A [UniqueKey] for the [VisibilityDetector].
  final _uniqueKey = UniqueKey();

  /// Indicates whether the [CircleGraphIndicator] is visible.
  bool _isCircleIndicatorVisible = true;

  @override
  Widget build(BuildContext context) {
    const circleOuterRadius = _circleOuterDiameter / 2.0;
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
            ? height - widget.barHeight + _topPadding + circleOuterRadius
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
              final hoverColor =
                  isHovered ? barColor.withOpacity(0.25) : Colors.transparent;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: _barWidth,
                    color: hoverColor,
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: widget.barHeight,
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
                    bottom: widget.barHeight - circleOuterRadius,
                    child: VisibilityDetector(
                      key: _uniqueKey,
                      onVisibilityChanged: (VisibilityInfo info) {
                        _isCircleIndicatorVisible = info.visibleFraction != 0.0;

                        if (isHovered) {
                          closePopup();
                          openPopup();
                        }
                      },
                      child: Opacity(
                        opacity: isHovered ? 1.0 : 0.0,
                        child: CircleGraphIndicator(
                          outerDiameter: _circleOuterDiameter,
                          innerDiameter: 4.0,
                          outerColor: Colors.white,
                          innerColor: barColor,
                        ),
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
  }

  /// Selects the color from the [widgetTheme] based on [buildStatus].
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
