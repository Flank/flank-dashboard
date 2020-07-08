import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group("MetricsAppBar", () {
    testWidgets(
      "app bar width equals to the dimensions config content width",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsAppBarTestbed());
        });

        final sizedBox = tester.widget<SizedBox>(find.descendant(
          of: find.byType(MetricsAppBar),
          matching: find.byType(SizedBox),
        ));

        expect(sizedBox.width, DimensionsConfig.contentWidth);
      },
    );

    testWidgets(
      "app bar height equals to the dimensions config app bar height",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsAppBarTestbed());
        });

        final sizedBox = tester.widget<SizedBox>(find.descendant(
          of: find.byType(MetricsAppBar),
          matching: find.byType(SizedBox),
        ));

        expect(sizedBox.height, DimensionsConfig.appBarHeight);
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsAppBar] widget.
class _MetricsAppBarTestbed extends StatelessWidget {
  /// Creates the [_MetricsAppBarTestbed].
  const _MetricsAppBarTestbed({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MetricsAppBar(),
      ),
    );
  }
}
