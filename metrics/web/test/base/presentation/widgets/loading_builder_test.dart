import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/loading_builder.dart';
import 'package:metrics/base/presentation/widgets/loading_placeholder.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LoadingBuilder", () {
    testWidgets(
      "can't be created when the builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _LoadingBuilderTestbed(builder: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "can't be created when the isLoading is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _LoadingBuilderTestbed(isLoading: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "can't be created when the loadingPlaceholder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _LoadingBuilderTestbed(loadingPlaceholder: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the loading placeholder if the isLoading is true",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _LoadingBuilderTestbed(
          isLoading: true,
        ));

        expect(find.byType(LoadingPlaceholder), findsOneWidget);
      },
    );

    testWidgets(
      "builds using the builder function when the isLoading is false",
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
  });
}

/// A testbed class required to test the [LoadingBuilder] widget.
class _LoadingBuilderTestbed extends StatelessWidget {
  /// Defines whether data is loading.
  final bool isLoading;

  /// A [WidgetBuilder] used to build a child if data is not loading.
  final WidgetBuilder builder;

  /// A loading placeholder shown while isLoading is true.
  final Widget loadingPlaceholder;

  /// Creates a [_LoadingBuilderTestbed].
  ///
  /// If [isLoading] is not specified, the `false` value used.
  /// If [builder] is not specified, the default builder used.
  /// If [loadingPlaceholder] is not specified, the [LoadingPlaceholder] used.
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
        loadingPlaceholder: loadingPlaceholder,
      ),
    );
  }

  /// A default builder used if the [builder] is not specified.
  static Widget _defaultBuilder(BuildContext context) {
    return Container();
  }
}
