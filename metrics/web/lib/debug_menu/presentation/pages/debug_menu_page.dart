import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/widgets/metrics_fps_monitor_toggle.dart';
import 'package:metrics/debug_menu/presentation/widgets/metrics_renderer_display.dart';
import 'package:provider/provider.dart';

/// A page that displays settings for debug features of the debug menu.
class DebugMenuPage extends StatelessWidget {
  /// Creates a new instance of the [DebugMenuPage].
  const DebugMenuPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).debugMenuTheme;
    final headerTextStyle = theme.sectionHeaderTextStyle;
    final dividerColor = theme.sectionDividerColor;

    return MetricsScaffold(
      title: CommonStrings.debugMenu,
      padding: const EdgeInsets.only(left: 48.0),
      body: Consumer<DebugMenuNotifier>(
        builder: (_, notifier, __) {
          final fpsMonitorViewModel = notifier.localConfigFpsMonitorViewModel;
          final rendererDisplayViewModel = notifier.rendererDisplayViewModel;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(CommonStrings.performance, style: headerTextStyle),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  color: dividerColor,
                ),
              ),
              MetricsRendererDisplay(
                rendererDisplayViewModel: rendererDisplayViewModel,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: MetricsFpsMonitorToggle(
                  fpsMonitorViewModel: fpsMonitorViewModel,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
