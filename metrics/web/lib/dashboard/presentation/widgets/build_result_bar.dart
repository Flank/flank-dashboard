import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
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
  /// A width of this bar.
  static const double _barWidth = 10.0;

  /// A border radius of this bar.
  static const _borderRadius = Radius.circular(1.0);

  /// A [BuildResultViewModel] to display.
  final BuildResultViewModel buildResult;

  final double barHeight;

  /// Creates the [BuildResultBar] with the given [buildResult].
  const BuildResultBar({Key key, this.buildResult, this.barHeight})
      : super(key: key);

  @override
  _BuildResultBarState createState() => _BuildResultBarState();
}

class _BuildResultBarState extends State<BuildResultBar> {
  final _uniqueKey = UniqueKey();
  bool _showPopupCorrect = false;

  @override
  void initState() {
    super.initState();

    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    final metricsTheme = MetricsTheme.of(context);
    final widgetThemeData = metricsTheme.buildResultTheme;

    if (widget.buildResult == null || widget.buildResult.buildStatus == null) {
      final inactiveTheme = metricsTheme.inactiveWidgetTheme;
      return PlaceholderBar(
        width: BuildResultBar._barWidth,
        height: 4.0,
        color: inactiveTheme.primaryColor,
      );
    }

    final barColor = _getBuildResultColor(
      widget.buildResult.buildStatus,
      widgetThemeData,
    );

    return BasePopup(
      popupOpaque: false,
      closePopupWhenTapOutside: false,
      popupConstraints: const BoxConstraints(
        minWidth: 146.0,
        maxWidth: 146.0,
      ),
      popupMouseCursor: SystemMouseCursors.click,
      offsetBuilder: (Size childSize) {
        final dx = childSize.width / 2 - 146.0 / 2;
        final dy = _showPopupCorrect
            ? childSize.height
            : childSize.height - widget.barHeight + 9.0;

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
                    width: BuildResultBar._barWidth,
                    color: hoverColor,
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: widget.barHeight,
                      child: ColoredBar(
                        width: BuildResultBar._barWidth,
                        borderRadius: const BorderRadius.only(
                          topLeft: BuildResultBar._borderRadius,
                          topRight: BuildResultBar._borderRadius,
                        ),
                        color: _getBuildResultColor(
                          widget.buildResult.buildStatus,
                          widgetThemeData,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: widget.barHeight - 5.0,
                    child: VisibilityDetector(
                      key: _uniqueKey,
                      onVisibilityChanged: (VisibilityInfo info) {
                        _showPopupCorrect = info.visibleFraction == 0.0;

                        if(isHovered) {
                          print(_showPopupCorrect);
                          closePopup();
                          openPopup();
                        }
                      },
                      child: Opacity(
                        opacity: isHovered ? 1.0 : 0.0,
                        child: CircleGraphIndicator(
                          color: _getBuildResultColor(
                            widget.buildResult.buildStatus,
                            widgetThemeData,
                          ),
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
      popup: GestureDetector(
        onTap: _onBarTap,
        child: MetricsResultBarPopupCard(
          buildResultPopupViewModel: widget.buildResult.buildResultPopupViewModel,
        ),
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

  @override
  void dispose() {
    print('DISPOSE');
    super.dispose();
  }
}

class CircleGraphIndicator extends StatelessWidget {
  final Color color;

  const CircleGraphIndicator({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 10.0,
      width: 10.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Container(
        height: 4.0,
        width: 4.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
