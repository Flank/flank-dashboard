// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_header.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_loading_header.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_title_header.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/dimensions_util.dart';
import '../../../test_utils/project_metrics_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("MetricsTableHeader", () {
    setUpAll(() {
      DimensionsUtil.setTestWindowSize(width: DimensionsConfig.contentWidth);
    });

    tearDownAll(() {
      DimensionsUtil.clearTestWindowSize();
    });

    testWidgets(
      "displays the metrics table header title if project metrics are not loading",
      (tester) async {
        final notifier = ProjectMetricsNotifierMock();
        when(notifier.isMetricsLoading).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_DashboardTableHeaderTestbed(
            metricsNotifier: notifier,
          ));
        });

        expect(find.byType(MetricsTableTitleHeader), findsOneWidget);
      },
    );

    testWidgets(
      "displays the metrics table loading header if project metrics are loading",
      (tester) async {
        final notifier = ProjectMetricsNotifierMock();
        when(notifier.isMetricsLoading).thenReturn(true);

        await tester.pumpWidget(_DashboardTableHeaderTestbed(
          metricsNotifier: notifier,
        ));

        expect(find.byType(MetricsTableLoadingHeader), findsOneWidget);
      },
    );
  });
}

/// A testbed class required to test the [MetricsTableHeader] widget.
class _DashboardTableHeaderTestbed extends StatelessWidget {
  /// A [ProjectMetricsNotifier] that will injected and used in tests.
  final ProjectMetricsNotifier metricsNotifier;

  /// Creates an instance of the dashboard table header testbed
  /// with the given [metricsNotifier].
  const _DashboardTableHeaderTestbed({
    Key key,
    this.metricsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestInjectionContainer(
        metricsNotifier: metricsNotifier,
        child: const MetricsTableHeader(),
      ),
    );
  }
}
