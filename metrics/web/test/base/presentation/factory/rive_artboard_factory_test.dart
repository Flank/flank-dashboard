// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/factory/rive_artboard_factory.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/asset_bundle_mock.dart';
import '../../../test_utils/matchers.dart';
import '../test_data/rive_animation_test_data.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("RiveArtboardFactory", () {
    const assetName = 'name';

    final assetByteData = RiveAnimationTestData.assetByteData;
    final mainArtboardName = RiveAnimationTestData.mainArtboardName;
    final allArtboardNames = RiveAnimationTestData.allArtboardNames;

    final assetBundle = AssetBundleMock();

    final artboardFactory = RiveArtboardFactory(assetBundle);

    tearDown(() {
      reset(assetBundle);
    });

    test(
      "throws an ArgumentError if the given bundle is null",
      () {
        expect(() => RiveArtboardFactory(null), throwsArgumentError);
      },
    );

    test(
      ".create() throws an ArgumentError if the given asset name is null",
      () {
        expect(() => artboardFactory.create(null), throwsArgumentError);
      },
    );

    test(
      ".create() loads the asset byte data from the asset bundle",
      () async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        await artboardFactory.create(assetName);

        verify(assetBundle.load(assetName)).called(once);
      },
    );

    test(
      ".create() loads the main artboard if the given artboard name is null",
      () async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        final artboard = await artboardFactory.create(
          assetName,
          artboardName: null,
        );

        expect(artboard.name, equals(mainArtboardName));
      },
    );

    test(
      ".create() loads the artboard with the specified name",
      () async {
        final expectedName = allArtboardNames[1];
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        final artboard = await artboardFactory.create(
          assetName,
          artboardName: expectedName,
        );

        expect(artboard.name, equals(expectedName));
      },
    );
  });
}
