import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metrics/base/presentation/decoration/bubble_shape_border.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/dashboard_popup_card_view_model.dart';

/// A widget that displays a metrics result bar popup with specific shape.
class MetricsResultBarPopupCard extends StatelessWidget {
  /// A [DashboardPopupCardViewModel] to display.
  final DashboardPopupCardViewModel buildResultPopupViewModel;

  /// Creates the [MetricsResultBarPopupCard] with the given [buildResult].
  ///
  /// The [buildResultPopupViewModel] must not be null.
  const MetricsResultBarPopupCard({
    Key key,
    @required this.buildResultPopupViewModel,
  })  : assert(buildResultPopupViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).barGraphPopupTheme;
    const arrowWidth = 10.0;
    const arrowHeight = 5.0;
    final dateFormat = DateFormat('EEEE, MMM d').format(
      buildResultPopupViewModel.startDate,
    );
    final duration = Duration(milliseconds: buildResultPopupViewModel.value);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 8.0),
            blurRadius: 12.0,
            color: theme.shadowColor,
          ),
        ],
      ),
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.zero,
        color: theme.color,
        shape: BubbleShapeBorder(
          borderRadius: BorderRadius.circular(1.0),
          arrowSize: const Size(arrowWidth, arrowHeight),
          position: BubblePosition.top,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: arrowHeight).add(
            const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 16.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  dateFormat,
                  style: theme.titleTextStyle,
                ),
              ),
              Text(
                CommonStrings.duration(duration),
                style: theme.subtitleTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
