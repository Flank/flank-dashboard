import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_item.dart';
import 'package:metrics/common/presentation/dropdown/theme/theme_data/dropdown_item_theme_data.dart';
import 'package:metrics/common/presentation/dropdown/widgets/metrics_dropdown_item.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsDropdownItem", () {
    const title = 'Test title';
    const backgroundColor = Colors.red;
    const hoverColor = Colors.grey;
    const textStyle = TextStyle(fontSize: 13.0);

    const theme = MetricsThemeData(
      dropdownItemTheme: DropdownItemThemeData(
        backgroundColor: backgroundColor,
        hoverColor: hoverColor,
        textStyle: textStyle,
      ),
    );

    DropdownItem findDropdownItemWidget(tester) {
      return tester.widget(find.byType(DropdownItem)) as DropdownItem;
    }

    testWidgets(
      "throws an AssertionError if the given title is null",
      (tester) async {
        await tester.pumpWidget(const _MetricsDropdownItemTestbed(title: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "delegates the background color from the metrics theme to the dropdown item",
      (tester) async {
        await tester.pumpWidget(const _MetricsDropdownItemTestbed(
          title: title,
          theme: theme,
        ));

        final dropdownItemWidget = findDropdownItemWidget(tester);

        expect(dropdownItemWidget.backgroundColor, equals(backgroundColor));
      },
    );

    testWidgets(
      "delegates the hover color from the metrics theme to the dropdown item",
      (tester) async {
        await tester.pumpWidget(const _MetricsDropdownItemTestbed(
          title: title,
          theme: theme,
        ));

        final dropdownItemWidget = findDropdownItemWidget(tester);

        expect(dropdownItemWidget.hoverColor, equals(hoverColor));
      },
    );

    testWidgets(
      "applies the text style from the metrics theme to the title",
      (tester) async {
        await tester.pumpWidget(const _MetricsDropdownItemTestbed(
          title: title,
          theme: theme,
        ));

        final textWidget = tester.widget<Text>(find.text(title));

        expect(textWidget.style, equals(textStyle));
      },
    );

    testWidgets(
      "displays the title",
      (tester) async {
        await tester.pumpWidget(const _MetricsDropdownItemTestbed(
          title: title,
        ));

        expect(find.text(title), findsOneWidget);
      },
    );

    testWidgets(
      "does not overflow on a very long title",
      (tester) async {
        const title =
            "very long name to test that the widget does not overflows if the title is very long";

        await tester.pumpWidget(const _MetricsDropdownItemTestbed(
          title: title,
        ));

        expect(tester.takeException(), isNull);
      },
    );
  });
}

/// A testbed class required to test the [MetricsDropdownItem] widget.
class _MetricsDropdownItemTestbed extends StatelessWidget {
  /// The text title to display.
  final String title;

  /// A [MetricsThemeData] used in this testbed.
  final MetricsThemeData theme;

  /// Creates an instance of this testbed
  /// with the given [title] and the [theme].
  ///
  /// The [theme] defaults to [MetricsThemeData].
  const _MetricsDropdownItemTestbed({
    Key key,
    this.title,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: MetricsDropdownItem(title: title),
    );
  }
}
