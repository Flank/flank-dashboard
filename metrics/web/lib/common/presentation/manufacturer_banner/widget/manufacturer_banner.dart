// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:metrics/base/presentation/widgets/material_container.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays the banner with the product manufacturer information.
class ManufacturerBanner extends StatefulWidget {
  /// Creates a new instance of the [ManufacturerBanner].
  const ManufacturerBanner({Key key}) : super(key: key);

  @override
  _ManufacturerBannerState createState() => _ManufacturerBannerState();
}

class _ManufacturerBannerState extends State<ManufacturerBanner>
    with SingleTickerProviderStateMixin {
  /// A [Duration] of this banner folding animation.
  static const _animationDuration = Duration(milliseconds: 250);

  /// An [AnimationController] of this banner folding animation.
  AnimationController _controller;

  /// A [Timer] of this banner preview.
  Timer _previewTimer;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _controller.value = 1.0;

    _previewTimer = Timer(const Duration(seconds: 10), _closeBanner);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = MetricsTheme.of(context).manufacturerBannerThemeData;

    return GestureDetector(
      onTap: _openManufacturerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _openBanner(),
        onExit: (_) => _closeBanner(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return MaterialContainer(
              padding: const EdgeInsets.all(8.0),
              elevation: themeData.elevation,
              backgroundColor: themeData.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SvgImage(
                    'icons/solid_logo.svg',
                  ),
                  SizeTransition(
                    sizeFactor: _controller,
                    axis: Axis.horizontal,
                    axisAlignment: -1.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        CommonStrings.builtBySolidSoftware,
                        style: themeData.textStyle,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Starts this banner opening animation.
  ///
  /// Cancels the [_previewTimer] is there any running.
  void _openBanner() {
    _cancelPreviewTimer();
    _controller.stop();
    _controller.forward();
  }

  /// Starts this banner closing animation.
  ///
  /// Cancels the [_previewTimer] is there any running.
  void _closeBanner() {
    _cancelPreviewTimer();
    _controller.stop();
    _controller.reverse();
  }

  /// Cancels the [_previewTimer] if it is running.
  ///
  /// If the [_previewTimer] is null does nothing.
  void _cancelPreviewTimer() {
    if (_previewTimer == null) return;

    _previewTimer.cancel();
    _previewTimer = null;
  }

  /// Opens the manufacturer link.
  void _openManufacturerLink() {
    launch('https://solid.software/');
  }

  @override
  void dispose() {
    _cancelPreviewTimer();
    _controller.dispose();
    super.dispose();
  }
}
