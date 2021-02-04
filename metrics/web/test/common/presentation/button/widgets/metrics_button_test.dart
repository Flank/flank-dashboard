// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/button/theme/attention_level/metrics_button_attention_level.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/button/theme/theme_data/metrics_button_theme_data.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_button.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsButton", () {
    const label = 'Label';
    const metricsThemeData = MetricsThemeData(
      metricsButtonTheme: MetricsButtonThemeData(
        buttonAttentionLevel: MetricsButtonAttentionLevel(
          neutral: MetricsButtonStyle(
            color: Colors.yellow,
            elevation: 1.0,
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          inactive: MetricsButtonStyle(
            color: Colors.grey,
            elevation: 0.0,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );

    final buttonFinder = find.ancestor(
      of: find.text(label),
      matching: find.byType(RaisedButton),
    );

    void defaultOnPressed() {}

    testWidgets(
      "throws an AssertionError if the given label is null",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsButtonTestbed(label: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the button with the given label",
      (tester) async {
        const label = 'Label';

        await tester.pumpWidget(
          const _MetricsButtonTestbed(label: label),
        );

        expect(buttonFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the given on pressed callback to the button",
      (tester) async {
        await tester.pumpWidget(
          _MetricsButtonTestbed(
            label: label,
            onPressed: defaultOnPressed,
          ),
        );

        final button = tester.widget<RaisedButton>(buttonFinder);

        expect(button.onPressed, equals(defaultOnPressed));
      },
    );

    testWidgets(
      "applies a color to the button from the inactive button style if the given on pressed is null",
      (tester) async {
        final buttonTheme = metricsThemeData.metricsButtonTheme;
        final expectedColor = buttonTheme.attentionLevel.inactive.color;

        await tester.pumpWidget(const _MetricsButtonTestbed(
          metricsThemeData: metricsThemeData,
          label: label,
          onPressed: null,
        ));
        final button = tester.widget<RaisedButton>(buttonFinder);
        final color = button.disabledColor;

        expect(color, equals(expectedColor));
      },
    );

    testWidgets(
      "applies a text style to the label from the inactive button style if the given on pressed is null",
      (tester) async {
        final buttonTheme = metricsThemeData.metricsButtonTheme;
        final expectedLabelStyle =
            buttonTheme.attentionLevel.inactive.labelStyle;

        await tester.pumpWidget(const _MetricsButtonTestbed(
          metricsThemeData: metricsThemeData,
          label: label,
          onPressed: null,
        ));
        final text = tester.widget<Text>(find.text(label));
        final textStyle = text.style;

        expect(textStyle, equals(expectedLabelStyle));
      },
    );

    testWidgets(
      "applies the disabled elevation to the button from the inactive button style if the given on pressed is null",
      (tester) async {
        final buttonTheme = metricsThemeData.metricsButtonTheme;
        final expectedElevation = buttonTheme.attentionLevel.inactive.elevation;

        await tester.pumpWidget(const _MetricsButtonTestbed(
          metricsThemeData: metricsThemeData,
          label: label,
          onPressed: null,
        ));
        final button = tester.widget<RaisedButton>(buttonFinder);
        final elevation = button.disabledElevation;

        expect(elevation, equals(expectedElevation));
      },
    );

    testWidgets(
      "applies a color to the button from the button style in a theme",
      (tester) async {
        final buttonTheme = metricsThemeData.metricsButtonTheme;
        final expectedColor = buttonTheme.attentionLevel.neutral.color;

        await tester.pumpWidget(_MetricsButtonTestbed(
          metricsThemeData: metricsThemeData,
          label: label,
          onPressed: defaultOnPressed,
        ));
        final button = tester.widget<RaisedButton>(buttonFinder);
        final color = button.color;

        expect(color, equals(expectedColor));
      },
    );

    testWidgets(
      "applies a hover color to the button from the button style in a theme",
      (tester) async {
        final buttonTheme = metricsThemeData.metricsButtonTheme;
        final expectedColor = buttonTheme.attentionLevel.neutral.hoverColor;

        await tester.pumpWidget(_MetricsButtonTestbed(
          metricsThemeData: metricsThemeData,
          label: label,
          onPressed: defaultOnPressed,
        ));
        final button = tester.widget<RaisedButton>(buttonFinder);
        final color = button.hoverColor;

        expect(color, equals(expectedColor));
      },
    );

    testWidgets(
      "applies a text style to the label from the button style in a theme",
      (tester) async {
        final buttonTheme = metricsThemeData.metricsButtonTheme;
        final expectedLabelStyle =
            buttonTheme.attentionLevel.neutral.labelStyle;

        await tester.pumpWidget(_MetricsButtonTestbed(
          metricsThemeData: metricsThemeData,
          label: label,
          onPressed: defaultOnPressed,
        ));
        final text = tester.widget<Text>(find.text(label));
        final textStyle = text.style;

        expect(textStyle, equals(expectedLabelStyle));
      },
    );

    testWidgets(
      "applies the elevation to the button from the button style in a theme",
      (tester) async {
        final buttonTheme = metricsThemeData.metricsButtonTheme;
        final expectedElevation = buttonTheme.attentionLevel.neutral.elevation;

        await tester.pumpWidget(_MetricsButtonTestbed(
          metricsThemeData: metricsThemeData,
          label: label,
          onPressed: defaultOnPressed,
        ));
        final button = tester.widget<RaisedButton>(buttonFinder);

        expect(button.elevation, equals(expectedElevation));
        expect(button.hoverElevation, equals(expectedElevation));
        expect(button.focusElevation, equals(expectedElevation));
        expect(button.highlightElevation, equals(expectedElevation));
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsButton] widget.
class _MetricsButtonTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsThemeData;

  /// A label for the [MetricsButton].
  final String label;

  /// A callback for the [MetricsButton].
  final VoidCallback onPressed;

  /// Creates an instance of the Metrics button testbed.
  ///
  /// The [metricsThemeData] defaults to an empty [MetricsThemeData] instance.
  const _MetricsButtonTestbed({
    Key key,
    this.metricsThemeData = const MetricsThemeData(),
    this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsThemeData,
      body: _MetricsButtonStub(
        label: label,
        onPressed: onPressed,
      ),
    );
  }
}

/// A stub implementation of the [MetricsButton] widget used for testing.
/// Applies the [MetricsButtonAttentionLevel.neutral] button style.
class _MetricsButtonStub extends MetricsButton {
  /// Creates an instance of the metrics button stub.
  const _MetricsButtonStub({
    Key key,
    String label,
    VoidCallback onPressed,
  }) : super(key: key, label: label, onPressed: onPressed);

  @override
  MetricsButtonStyle selectStyle(MetricsButtonAttentionLevel attentionLevel) {
    return attentionLevel.neutral;
  }
}
