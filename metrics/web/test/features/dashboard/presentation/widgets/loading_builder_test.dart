import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/features/dashboard/presentation/widgets/loading_builder.dart';

void main() {
  testWidgets(
    "Can't create a LoadingBuilder without a builder",
    (WidgetTester tester) async {
      await tester.pumpWidget(const LoadingBuilderTestbed(builder: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Can't create a LoadingBuilder when the isLoading is null",
    (WidgetTester tester) async {
      await tester.pumpWidget(const LoadingBuilderTestbed(isLoading: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "When isLoading true - shows the loadingPlaceholder",
    (WidgetTester tester) async {
      await tester.pumpWidget(const LoadingBuilderTestbed(
        isLoading: true,
      ));

      expect(find.byType(LoadingPlaceholder), findsOneWidget);
    },
  );

  testWidgets(
    "When isLoading false - builder function is called",
    (WidgetTester tester) async {
      bool isBuilderFunctionCalled = false;

      await tester.pumpWidget(LoadingBuilderTestbed(
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

class LoadingBuilderTestbed extends StatelessWidget {
  final bool isLoading;
  final WidgetBuilder builder;
  final Widget loadingPlaceholder;

  const LoadingBuilderTestbed({
    Key key,
    this.isLoading = false,
    this.builder = _defaultBuilder,
    this.loadingPlaceholder = const LoadingPlaceholder(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoadingBuilder(
          isLoading: isLoading,
          builder: builder,
        ),
      ),
    );
  }

  static Widget _defaultBuilder(BuildContext context) {
    return Container();
  }
}
