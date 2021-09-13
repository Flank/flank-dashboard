// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/manufacturer_banner/widget/manufacturer_banner.dart';

/// A widget that displays the banner with the product manufacturer information
/// in the bottom right over the child widget.
class ManufacturerAdvertisementContainer extends StatelessWidget {
  final Widget _child;
  final bool _isEnabled;

  /// Creates a new instance of [ManufacturerAdvertisementContainer].
  ///
  /// Throws an [AssertionError] if the given [child] parameter is `null`.
  /// Throws an [AssertionError] if the giver [isEnabled] parameter is `null`.
  const ManufacturerAdvertisementContainer({
    @required Widget child,
    @required bool isEnabled,
  })  : assert(child != null),
        assert(isEnabled != null),
        _child = child,
        _isEnabled = isEnabled;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _child,
        if (_isEnabled)
          const Positioned(
            bottom: 0.0,
            right: 0.0,
            child: ManufacturerBanner(),
          ),
      ],
    );
  }
}
