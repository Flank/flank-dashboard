// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/tooltip_popup/widgets/tooltip_popup.dart';

/// A widget with a tooltip icon that displays the [TooltipPopup] on hover.
class TooltipIcon extends StatelessWidget {
  /// A width of the [TooltipPopup].
  static const double _tooltipPopupWidth = 187.0;

  /// A tooltip text to display in the [TooltipPopup].
  final String tooltip;

  /// A source of the icon to display.
  final String src;

  /// Creates a new instance of the [TooltipIcon].
  ///
  /// The [tooltip] and [src] must not be `null`.
  const TooltipIcon({
    Key key,
    @required this.tooltip,
    @required this.src,
  })  : assert(tooltip != null),
        assert(src != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconSize = 16.0;
    final iconTheme = MetricsTheme.of(context).tooltipIconTheme;

    return BasePopup(
      popupOpaque: false,
      closeOnTapOutside: false,
      popupConstraints: const BoxConstraints(
        minWidth: _tooltipPopupWidth,
        maxWidth: _tooltipPopupWidth,
      ),
      offsetBuilder: (triggerSize) {
        final dx = triggerSize.width / 2 - _tooltipPopupWidth / 2;
        final dy = triggerSize.height + 4.0;

        return Offset(dx, dy);
      },
      triggerBuilder: (context, openPopup, closePopup, isOpened) {
        return MouseRegion(
          onEnter: (_) => openPopup(),
          onExit: (_) => closePopup(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: SvgImage(
              src,
              width: iconSize,
              height: iconSize,
              color: isOpened ? iconTheme.hoverColor : iconTheme.color,
            ),
          ),
        );
      },
      popup: TooltipPopup(tooltip: tooltip),
    );
  }
}
