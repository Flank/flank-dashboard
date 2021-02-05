import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/toggle/widgets/toggle.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/strings/debug_menu_strings.dart';
import 'package:metrics/debug_menu/presentation/view_models/local_config_fps_monitor_view_model.dart';
import 'package:provider/provider.dart';

/// A widget that displays the FPS monitor toggle.
class DebugMenuFpsMonitorToggle extends StatelessWidget {
  /// A [LocalConfigFpsMonitorViewModel] with the current FPS monitor toggle
  /// value to display.
  final LocalConfigFpsMonitorViewModel fpsMonitorViewModel;

  /// Creates a new instance of the [DebugMenuFpsMonitorToggle].
  const DebugMenuFpsMonitorToggle({
    Key key,
    @required this.fpsMonitorViewModel,
  })  : assert(fpsMonitorViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).debugMenuTheme;
    final contentTextStyle = theme.sectionContentTextStyle;

    final isFpsMonitorEnabled = fpsMonitorViewModel.isEnabled;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DebugMenuStrings.fpsMonitor,
          style: contentTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Toggle(
            value: isFpsMonitorEnabled,
            onToggle: (_) => _toggleFpsMonitor(context),
          ),
        ),
      ],
    );
  }

  /// Toggles the FPS Monitor feature.
  void _toggleFpsMonitor(BuildContext context) {
    final debugMenuNotifier = Provider.of<DebugMenuNotifier>(
      context,
      listen: false,
    );

    debugMenuNotifier.toggleFpsMonitor();
  }
}
