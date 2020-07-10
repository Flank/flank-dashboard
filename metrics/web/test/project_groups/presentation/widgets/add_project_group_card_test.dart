import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/base/presentation/widgets/padded_card.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("AddProjectGroupCard", () {
    testWidgets(
      "changes the cursor style for the card",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _AddProjectGroupCardTestbed());
        });

        final finder = find.byWidgetPredicate(
          (widget) => widget is PaddedCard && widget.child is HandCursor,
        );

        expect(finder, findsOneWidget);
      },
    );
  });
}

/// A testbed class required to test the [AddProjectGroupCard] widget.
class _AddProjectGroupCardTestbed extends StatelessWidget {
  /// A [MetricsThemeData] used in this testbed.
  final MetricsThemeData theme;

  /// Creates an instance of the [_AddProjectGroupCardTestbed] with
  /// the given [theme].
  const _AddProjectGroupCardTestbed({
    Key key,
    this.theme = const DarkMetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: AddProjectGroupCard(),
    );
  }
}
