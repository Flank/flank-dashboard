import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/tooltip_popup/widgets/tooltip_popup.dart';

/// A widget that displays the [TooltipPopup] on hover.
class TooltipIcon extends StatelessWidget {
  /// The tooltip text to display in the [TooltipPopup].
  final String tooltip;

  /// A width of the [BasePopup.popup].
  static const double _popupWidth = 187.0;

  /// Creates a new instance of the [TooltipIcon].
  ///
  /// The [tooltip] must not be `null`.
  const TooltipIcon({
    Key key,
    @required this.tooltip,
  })  : assert(tooltip != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconTheme = MetricsTheme.of(context).tooltipIconTheme;

    return BasePopup(
      popupOpaque: false,
      closeOnTapOutside: false,
      popupConstraints: const BoxConstraints(
        minWidth: _popupWidth,
        maxWidth: _popupWidth,
      ),
      offsetBuilder: (triggerSize) {
        final dx = triggerSize.width / 2 - _popupWidth / 2;
        final dy = triggerSize.height + 4.0;

        return Offset(dx, dy);
      },
      triggerBuilder: (context, openPopup, closePopup, isOpened) {
        return MouseRegion(
          onEnter: (_) => openPopup(),
          onExit: (_) => closePopup(),
          child: SvgImage(
            'icons/info.svg',
            width: 16.0,
            height: 16.0,
            color: isOpened ? iconTheme.hoverColor : iconTheme.color,
          ),
        );
      },
      popup: TooltipPopup(tooltip: tooltip),
    );
  }
}
