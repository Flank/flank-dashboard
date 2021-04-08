// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/services.dart';

import '../base/presentation/test_data/rive_animation_test_data.dart';

/// A stub implementation of the [AssetBundle] used to test the Rive animations.
class RiveAssetBundleStub extends CachingAssetBundle {
  /// A [ByteData] of the rive animation assets used in tests.
  static final ByteData _animationByteData =
      RiveAnimationTestData.assetByteData;

  @override
  Future<ByteData> load(String key) {
    return Future.value(_animationByteData);
  }
}
