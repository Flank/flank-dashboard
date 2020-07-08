import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
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
          Image.network(
            'icons/logo-metrics.svg',
            width: 130.0,
            height: 32.0,
            fit: BoxFit.contain,
          ),
          Tooltip(
            message: CommonStrings.openUserMenu,
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
        ],
      ),
    );
  }

  /// Opens a drawer of the [Scaffold] in the given [context].
  void _openDrawer(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return scaffold.openEndDrawer();
  }
}
