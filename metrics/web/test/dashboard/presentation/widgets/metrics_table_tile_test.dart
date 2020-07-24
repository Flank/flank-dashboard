import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_tile.dart';

import '../../../test_utils/dimension_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("MetricsTableTile", () {
    const leadingText = 'leading';

    setUpAll(() {
      DimensionUtil.setTestWindowSize(width: DimensionsConfig.contentWidth);
    });

    tearDownAll(() {
      DimensionUtil.clearTestWindowSize();
    });

    testWidgets(
      "throws an AssertionError if the given leading is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(leading: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given build number column is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            buildNumberColumn: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given build results column is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            buildResultsColumn: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given performance column is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            performanceColumn: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given stability column is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            stabilityColumn: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given coverage column is null",
      (tester) async {
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            stabilityColumn: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given leading",
      (tester) async {
        const leading = Text(leadingText);

        await tester.pumpWidget(
          const _DashboardTableTileTestbed(leading: leading),
        );

        expect(find.byWidget(leading), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given build results column",
      (tester) async {
        const buildResultsColumn = Text('build results column');
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            buildResultsColumn: buildResultsColumn,
          ),
        );

        expect(find.byWidget(buildResultsColumn), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given performance column",
      (tester) async {
        const performance = Text('performance column');
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            performanceColumn: performance,
          ),
        );

        expect(find.byWidget(performance), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given build number column",
      (tester) async {
        const buildNumber = Text('build number column');
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            leading: Text(leadingText),
            buildNumberColumn: buildNumber,
          ),
        );

        expect(find.byWidget(buildNumber), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given stability column",
      (tester) async {
        const stability = Text('stability column');
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            leading: Text(leadingText),
            stabilityColumn: stability,
          ),
        );

        expect(find.byWidget(stability), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given coverage column",
      (tester) async {
        const coverage = Text('coverage column');
        await tester.pumpWidget(
          const _DashboardTableTileTestbed(
            leading: Text(leadingText),
            coverageColumn: coverage,
          ),
        );

        expect(find.byWidget(coverage), findsOneWidget);
      },
    );
  });
}

/// A testbed class needed to test the [MetricsTableTile].
class _DashboardTableTileTestbed extends StatelessWidget {
  /// A first column of this widget.
  final Widget leading;

  /// A column that displays an information about build results.
  final Widget buildResultsColumn;

  /// A column that displays an information about a performance metric.
  final Widget performanceColumn;

  /// A column that displays an information about a builds count.
  final Widget buildNumberColumn;

  /// A column that displays an information about a stability metric.
  final Widget stabilityColumn;

  /// A column that displays an information about a coverage metric.
  final Widget coverageColumn;

  /// Creates the instance of this testbed.
  ///
  /// If the [leading], [buildResultsColumn], [performanceColumn],
  /// [buildNumberColumn], [stabilityColumn] or [coverageColumn] is not specified,
  /// the [SizedBox] used.
  const _DashboardTableTileTestbed({
    Key key,
    this.leading = const SizedBox(),
    this.buildResultsColumn = const SizedBox(),
    this.performanceColumn = const SizedBox(),
    this.buildNumberColumn = const SizedBox(),
    this.stabilityColumn = const SizedBox(),
    this.coverageColumn = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: MetricsTableTile(
        leading: leading,
        buildResultsColumn: buildResultsColumn,
        performanceColumn: performanceColumn,
        buildNumberColumn: buildNumberColumn,
        stabilityColumn: stabilityColumn,
        coverageColumn: coverageColumn,
      ),
    );
  }
}
