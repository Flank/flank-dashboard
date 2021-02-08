// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/routes/observers/overlay_entry_route_observer.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_user_menu.dart';

/// A widget that displays the user menu pop-up.
class MetricsUserMenuButton extends StatelessWidget {
  /// A width of the metrics user menu.
  static const double _maxWidth = 220.0;

  /// A right padding from the trigger widget.
  static const double _rightPadding = 3.0;

  /// A top padding from the trigger widget.
  static const double _topPadding = 3.0;

  /// Creates the [MetricsUserMenuButton].
  const MetricsUserMenuButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuButtonTheme = MetricsTheme.of(context).userMenuButtonTheme;
    final observers = Navigator.of(context).widget.observers;
    final overlayEntryRouteObserver = observers.firstWhere(
      (element) => element is OverlayEntryRouteObserver,
      orElse: () => null,
    ) as RouteObserver;

    return BasePopup(
      popupConstraints: const BoxConstraints(
        maxWidth: _maxWidth,
      ),
      offsetBuilder: (size) {
        return Offset(
          size.width - _maxWidth - _rightPadding,
          size.height + _topPadding,
        );
      },
      triggerBuilder: (context, openPopup, closePopup, isPopupOpened) {
        final tooltipMessage = isPopupOpened
            ? CommonStrings.closeUserMenu
            : CommonStrings.openUserMenu;

        return Tooltip(
          message: tooltipMessage,
          child: TappableArea(
            onTap: openPopup,
            builder: (context, isHovered, _) {
              return SvgImage(
                'icons/avatar.svg',
                width: 32.0,
                height: 32.0,
                fit: BoxFit.contain,
                color: isHovered
                    ? menuButtonTheme.hoverColor
                    : menuButtonTheme.color,
              );
            },
          ),
        );
      },
      popup: const MetricsUserMenu(),
      routeObserver: overlayEntryRouteObserver,
    );
  }
}
