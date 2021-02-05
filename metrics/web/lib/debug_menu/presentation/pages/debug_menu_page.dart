import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_negative_button.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/strings/debug_menu_strings.dart';
import 'package:metrics/debug_menu/presentation/widgets/debug_menu_fps_monitor_toggle.dart';
import 'package:metrics/debug_menu/presentation/widgets/debug_menu_renderer_display.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
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

    final isDebugMenuEnabled =
        Provider.of<FeatureConfigNotifier>(context, listen: false)
            .debugMenuFeatureConfigViewModel
            .isEnabled;

    return MetricsScaffold(
      title: CommonStrings.debugMenu,
      padding: const EdgeInsets.only(left: 48.0),
      body: Consumer<DebugMenuNotifier>(
        builder: (_, notifier, __) {
          final fpsMonitorViewModel = notifier.fpsMonitorViewModel;
          final rendererDisplayViewModel = notifier.rendererDisplayViewModel;

          if (!isDebugMenuEnabled) {
            return Text(
              DebugMenuStrings.debugMenuDisabled,
              style: headerTextStyle,
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DebugMenuStrings.performance,
                style: headerTextStyle,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  color: dividerColor,
                ),
              ),
              DebugMenuRendererDisplay(
                rendererDisplayViewModel: rendererDisplayViewModel,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: DebugMenuFpsMonitorToggle(
                  fpsMonitorViewModel: fpsMonitorViewModel,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: MetricsNegativeButton(
                  label: DebugMenuStrings.throwException,
                  onPressed: () {
                    throw Exception('Test Exception from Debug Menu');
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
