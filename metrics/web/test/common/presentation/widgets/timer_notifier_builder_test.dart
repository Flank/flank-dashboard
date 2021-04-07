// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/timer_notifier_builder.dart';
import 'package:metrics/dashboard/presentation/state/timer_notifier.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("TimerNotifierBuilder", () {
    const child = Text('child');

    TimerNotifier timerNotifier;

    setUp(() {
      timerNotifier = _TimerNotifierMock();
    });

    testWidgets(
      "throws an AssertionError if the given should subscribe is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _TimerNotifierBuilderTestbed(
            shouldSubscribe: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _TimerNotifierBuilderTestbed(
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
          _TimerNotifierBuilderTestbed(
            builder: (_) => child,
          ),
        );

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "rebuilds on a timer notifier's tick if the given should subscribe is true",
      (WidgetTester tester) async {
        int buildsCount = 0;

        await tester.pumpWidget(
          _TimerNotifierBuilderTestbed(
            timerNotifier: timerNotifier,
            shouldSubscribe: true,
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
      "displays a child built using the given builder on a timer notifier's tick",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _TimerNotifierBuilderTestbed(
            timerNotifier: timerNotifier,
            shouldSubscribe: true,
            builder: (_) => child,
          ),
        );

        timerNotifier.notifyListeners();
        await tester.pump();

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "does not rebuild on a timer notifier's tick if the given should subscribe is false",
      (WidgetTester tester) async {
        int buildsCount = 0;

        await tester.pumpWidget(
          _TimerNotifierBuilderTestbed(
            timerNotifier: timerNotifier,
            shouldSubscribe: false,
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

/// A testbed class needed to test the [TimerNotifierBuilder] widget.
class _TimerNotifierBuilderTestbed extends StatelessWidget {
  /// A default [WidgetBuilder] to use in tests.
  static Widget _defaultBuilder(BuildContext context) {
    return const Text('');
  }

  /// A flag that indicates whether this widget should subscribe to a
  /// [TimerNotifier]'s tick in tests.
  final bool shouldSubscribe;

  /// A [WidgetBuilder] used to build a child of the [TimerNotifierBuilder]
  /// in tests.
  final WidgetBuilder builder;

  /// A [TimerNotifier] to use in tests.
  final TimerNotifier timerNotifier;

  /// Creates a new instance of this testbed with the given parameters.
  const _TimerNotifierBuilderTestbed({
    this.shouldSubscribe = true,
    this.builder = _defaultBuilder,
    this.timerNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TestInjectionContainer(
          timerNotifier: timerNotifier,
          child: TimerNotifierBuilder(
            shouldSubscribe: shouldSubscribe,
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
