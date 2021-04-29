// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/widgets/theme_mode_builder.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/test_injection_container.dart';
import '../../../test_utils/theme_notifier_mock.dart';

// ignore_for_file: avoid_redundant_argument_values, avoid_positional_boolean_parameters

void main() {
  group("ThemeModeBuilder", () {
    const lightThemeChild = Text('light');
    const darkThemeChild = Text('dark');

    ThemeNotifierMock themeNotifier;

    final themeTypeBuilderFinder = find.byType(ThemeModeBuilder);

    Widget builder(BuildContext context, bool isDark, Widget child) {
      return isDark ? darkThemeChild : lightThemeChild;
    }

    setUp(() {
      themeNotifier = ThemeNotifierMock();
    });

    testWidgets(
      "throws an AssertionError if the given builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _ThemeModeBuilderTestbed(
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
          _ThemeModeBuilderTestbed(
            builder: builder,
          ),
        );

        final themeTypeBuilder = tester.widget<ThemeModeBuilder>(
          themeTypeBuilderFinder,
        );

        expect(themeTypeBuilder.builder, equals(builder));
      },
    );

    testWidgets(
      "calls the given builder with the given child",
      (WidgetTester tester) async {
        const child = Text('test');
        await tester.pumpWidget(
          _ThemeModeBuilderTestbed(
            builder: (_, __, child) => child,
            child: child,
          ),
        );

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "calls the given builder with the current theme mode",
      (WidgetTester tester) async {
        when(themeNotifier.isDark).thenReturn(true);

        await tester.pumpWidget(
          _ThemeModeBuilderTestbed(
            builder: builder,
            themeNotifier: themeNotifier,
          ),
        );

        expect(find.byWidget(darkThemeChild), findsOneWidget);
      },
    );

    testWidgets(
      "rebuilds a child on a theme mode change",
      (WidgetTester tester) async {
        when(themeNotifier.isDark).thenReturn(true);

        await tester.pumpWidget(
          _ThemeModeBuilderTestbed(
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

/// A testbed class that is used to test the [ThemeModeBuilder] widget.
class _ThemeModeBuilderTestbed extends StatelessWidget {
  /// A [ThemeNotifier] to use in tests.
  final ThemeNotifier themeNotifier;

  /// A [ThemeModeWidgetBuilder] callback to apply to the widget under tests.
  final ThemeModeWidgetBuilder builder;

  /// A child [Widget] of the [ThemeModeBuilder] to apply to the widget under
  /// tests.
  final Widget child;

  /// Creates a new instance of the [_ThemeModeBuilderTestbed] with the given
  /// [builder], [child], and [themeNotifier].
  const _ThemeModeBuilderTestbed({
    Key key,
    this.builder,
    this.child,
    this.themeNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestInjectionContainer(
        themeNotifier: themeNotifier,
        child: ThemeModeBuilder(
          builder: builder,
          child: child,
        ),
      ),
    );
  }
}
