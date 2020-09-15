import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_theme_image.dart';
import 'package:metrics/common/presentation/widgets/metrics_user_menu_button.dart';

/// A common for the metrics application [AppBar] widget.
class MetricsAppBar extends StatelessWidget {
  /// Creates a [MetricsAppBar].
  const MetricsAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: DimensionsConfig.contentWidth,
      height: DimensionsConfig.appBarHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Tooltip(
            message: CommonStrings.home,
            child: HandCursor(
              child: GestureDetector(
                onTap: () => _navigateHome(context),
                child: const MetricsThemeImage(
                  darkAsset: 'icons/logo-metrics-appbar.svg',
                  lightAsset: 'icons/logo-metrics-appbar-light.svg',
                  width: 116.0,
                  height: 32.0,
                ),
              ),
            ),
          ),
          const MetricsUserMenuButton(),
        ],
      ),
    );
  }

  void _navigateHome(BuildContext context) {
    final _navigator = Navigator.of(context);

    _navigator.pushNamedAndRemoveUntil(
      RouteName.dashboard,
      ModalRoute.withName(Navigator.defaultRouteName),
    );
  }
}
