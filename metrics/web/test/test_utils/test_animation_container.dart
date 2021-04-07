import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base/presentation/test_data/rive_animation_test_data.dart';

/// A class that mocks the animation used in tests.
class TestAnimationContainer extends StatelessWidget {
  /// A child widget to display.
  final Widget child;

  /// Creates a new instance of the [TestAnimationContainer] with
  /// the given [child].
  ///
  /// Throws an [AssertionError] if the given [child] is `null`.
  const TestAnimationContainer({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultAssetBundle(
      bundle: _TestAssetBundle(),
      child: child,
    );
  }
}

/// A class that represents an [AssetBundle] used in tests.
class _TestAssetBundle extends CachingAssetBundle {
  /// A [ByteData] of the animation assets used in tests.
  static final ByteData _animationByteData =
      RiveAnimationTestData.assetByteData;

  @override
  Future<ByteData> load(String key) {
    return Future.value(_animationByteData);
  }
}
