// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/factory/rive_artboard_factory.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:mockito/mockito.dart';
import 'package:rive/rive.dart';

import '../../../test_utils/asset_bundle_mock.dart';
import '../../../test_utils/matchers.dart';
import '../test_data/rive_animation_test_data.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("RiveAnimation", () {
    const assetName = 'name';
    const artboardName = 'name';

    final assetByteData = RiveAnimationTestData.assetByteData;
    final mainArtboard = RiveAnimationTestData.mainArtboard;

    final assetBundle = AssetBundleMock();
    final artboardFactory = _RiveArtboardFactoryMock();

    final riveFinder = find.byType(Rive);

    Rive getRive(WidgetTester tester) {
      return tester.widget<Rive>(riveFinder);
    }

    tearDown(() {
      reset(assetBundle);
      reset(artboardFactory);
    });

    testWidgets(
      "throws an AssertionError if the given asset name is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _RiveAnimationTestbed(null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "loads the animation asset from the default asset bundle if the given artboard factory is null",
      (WidgetTester tester) async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        await tester.pumpWidget(
          DefaultAssetBundle(
            bundle: assetBundle,
            child: const _RiveAnimationTestbed(
              assetName,
            ),
          ),
        );

        verify(assetBundle.load(assetName)).called(once);
      },
    );

    testWidgets(
      "creates an artboard using the given artboard factory",
      (WidgetTester tester) async {
        when(
          artboardFactory.create(assetName, artboardName: artboardName),
        ).thenAnswer((_) => Future.value(mainArtboard));

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            artboardName: artboardName,
            artboardFactory: artboardFactory,
          ),
        );
        await tester.pump();

        verify(
          artboardFactory.create(assetName, artboardName: artboardName),
        ).called(once);
      },
    );

    testWidgets(
      "displays the Rive widget with the artboard created by the artboard factory",
      (WidgetTester tester) async {
        when(artboardFactory.create(assetName)).thenAnswer(
          (_) => Future.value(mainArtboard),
        );

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            artboardFactory: artboardFactory,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);

        expect(rive.artboard, equals(mainArtboard));
      },
    );

    testWidgets(
      "applies the Alignment.center to the Rive widget if the given alignment is null",
      (WidgetTester tester) async {
        when(artboardFactory.create(assetName)).thenAnswer(
          (_) => Future.value(mainArtboard),
        );

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            alignment: null,
            artboardFactory: artboardFactory,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);

        expect(rive.alignment, equals(Alignment.center));
      },
    );

    testWidgets(
      "applies the given alignment to the Rive widget",
      (WidgetTester tester) async {
        when(artboardFactory.create(assetName)).thenAnswer(
          (_) => Future.value(mainArtboard),
        );

        const expectedAlignment = Alignment.topLeft;

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            alignment: expectedAlignment,
            artboardFactory: artboardFactory,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);

        expect(rive.alignment, equals(expectedAlignment));
      },
    );

    testWidgets(
      "applies the BoxFit.contain to the Rive widget if it is not specified",
      (WidgetTester tester) async {
        when(artboardFactory.create(assetName)).thenAnswer(
          (_) => Future.value(mainArtboard),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RiveAnimation(
                assetName,
                artboardFactory: artboardFactory,
              ),
            ),
          ),
        );
        await tester.pump();

        final rive = getRive(tester);

        expect(rive.fit, equals(BoxFit.contain));
      },
    );

    testWidgets(
      "applies the given fit to the Rive widget",
      (WidgetTester tester) async {
        when(artboardFactory.create(assetName)).thenAnswer(
          (_) => Future.value(mainArtboard),
        );

        const expectedFit = BoxFit.cover;

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            fit: expectedFit,
            artboardFactory: artboardFactory,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);

        expect(rive.fit, equals(expectedFit));
      },
    );

    testWidgets(
      "does not apply the use artboard size to the Rive widget if the given use artboard size is null",
      (WidgetTester tester) async {
        when(artboardFactory.create(assetName)).thenAnswer(
          (_) => Future.value(mainArtboard),
        );

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            useArtboardSize: null,
            artboardFactory: artboardFactory,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);

        expect(rive.useArtboardSize, isFalse);
      },
    );

    testWidgets(
      "applies the given use artboard size to the Rive widget",
      (WidgetTester tester) async {
        when(artboardFactory.create(assetName)).thenAnswer(
          (_) => Future.value(mainArtboard),
        );
        const expectedUseArtboardSize = true;

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            useArtboardSize: expectedUseArtboardSize,
            artboardFactory: artboardFactory,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);

        expect(rive.useArtboardSize, equals(expectedUseArtboardSize));
      },
    );

    testWidgets(
      "applies the given controller to the loaded Rive animation artboard",
      (WidgetTester tester) async {
        final artboard = _ArtboardMock();
        final controller = SimpleAnimation('');
        when(artboardFactory.create(assetName)).thenAnswer(
          (_) => Future.value(artboard),
        );

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            controller: controller,
            artboardFactory: artboardFactory,
          ),
        );

        verify(artboard.addController(controller)).called(once);
      },
    );
  });
}

/// A testbed class needed to test the [RiveAnimation] widget.
class _RiveAnimationTestbed extends StatelessWidget {
  /// An [Alignment] of the [RiveAnimation] to use in tests.
  final Alignment alignment;

  /// A [RiveArtboardFactory] of the [RiveAnimation] to use in tests.
  final RiveArtboardFactory artboardFactory;

  /// An [Artboard] name of the [RiveAnimation] to use in tests.
  final String artboardName;

  /// A name of the animation asset to load for the [RiveAnimation] to use in
  /// tests.
  final String assetName;

  /// A [RiveAnimationController] of the [RiveAnimation] to use in tests.
  final RiveAnimationController controller;

  /// A [BoxFit] of the [RiveAnimation] to use in tests.
  final BoxFit fit;

  /// A flag that determines whether to use the absolute size defined by the
  /// [Artboard], or size the widget based on the available constraints only
  /// for the [RiveAnimation] to use in tests.
  final bool useArtboardSize;

  /// Creates a new instance of the [_RiveAnimationTestbed] with the given
  /// parameters.
  const _RiveAnimationTestbed(
    this.assetName, {
    this.alignment,
    this.artboardFactory,
    this.artboardName,
    this.controller,
    this.fit,
    this.useArtboardSize,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RiveAnimation(
          assetName,
          artboardFactory: artboardFactory,
          artboardName: artboardName,
          controller: controller,
          alignment: alignment,
          useArtboardSize: useArtboardSize,
          fit: fit,
        ),
      ),
    );
  }
}

class _ArtboardMock extends Mock implements Artboard {}

class _RiveArtboardFactoryMock extends Mock implements RiveArtboardFactory {}
