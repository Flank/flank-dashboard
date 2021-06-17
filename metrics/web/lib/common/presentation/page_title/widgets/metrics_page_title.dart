// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/navigation/constants/default_routes.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:provider/provider.dart';

/// A widget that displays the metrics page title with the navigate back arrow.
class MetricsPageTitle extends StatelessWidget {
  /// A title text to display.
  final String title;

  /// Creates the [MetricsPageTitle] with the given [title].
  ///
  /// The [title] must not be null.
  const MetricsPageTitle({
    Key key,
    @required this.title,
  })  : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).pageTitleTheme;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Tooltip(
            message: CommonStrings.navigateBack,
            child: TappableArea(
              onTap: () => _navigateHome(context),
              builder: (context, isHovered, child) => child,
              child: SvgImage(
                'icons/arrow-back.svg',
                width: 32.0,
                height: 32.0,
                fit: BoxFit.contain,
                color: theme.iconColor,
              ),
            ),
          ),
        ),
        Text(
          title,
          style: theme.textStyle,
        ),
      ],
    );
  }

  /// Navigates to the [DefaultRoutes.dashboard] page.
  void _navigateHome(BuildContext context) {
    final navigationNotifier =
        Provider.of<NavigationNotifier>(context, listen: false);

    navigationNotifier.push(DefaultRoutes.dashboard);
  }
}
