import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metrics/base/presentation/decoration/bubble_shape_border.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_style.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';

/// A widget that displays a metrics result bar popup with specific shape.
class MetricsResultBarPopupCard extends StatelessWidget {
  final BuildResultPopupViewModel buildResultPopupViewModel;

  /// Creates the [MetricsResultBarPopupCard] with the given [buildResult].
  const MetricsResultBarPopupCard({
    Key key,
    @required this.buildResultPopupViewModel,
  })  : assert(buildResultPopupViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const arrowWidth = 10.0;
    const arrowHeight = 5.0;
    final dateFormat = DateFormat('EEEE, MMM d').format(
      buildResultPopupViewModel.startDate,
    );
    final duration = Duration(milliseconds: buildResultPopupViewModel.value);

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 8.0),
            blurRadius: 12.0,
            color: Color.fromRGBO(0, 0, 0, 0.32),
          ),
        ],
      ),
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.zero,
        color: const Color(0xfff5f5ff),
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
                  style: const MetricsTextStyle(
                    color: Color(0xff8e8e99),
                    lineHeightInPixels: 16.0,
                    fontSize: 13.0,
                  ),
                ),
              ),
              Text(
                _formatDuration(duration),
                style: const MetricsTextStyle(
                  color: Color(0xff1b1b1d),
                  lineHeightInPixels: 16.0,
                  fontSize: 13.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final twoDigitMinutes = duration.inMinutes.remainder(60);
    final twoDigitSeconds = duration.inSeconds.remainder(60);

    return "$twoDigitMinutes m $twoDigitSeconds s";
  }
}