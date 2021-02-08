// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metrics/base/presentation/decoration/bubble_shape_border.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/value_image/widgets/value_network_image.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_popup_image_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

/// A widget that displays a metrics result bar popup with specific shape.
class BuildResultPopupCard extends StatelessWidget {
  /// A [BuildResultPopupViewModel] with data to display.
  final BuildResultPopupViewModel buildResultPopupViewModel;

  /// Creates a new instance of the [BuildResultPopupCard].
  ///
  /// The [buildResultPopupViewModel] must not be `null`.
  const BuildResultPopupCard({
    Key key,
    @required this.buildResultPopupViewModel,
  })  : assert(buildResultPopupViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const arrowWidth = 10.0;
    const arrowHeight = 5.0;
    final theme = MetricsTheme.of(context).barGraphPopupTheme;
    final title = DateFormat('EEEE, MMM d').format(
      buildResultPopupViewModel.date,
    );
    final subtitle = CommonStrings.duration(buildResultPopupViewModel.duration);

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
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ).copyWith(top: 10.0 + arrowHeight),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueNetworkImage<BuildStatus>(
                width: 24.0,
                height: 24.0,
                value: buildResultPopupViewModel.buildStatus,
                strategy: const BuildResultPopupImageStrategy(),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          title,
                          style: theme.titleTextStyle,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.subtitleTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
