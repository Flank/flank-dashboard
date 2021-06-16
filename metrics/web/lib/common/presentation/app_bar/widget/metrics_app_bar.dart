// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/navigation/constants/default_routes.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/user_menu_button/widgets/metrics_user_menu_button.dart';
import 'package:metrics/common/presentation/widgets/metrics_theme_image.dart';
import 'package:provider/provider.dart';

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
            child: TappableArea(
              onTap: () => _navigateHome(context),
              builder: (context, isHovered, child) => child,
              child: const MetricsThemeImage(
                darkAsset: 'icons/logo-metrics-appbar.svg',
                lightAsset: 'icons/logo-metrics-appbar-light.svg',
                width: 116.0,
                height: 32.0,
              ),
            ),
          ),
          const MetricsUserMenuButton(),
        ],
      ),
    );
  }

  /// Navigates to the [DefaultRoutes.dashboard] page.
  void _navigateHome(BuildContext context) {
    final navigationNotifier = Provider.of<NavigationNotifier>(
      context,
      listen: false,
    );

    navigationNotifier.pushAndRemoveUntil(
      DefaultRoutes.dashboard,
      (page) => page.name == Navigator.defaultRouteName,
    );
  }
}
