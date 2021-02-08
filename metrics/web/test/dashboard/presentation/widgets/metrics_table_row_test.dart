// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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
      "throws an AssertionError if the given status is null",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsTableRowTestbed(status: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given name is null",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsTableRowTestbed(name: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given build number is null",
      (tester) async {
        await tester.pumpWidget(
          const _MetricsTableRowTestbed(
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
          const _MetricsTableRowTestbed(
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
          const _MetricsTableRowTestbed(
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
          const _MetricsTableRowTestbed(
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
          const _MetricsTableRowTestbed(
            coverage: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given status",
      (tester) async {
        const status = Text("status");

        await tester.pumpWidget(
          const _MetricsTableRowTestbed(status: status),
        );

        expect(find.byWidget(status), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given status",
      (tester) async {
        const status = Text("status");

        await tester.pumpWidget(
          const _MetricsTableRowTestbed(status: status),
        );

        expect(find.byWidget(status), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given name",
      (tester) async {
        const name = Text(nameText);

        await tester.pumpWidget(
          const _MetricsTableRowTestbed(name: name),
        );

        expect(find.byWidget(name), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given build results",
      (tester) async {
        const buildResults = Text('build results');
        await tester.pumpWidget(
          const _MetricsTableRowTestbed(
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
          const _MetricsTableRowTestbed(
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
          const _MetricsTableRowTestbed(
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
          const _MetricsTableRowTestbed(
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
          const _MetricsTableRowTestbed(
            coverage: coverage,
          ),
        );

        expect(find.byWidget(coverage), findsOneWidget);
      },
    );
  });
}

/// A testbed class needed to test the [MetricsTableRow].
class _MetricsTableRowTestbed extends StatelessWidget {
  /// A [Widget] that displays a project status.
  final Widget status;

  /// A [Widget] that displays a project name.
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
  final Widget coverage;

  /// Creates the instance of this testbed.
  ///
  /// If the [status], [name], [buildResults], [performance],
  /// [buildNumber], [stability] or [coverage] is not specified,
  /// the [SizedBox] used.
  const _MetricsTableRowTestbed({
    Key key,
    this.status = const SizedBox(),
    this.name = const SizedBox(),
    this.buildResults = const SizedBox(),
    this.performance = const SizedBox(),
    this.buildNumber = const SizedBox(),
    this.stability = const SizedBox(),
    this.coverage = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: MetricsTableRow(
        status: status,
        name: name,
        buildResults: buildResults,
        performance: performance,
        buildNumber: buildNumber,
        stability: stability,
        coverage: coverage,
      ),
    );
  }
}
