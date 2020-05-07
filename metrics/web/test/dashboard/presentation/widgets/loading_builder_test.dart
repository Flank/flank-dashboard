import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/widgets/loading_builder.dart';
import 'package:metrics/common/presentation/widgets/loading_placeholder.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  testWidgets(
    "Can't create a LoadingBuilder without a builder",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _LoadingBuilderTestbed(builder: null));

      expect(tester.takeException(), isAssertionError);
    },
  );

  testWidgets(
    "Can't create a LoadingBuilder when the isLoading is null",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _LoadingBuilderTestbed(isLoading: null));

      expect(tester.takeException(), isAssertionError);
    },
  );

  testWidgets(
    "When isLoading true - shows the loadingPlaceholder",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _LoadingBuilderTestbed(
        isLoading: true,
      ));

      expect(find.byType(LoadingPlaceholder), findsOneWidget);
    },
  );

  testWidgets(
    "When isLoading false - builder function is called",
    (WidgetTester tester) async {
      bool isBuilderFunctionCalled = false;

      await tester.pumpWidget(_LoadingBuilderTestbed(
        isLoading: false,
        builder: (context) {
          isBuilderFunctionCalled = true;
          return Container();
        },
      ));

      expect(isBuilderFunctionCalled, isTrue);
    },
  );
}

class _LoadingBuilderTestbed extends StatelessWidget {
  final bool isLoading;
  final WidgetBuilder builder;
  final Widget loadingPlaceholder;

  const _LoadingBuilderTestbed({
    Key key,
    this.isLoading = false,
    this.builder = _defaultBuilder,
    this.loadingPlaceholder = const LoadingPlaceholder(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: LoadingBuilder(
        isLoading: isLoading,
        builder: builder,
      ),
    );
  }

  static Widget _defaultBuilder(BuildContext context) {
    return Container();
  }
}
