// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../rive_asset_bundle_stub.dart';

/// A testbed class required to test the [RiveAnimation] widget.
class RiveAnimationTestbed extends StatelessWidget {
  /// A child widget to display.
  final Widget child;

  /// Creates a new instance of the [RiveAnimationTestbed] with
  /// the given [child].
  ///
  /// Throws an [AssertionError] if the given [child] is `null`.
  const RiveAnimationTestbed({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultAssetBundle(
      bundle: RiveAssetBundleStub(),
      child: child,
    );
  }
}
