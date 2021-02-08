// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_header_loading_placeholder.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_loading_header.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';

import '../../../test_utils/dimensions_util.dart';

void main() {
  group("MetricsTableLoadingHeader", () {
    setUpAll(() {
      DimensionsUtil.setTestWindowSize(width: DimensionsConfig.contentWidth);
    });

    tearDownAll(() {
      DimensionsUtil.clearTestWindowSize();
    });

    final isAMetricsTableHeaderPlaceholder =
        isA<MetricsTableHeaderLoadingPlaceholder>();

    MetricsTableRow findMetricsTableRow(WidgetTester tester) {
      return tester.widget<MetricsTableRow>(
        find.byType(MetricsTableRow),
      );
    }

    testWidgets(
      "applies an empty container to the build status",
      (tester) async {
        await tester.pumpWidget(_MetricsTableLoadingHeaderTestbed());

        final metricsTableRowWidget = findMetricsTableRow(tester);

        expect(metricsTableRowWidget.status, isA<Container>());
      },
    );

    testWidgets(
      "applies an empty container to the project name",
      (tester) async {
        await tester.pumpWidget(_MetricsTableLoadingHeaderTestbed());

        final metricsTableRowWidget = findMetricsTableRow(tester);

        expect(metricsTableRowWidget.name, isA<Container>());
      },
    );

    testWidgets(
      "applies the loading placeholder to the build results",
      (tester) async {
        await tester.pumpWidget(_MetricsTableLoadingHeaderTestbed());

        final metricsTableRowWidget = findMetricsTableRow(tester);

        expect(
          metricsTableRowWidget.buildResults,
          isAMetricsTableHeaderPlaceholder,
        );
      },
    );

    testWidgets(
      "applies the loading placeholder to the performance",
      (tester) async {
        await tester.pumpWidget(_MetricsTableLoadingHeaderTestbed());

        final metricsTableRowWidget = findMetricsTableRow(tester);

        expect(
          metricsTableRowWidget.performance,
          isAMetricsTableHeaderPlaceholder,
        );
      },
    );

    testWidgets(
      "applies the loading placeholder to the build number",
      (tester) async {
        await tester.pumpWidget(_MetricsTableLoadingHeaderTestbed());

        final metricsTableRowWidget = findMetricsTableRow(tester);

        expect(
          metricsTableRowWidget.buildNumber,
          isAMetricsTableHeaderPlaceholder,
        );
      },
    );

    testWidgets(
      "applies the loading placeholder to the stability",
      (tester) async {
        await tester.pumpWidget(_MetricsTableLoadingHeaderTestbed());

        final metricsTableRowWidget = findMetricsTableRow(tester);

        expect(
          metricsTableRowWidget.stability,
          isAMetricsTableHeaderPlaceholder,
        );
      },
    );

    testWidgets(
      "applies the loading placeholder to the coverage",
      (tester) async {
        await tester.pumpWidget(_MetricsTableLoadingHeaderTestbed());

        final metricsTableRowWidget = findMetricsTableRow(tester);

        expect(
          metricsTableRowWidget.coverage,
          isAMetricsTableHeaderPlaceholder,
        );
      },
    );
  });
}

/// A testbed class required to test the [MetricsTableLoadingHeader] widget.
class _MetricsTableLoadingHeaderTestbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MetricsTableLoadingHeader(),
      ),
    );
  }
}
