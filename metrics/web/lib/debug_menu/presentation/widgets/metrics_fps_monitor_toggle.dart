import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/toggle/widgets/toggle.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/view_models/local_config_fps_monitor_view_model.dart';
import 'package:provider/provider.dart';

/// A widget that displays the FPS monitor toggle.
class MetricsFpsMonitorToggle extends StatelessWidget {
  /// A [LocalConfigFpsMonitorViewModel] with the current FPS monitor toggle
  /// value to display.
  final LocalConfigFpsMonitorViewModel fpsMonitorViewModel;

  /// Creates a new instance of the [MetricsFpsMonitorToggle].
  const MetricsFpsMonitorToggle({
    Key key,
    this.fpsMonitorViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).debugMenuTheme;
    final contentTextStyle = theme.sectionContentTextStyle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(CommonStrings.fpsMonitor, style: contentTextStyle),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Toggle(
            value: fpsMonitorViewModel.isEnabled,
            onToggle: (_) {
              Provider.of<DebugMenuNotifier>(context, listen: false)
                  .toggleFpsMonitor();
            },
          ),
        ),
      ],
    );
  }
}
