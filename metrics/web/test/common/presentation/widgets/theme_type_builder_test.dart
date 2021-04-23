// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/widgets/theme_type_builder.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/test_injection_container.dart';
import '../../../test_utils/theme_notifier_mock.dart';

// ignore_for_file: avoid_redundant_argument_values, avoid_positional_boolean_parameters

void main() {
  group("ThemeTypeBuilder", () {
    const lightThemeChild = Text('light');
    const darkThemeChild = Text('dark');

    ThemeNotifierMock themeNotifier;

    final themeTypeBuilderFinder = find.byType(ThemeTypeBuilder);

    Widget builder(BuildContext context, bool isDark) {
      return isDark ? darkThemeChild : lightThemeChild;
    }

    setUp(() {
      themeNotifier = ThemeNotifierMock();
    });

    testWidgets(
      "throws an AssertionError if the given builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _ThemeTypeBuilderTestbed(
            builder: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "creates an instance with the given builder",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _ThemeTypeBuilderTestbed(
            builder: builder,
          ),
        );

        final themeTypeBuilder = tester.widget<ThemeTypeBuilder>(
          themeTypeBuilderFinder,
        );

        expect(themeTypeBuilder.builder, equals(builder));
      },
    );

    testWidgets(
      "provides an '.isDark' value of a ThemeNotifier to the given builder",
      (WidgetTester tester) async {
        when(themeNotifier.isDark).thenReturn(true);

        await tester.pumpWidget(
          _ThemeTypeBuilderTestbed(
            builder: builder,
            themeNotifier: themeNotifier,
          ),
        );

        expect(find.byWidget(darkThemeChild), findsOneWidget);
      },
    );

    testWidgets(
      "rebuilds a child on a theme type change",
      (WidgetTester tester) async {
        when(themeNotifier.isDark).thenReturn(true);

        await tester.pumpWidget(
          _ThemeTypeBuilderTestbed(
            builder: builder,
            themeNotifier: themeNotifier,
          ),
        );

        when(themeNotifier.isDark).thenReturn(false);
        themeNotifier.notifyListeners();
        await tester.pump();

        expect(find.byWidget(lightThemeChild), findsOneWidget);
      },
    );
  });
}

/// A testbed class needed to test the [ThemeTypeBuilder] widget.
class _ThemeTypeBuilderTestbed extends StatelessWidget {
  /// A [ThemeNotifier] used in tests.
  final ThemeNotifier themeNotifier;

  /// A [ThemeTypeWidgetBuilder] used in tests.
  final ThemeTypeWidgetBuilder builder;

  /// Creates a new instance of this testbed with the given [builder]
  /// and the [themeNotifier].
  const _ThemeTypeBuilderTestbed({
    Key key,
    this.builder,
    this.themeNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestInjectionContainer(
        themeNotifier: themeNotifier,
        child: ThemeTypeBuilder(
          builder: builder,
        ),
      ),
    );
  }
}
