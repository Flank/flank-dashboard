// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:metrics/base/presentation/decoration/bubble_shape_border.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/build_status_view.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_popup_asset_strategy.dart';
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
    final buildDuration = buildResultPopupViewModel.duration;
    final buildStatus =
        buildResultPopupViewModel.buildStatus ?? BuildStatus.unknown;

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
              BuildStatusView(
                strategy: const BuildResultPopupAssetStrategy(),
                buildStatus: buildStatus,
                height: 24.0,
                width: 24.0,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.titleTextStyle,
                      ),
                      if (buildDuration != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            _durationSubtitle,
                            style: theme.subtitleTextStyle,
                          ),
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

  /// Returns a [String] with the build's duration to display as this build
  /// result card's subtitle.
  String get _durationSubtitle {
    return CommonStrings.duration(buildResultPopupViewModel.duration);
  }
}
