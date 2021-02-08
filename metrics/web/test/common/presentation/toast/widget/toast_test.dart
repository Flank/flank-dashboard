// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:metrics/common/presentation/toast/theme/theme_data/toast_theme_data.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';

import '../../../../test_utils/finder_util.dart';
import '../../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("Toast", () {
    const message = 'test';
    const backgroundColor = Colors.red;
    const textStyle = TextStyle(color: Colors.black);

    const metricsThemeData = MetricsThemeData(
      toastTheme: ToastThemeData(
        toastAttentionLevel: ToastAttentionLevel(
          positive: ToastStyle(
            backgroundColor: backgroundColor,
            textStyle: textStyle,
          ),
        ),
      ),
    );

    testWidgets(
      "throws an AssertionError if the given message is null",
      (tester) async {
        await tester.pumpWidget(const _ToastTestbed(message: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given message",
      (tester) async {
        await tester.pumpWidget(const _ToastTestbed(message: message));

        expect(find.text(message), findsOneWidget);
      },
    );

    testWidgets(
      "applies the background color from the metrics theme",
      (tester) async {
        await tester.pumpWidget(const _ToastTestbed(
          metricsThemeData: metricsThemeData,
          message: message,
        ));

        final decoration = FinderUtil.findBoxDecoration(tester);

        expect(decoration.color, equals(backgroundColor));
      },
    );

    testWidgets(
      "applies the text style from the metrics theme",
      (tester) async {
        await tester.pumpWidget(const _ToastTestbed(
          metricsThemeData: metricsThemeData,
          message: message,
        ));

        final text = tester.widget<Text>(find.text(message));

        expect(text.style, equals(textStyle));
      },
    );

    testWidgets(
      "does not overflow on a very long message",
      (tester) async {
        await tester.pumpWidget(const _ToastTestbed(
          metricsThemeData: metricsThemeData,
          message:
              "Some very long message to test that the created metrics toast does not overflows and displays a full message even if it is a very long one",
        ));

        expect(tester.takeException(), isNull);
      },
    );
  });
}

/// A testbed widget, used to test the [Toast] widget.
class _ToastTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsThemeData;

  /// A message to display in the [Toast].
  final String message;

  /// Creates an instance of the toast testbed.
  ///
  /// The [metricsThemeData] defaults to an empty [MetricsThemeData] instance.
  const _ToastTestbed({
    Key key,
    this.message,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsThemeData,
      body: _ToastStub(
        message: message,
      ),
    );
  }
}

/// A stub implementation of the [Toast] widget used for testing.
/// Applies the [ToastAttentionLevel.positive] toast style.
class _ToastStub extends Toast {
  /// Creates an instance of the toast stub with the given [message].
  const _ToastStub({
    Key key,
    String message,
  }) : super(key: key, message: message);

  @override
  ToastStyle getStyle(ToastAttentionLevel attentionLevel) {
    return attentionLevel.positive;
  }
}
