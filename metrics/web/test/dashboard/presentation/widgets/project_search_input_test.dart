// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
import 'package:metrics/dashboard/presentation/widgets/projects_search_input.dart';
import 'package:network_image_mock/network_image_mock.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ProjectSearchInput", () {
    testWidgets(
      "displays the metrics text form field",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ProjectSearchInputTestbed());
        });

        expect(find.byType(MetricsTextFormField), findsOneWidget);
      },
    );

    testWidgets(
      "calls the given on changed callback when the text changes",
      (tester) async {
        bool onChangedCalled = false;

        await tester.pumpWidget(_ProjectSearchInputTestbed(
          onChanged: (_) {
            onChangedCalled = true;
          },
        ));

        await tester.enterText(find.byType(ProjectSearchInput), 'text');

        expect(onChangedCalled, isTrue);
      },
    );

    testWidgets(
      "applies the given initial value to the metrics text form field controller text value",
      (tester) async {
        const initialValue = 'initialValue';

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _ProjectSearchInputTestbed(initialValue: initialValue),
          );
        });

        final metricsTextFormField = tester.widget<MetricsTextFormField>(
          find.byType(MetricsTextFormField),
        );

        expect(metricsTextFormField.controller.text, equals(initialValue));
      },
    );

    testWidgets(
      "applies the search for project text to the hint of the metrics text form field",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ProjectSearchInputTestbed());
        });

        final metricsTextFormField = tester.widget<MetricsTextFormField>(
          find.byType(MetricsTextFormField),
        );

        expect(
          metricsTextFormField.hint,
          equals(CommonStrings.searchForProject),
        );
      },
    );

    testWidgets(
      "applies a search icon to a prefix icon of the metrics text form field",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _ProjectSearchInputTestbed());
        });

        final finder = find.byWidgetPredicate((widget) {
          if (widget is TextField && widget.decoration?.prefixIcon != null) {
            final iconFinder = find.descendant(
              of: find.byWidget(widget.decoration.prefixIcon),
              matching: find.byType(SvgImage),
            );

            final image = tester.widget<SvgImage>(iconFinder);
            final imageUrl = image.src;

            return imageUrl == 'icons/search.svg';
          }

          return false;
        });

        expect(finder, findsOneWidget);
      },
    );
  });
}

/// A testbed class required to test the [ProjectSearchInput] widget.
class _ProjectSearchInputTestbed extends StatelessWidget {
  /// A callback for value changes for the text field.
  final ValueChanged<String> onChanged;

  /// An initial value for the project search input.
  final String initialValue;

  /// Creates an instance of the project search input testbed.
  const _ProjectSearchInputTestbed({
    Key key,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: ProjectSearchInput(
        onChanged: onChanged,
        initialValue: initialValue,
      ),
    );
  }
}
