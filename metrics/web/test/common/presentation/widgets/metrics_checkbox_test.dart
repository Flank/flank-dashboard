import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      "displays the animated cross fade with image for the checkbox",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(value: false),
          );
        });

        final finder = find.byType(AnimatedCrossFade);
        final crossFade = tester.widget<AnimatedCrossFade>(finder);
        final firstChild = crossFade.firstChild as Image;
        final imageProvider = firstChild.image as NetworkImage;

        expect(imageProvider.url, equals('icons/check-box.svg'));
      },
    );

    testWidgets(
      "displays the animated cross fade with image for the blank checkbox",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsCheckboxTestbed(value: false),
          );
        });

        final finder = find.byType(AnimatedCrossFade);
        final crossFade = tester.widget<AnimatedCrossFade>(finder);
        final secondChild = crossFade.secondChild as Image;
        final imageProvider = secondChild.image as NetworkImage;

        expect(imageProvider.url, equals('icons/check-box-blank.svg'));
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

  /// Creates a new instance of the metrics checkbox testbed.
  const _MetricsCheckboxTestbed({
    Key key,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsCheckbox(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
