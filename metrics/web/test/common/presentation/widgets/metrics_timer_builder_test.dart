// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_timer_builder.dart';
import 'package:metrics/dashboard/presentation/state/timer_notifier.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsTimerBuilder", () {
    const child = Text('child');

    TimerNotifier timerNotifier;

    setUp(() {
      timerNotifier = _TimerNotifierMock();
    });

    testWidgets(
      "throws an AssertionError if the given rebuilds enabled is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsTimerBuilderTestbed(
            rebuildsEnabled: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsTimerBuilderTestbed(
            builder: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays a child built using the given builder",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _MetricsTimerBuilderTestbed(
            builder: (_) => child,
          ),
        );

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "rebuilds on a timer notifier's tick if the given rebuilds enabled is true",
      (WidgetTester tester) async {
        int buildsCount = 0;

        await tester.pumpWidget(
          _MetricsTimerBuilderTestbed(
            timerNotifier: timerNotifier,
            rebuildsEnabled: true,
            builder: (_) {
              buildsCount++;

              return child;
            },
          ),
        );

        final buildsCountAfterBuild = buildsCount;

        timerNotifier.notifyListeners();
        await tester.pump();

        expect(buildsCount, equals(buildsCountAfterBuild + 1));
      },
    );

    testWidgets(
      "displays a child built using the given builder after a rebuild",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _MetricsTimerBuilderTestbed(
            timerNotifier: timerNotifier,
            rebuildsEnabled: true,
            builder: (_) => child,
          ),
        );

        timerNotifier.notifyListeners();
        await tester.pump();

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "does not rebuild on a timer notifier's tick if the given rebuilds enabled is false",
      (WidgetTester tester) async {
        int buildsCount = 0;

        await tester.pumpWidget(
          _MetricsTimerBuilderTestbed(
            timerNotifier: timerNotifier,
            rebuildsEnabled: false,
            builder: (_) {
              buildsCount++;

              return child;
            },
          ),
        );

        final buildsCountAfterBuild = buildsCount;

        timerNotifier.notifyListeners();
        await tester.pump();

        expect(buildsCount, equals(buildsCountAfterBuild));
      },
    );
  });
}

/// A testbed class needed to test the [MetricsTimerBuilder] widget.
class _MetricsTimerBuilderTestbed extends StatelessWidget {
  /// A default [WidgetBuilder] to use in tests.
  static Widget _defaultBuilder(BuildContext context) {
    return const Text('');
  }

  /// A flag that indicates whether this widget should rebuild
  /// on a [TimerNotifier]'s tick in tests.
  final bool rebuildsEnabled;

  /// A [WidgetBuilder] used to build a child of the [MetricsTimerBuilder]
  /// in tests.
  final WidgetBuilder builder;

  /// A [TimerNotifier] to use in tests.
  final TimerNotifier timerNotifier;

  /// Creates a new instance of this testbed with the given parameters.
  const _MetricsTimerBuilderTestbed({
    this.rebuildsEnabled = true,
    this.builder = _defaultBuilder,
    this.timerNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TestInjectionContainer(
          timerNotifier: timerNotifier,
          child: MetricsTimerBuilder(
            rebuildsEnabled: rebuildsEnabled,
            builder: builder,
          ),
        ),
      ),
    );
  }
}

class _TimerNotifierMock extends Mock
    with ChangeNotifier
    implements TimerNotifier {}
