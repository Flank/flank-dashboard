import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';

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
                child: Image.network(
                  'icons/logo-metrics.svg',
                  width: 116.0,
                  height: 32.0,
                ),
              ),
            ),
          ),
          Tooltip(
            message: CommonStrings.openUserMenu,
            child: HandCursor(
              child: InkWell(
                onTap: () => _openDrawer(context),
                customBorder: const CircleBorder(),
                child: Image.network(
                  'icons/avatar.svg',
                  width: 32.0,
                  height: 32.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Opens a drawer of the [Scaffold] in the given [context].
  void _openDrawer(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return scaffold.openEndDrawer();
  }

  void _navigateHome(BuildContext context) {
    final _navigator = Navigator.of(context);

    _navigator.pushNamedAndRemoveUntil(
      RouteName.dashboard,
      ModalRoute.withName(Navigator.defaultRouteName),
    );
  }
}
