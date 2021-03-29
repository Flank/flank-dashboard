// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/test_data/rive_animation_test_data.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:mockito/mockito.dart';
import 'package:rive/rive.dart';

import '../../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("RiveAnimation", () {
    const assetName = 'name';

    final assetByteData = RiveAnimationTestData.assetByteData;
    final mainArtboardName = RiveAnimationTestData.mainArtboardName;
    final allArtboardNames = RiveAnimationTestData.allArtboardNames;
    final assetBundle = _AssetBundleMock();

    final riveFinder = find.byType(Rive);

    Rive getRive(WidgetTester tester) {
      return tester.widget<Rive>(riveFinder);
    }

    tearDown(() {
      reset(assetBundle);
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
      "loads the animation asset from the given asset bundle",
      (WidgetTester tester) async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
          ),
        );

        verify(assetBundle.load(assetName)).called(once);
      },
    );

    testWidgets(
      "loads the animation asset from the default asset bundle if the given asset bundle is null",
      (WidgetTester tester) async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        await tester.pumpWidget(
          DefaultAssetBundle(
            bundle: assetBundle,
            child: const _RiveAnimationTestbed(
              assetName,
              bundle: null,
            ),
          ),
        );

        verify(assetBundle.load(assetName)).called(once);
      },
    );

    testWidgets(
      "displays the Rive widget",
      (WidgetTester tester) async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
          ),
        );
        await tester.pump();

        expect(riveFinder, findsOneWidget);
      },
    );

    testWidgets(
      "loads the main rive animation artboard if the given artboard name is null",
      (WidgetTester tester) async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
            artboardName: null,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);
        final artboardName = rive.artboard.name;

        expect(artboardName, equals(mainArtboardName));
      },
    );

    testWidgets(
      "loads the rive animation artboard with the given name",
      (WidgetTester tester) async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );
        final expectedArtboardName = allArtboardNames[1];

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
            artboardName: expectedArtboardName,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);
        final artboardName = rive.artboard.name;

        expect(artboardName, equals(expectedArtboardName));
      },
    );

    testWidgets(
      "applies the Alignment.center to the Rive widget if the given alignment is null",
      (WidgetTester tester) async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
            alignment: null,
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
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );
        const expectedAlignment = Alignment.topLeft;

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
            alignment: expectedAlignment,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);

        expect(rive.alignment, equals(expectedAlignment));
      },
    );

    testWidgets(
      "applies the BoxFit.contain to the Rive widget if the given fit is null",
      (WidgetTester tester) async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
            fit: null,
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
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );
        const expectedFit = BoxFit.cover;

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
            fit: expectedFit,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);

        expect(rive.fit, equals(expectedFit));
      },
    );

    testWidgets(
      "does not use the artboard size in the Rive widget if the given use artboard size is null",
      (WidgetTester tester) async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
            useArtboardSize: null,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);

        expect(rive.useArtboardSize, isFalse);
      },
    );

    testWidgets(
      "uses the given use artboard size in the Rive widget",
      (WidgetTester tester) async {
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );
        const expectedUseArtboardSize = true;

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
            useArtboardSize: expectedUseArtboardSize,
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
        when(assetBundle.load(assetName)).thenAnswer(
          (_) => Future.value(assetByteData),
        );
        final controller = SimpleAnimation('');

        await tester.pumpWidget(
          _RiveAnimationTestbed(
            assetName,
            bundle: assetBundle,
            controller: controller,
          ),
        );
        await tester.pump();

        final rive = getRive(tester);
        final artboard = rive.artboard;

        final canAddController = artboard.addController(controller);

        expect(canAddController, isFalse);
      },
    );
  });
}

/// A testbed class needed to test the [RiveAnimation] widget.
class _RiveAnimationTestbed extends StatelessWidget {
  /// An [Alignment] of the [RiveAnimation] to use in tests.
  final Alignment alignment;

  /// An [Artboard] name of the [RiveAnimation] to use in tests.
  final String artboardName;

  /// A name of the animation asset to load for the [RiveAnimation] to use in
  /// tests.
  final String assetName;

  /// An [AssetBundle] to use in tests.
  final AssetBundle bundle;

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
    this.artboardName,
    this.bundle,
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
          artboardName: artboardName,
          bundle: bundle,
          controller: controller,
          alignment: alignment,
          useArtboardSize: useArtboardSize,
          fit: fit,
        ),
      ),
    );
  }
}

class _AssetBundleMock extends Mock implements AssetBundle {}
