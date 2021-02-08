// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/widgets/metrics_checkbox.dart';
import 'package:network_image_mock/network_image_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsCheckbox", () {
    testWidgets(
      "throws an AssertionError if the given value is null",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(value: null),
          );
        });

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given is hovered is null",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(isHovered: null),
          );
        });

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the tappable area widget",
      (tester) async {
        const initialValue = true;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(
              value: initialValue,
            ),
          );
        });

        expect(find.byType(TappableArea), findsOneWidget);
      },
    );

    testWidgets(
      "calls the given on changed callback with a new value when checkbox is tapped",
      (tester) async {
        const initialValue = true;
        bool value = initialValue;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _MetricsCheckboxTestbed(
              value: value,
              onChanged: (newValue) => value = newValue,
            ),
          );
        });

        await tester.tap(find.byType(MetricsCheckbox));

        expect(value, isNot(initialValue));
      },
    );

    testWidgets(
      "does not throw on tap if the given on changes callback is null",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(
              value: false,
              onChanged: null,
            ),
          );
        });

        await tester.tap(find.byType(MetricsCheckbox));

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      "displays the animated crossfade with the image for the checkbox",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(value: false),
          );
        });

        final finder = find.byType(AnimatedCrossFade);
        final crossFade = tester.widget<AnimatedCrossFade>(finder);
        final image = crossFade.firstChild as SvgImage;

        expect(image.src, equals('icons/check-box.svg'));
      },
    );

    testWidgets(
      "displays the animated crossfade with the image for the hovered checkbox if the widget is hovered",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(
              value: false,
              isHovered: true,
            ),
          );
        });

        final finder = find.byType(AnimatedCrossFade);
        final crossFade = tester.widget<AnimatedCrossFade>(finder);
        final image = crossFade.firstChild as SvgImage;

        expect(image.src, equals('icons/check-box-hovered.svg'));
      },
    );

    testWidgets(
      "displays the animated crossfade with the image for the blank checkbox",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(value: false),
          );
        });

        final finder = find.byType(AnimatedCrossFade);
        final crossFade = tester.widget<AnimatedCrossFade>(finder);
        final image = crossFade.secondChild as SvgImage;

        expect(image.src, equals('icons/check-box-blank.svg'));
      },
    );

    testWidgets(
      "displays the animated crossfade with the image for the hovered blank checkbox if the widget is hovered",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(
              value: false,
              isHovered: true,
            ),
          );
        });

        final finder = find.byType(AnimatedCrossFade);
        final crossFade = tester.widget<AnimatedCrossFade>(finder);
        final image = crossFade.secondChild as SvgImage;

        expect(image.src, equals('icons/check-box-blank-hovered.svg'));
      },
    );

    testWidgets(
      "displays the unchecked checkbox if the given value is false",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(value: false),
          );
        });

        final finder = find.byType(AnimatedCrossFade);
        final crossFade = tester.widget<AnimatedCrossFade>(finder);

        expect(crossFade.crossFadeState, equals(CrossFadeState.showSecond));
      },
    );

    testWidgets(
      "displays the checked checkbox if the given value is true",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(value: true),
          );
        });

        final finder = find.byType(AnimatedCrossFade);
        final crossFade = tester.widget<AnimatedCrossFade>(finder);

        expect(crossFade.crossFadeState, equals(CrossFadeState.showFirst));
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsCheckbox] widget.
class _MetricsCheckboxTestbed extends StatelessWidget {
  /// The value to apply to the [MetricsCheckbox].
  final bool value;

  /// The callback that is called when the checkbox has tapped.
  final ValueChanged<bool> onChanged;

  /// Indicates whether [MetricsCheckbox] is hovered.
  final bool isHovered;

  /// Creates a new instance of the metrics checkbox testbed.
  ///
  /// [isHovered] defaults to `false`.
  const _MetricsCheckboxTestbed({
    Key key,
    this.value,
    this.onChanged,
    this.isHovered = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsCheckbox(
          value: value,
          onChanged: onChanged,
          isHovered: isHovered,
        ),
      ),
    );
  }
}
