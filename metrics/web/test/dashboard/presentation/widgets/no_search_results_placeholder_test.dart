import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/no_search_results_placeholder.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("NoSearchResultsPlaceholder", () {
    testWidgets(
      'displays the no search results placeholder',
      (WidgetTester tester) async {
        await tester.pumpWidget(const NoSearchResultsPlaceholderTestbed());

        expect(find.text(DashboardStrings.noSearchResults), findsOneWidget);
      },
    );
  });
}

class NoSearchResultsPlaceholderTestbed extends StatelessWidget {
  const NoSearchResultsPlaceholderTestbed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MetricsThemedTestbed(
      body: NoSearchResultsPlaceholder(),
    );
  }
}
