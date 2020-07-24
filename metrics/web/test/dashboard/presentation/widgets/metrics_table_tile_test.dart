import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';

import '../../../test_utils/dimensions_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsTableRow", () {
    const nameText = 'name';

    setUpAll(() {
      DimensionsUtil.setTestWindowSize(width: DimensionsConfig.contentWidth);
    });

    tearDownAll(() {
      DimensionsUtil.clearTestWindowSize();
    });

    testWidgets(
      "throws an AssertionError if the given name is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(name: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given build number is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            buildNumber: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given build results is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            buildResults: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given performance is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            performance: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given stability is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            stability: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given coverage is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            coverageColumn: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given name",
      (tester) async {
        const name = Text(nameText);

        await tester.pumpWidget(
          const _DashboardTableTileTestbed(name: name),
        );

        expect(find.byWidget(name), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given build results",
      (tester) async {
        const buildResults = Text('build results');
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            buildResults: buildResults,
          ),
        );

        expect(find.byWidget(buildResults), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given performance",
      (tester) async {
        const performance = Text('performance');
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            performance: performance,
          ),
        );

        expect(find.byWidget(performance), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given build number",
      (tester) async {
        const buildNumber = Text('build number');
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            buildNumber: buildNumber,
          ),
        );

        expect(find.byWidget(buildNumber), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given stability",
      (tester) async {
        const stability = Text('stability');
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            stability: stability,
          ),
        );

        expect(find.byWidget(stability), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given coverage",
      (tester) async {
        const coverage = Text('coverage');
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            coverageColumn: coverage,
          ),
        );

        expect(find.byWidget(coverage), findsOneWidget);
      },
    );
  });
}

/// A testbed class needed to test the [MetricsTableRow].
class _DashboardTableTileTestbed extends StatelessWidget {
  /// A first column of this widget.
  final Widget name;

  /// A [Widget] that displays an information about build results.
  final Widget buildResults;

  /// A [Widget] that displays an information about a performance metric.
  final Widget performance;

  /// A [Widget] that displays an information about a builds count.
  final Widget buildNumber;

  /// A [Widget] that displays an information about a stability metric.
  final Widget stability;

  /// A [Widget] that displays an information about a coverage metric.
  final Widget coverageColumn;

  /// Creates the instance of this testbed.
  ///
  /// If the [name], [buildResults], [performance],
  /// [buildNumber], [stability] or [coverageColumn] is not specified,
  /// the [SizedBox] used.
  const _DashboardTableTileTestbed({
    Key key,
    this.name = const SizedBox(),
    this.buildResults = const SizedBox(),
    this.performance = const SizedBox(),
    this.buildNumber = const SizedBox(),
    this.stability = const SizedBox(),
    this.coverageColumn = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: MetricsTableRow(
        name: name,
        buildResults: buildResults,
        performance: performance,
        buildNumber: buildNumber,
        stability: stability,
        coverage: coverageColumn,
      ),
    );
  }
}
