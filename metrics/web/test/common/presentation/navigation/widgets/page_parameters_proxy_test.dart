// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/navigation/widgets/page_parameters_proxy.dart';
import 'package:metrics/common/presentation/state/page_notifier.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_utils/matchers.dart';
import '../../../../test_utils/navigation_notifier_mock.dart';
import '../../../../test_utils/page_notifier_mock.dart';
import '../../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("PageParametersProxy", () {
    final pageNotifier = PageNotifierMock();

    tearDown(() {
      reset(pageNotifier);
    });

    testWidgets(
      "throws an AssertionError if the given child is null",
      (tester) async {
        await tester.pumpWidget(
          _PageParametersProxyTestbed(pageNotifier: pageNotifier, child: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given page notifier is null",
      (tester) async {
        await tester.pumpWidget(
          const _PageParametersProxyTestbed(pageNotifier: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given child",
      (tester) async {
        const textWidget = Text('test');

        await tester.pumpWidget(
          _PageParametersProxyTestbed(
            pageNotifier: pageNotifier,
            child: textWidget,
          ),
        );

        final child = find.descendant(
          of: find.byType(PageParametersProxy),
          matching: find.byWidget(textWidget),
        );

        expect(child, findsOneWidget);
      },
    );

    testWidgets(
      "delegates to the page notifier if the navigation notifier notifies about changes",
      (tester) async {
        final navigationNotifier = NavigationNotifierMock();

        await tester.pumpWidget(
          _PageParametersProxyTestbed(
            pageNotifier: pageNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        navigationNotifier.notifyListeners();

        verify(pageNotifier.handlePageParameters(any)).called(once);
      },
    );

    testWidgets(
      "delegates to the navigation notifier if the page notifier notifies about changes",
      (tester) async {
        final navigationNotifier = NavigationNotifierMock();

        await tester.pumpWidget(
          _PageParametersProxyTestbed(
            pageNotifier: pageNotifier,
            navigationNotifier: navigationNotifier,
          ),
        );

        pageNotifier.notifyListeners();

        verify(navigationNotifier.handlePageParametersUpdates(any))
            .called(once);
      },
    );
  });
}

/// A testbed class required to test the [PageParametersProxy] widget.
class _PageParametersProxyTestbed extends StatelessWidget {
  /// A default child widget used in tests.
  static const Widget _defaultChild = Text('default text');

  /// A child [Widget] to display.
  final Widget child;

  /// A [PageNotifier] used in tests.
  final PageNotifier pageNotifier;

  /// A [NavigationNotifier] used in tests.
  final NavigationNotifier navigationNotifier;

  /// Creates an instance of this testbed with the given parameters.
  ///
  /// The [child] defaults to [_defaultChild].
  const _PageParametersProxyTestbed({
    Key key,
    this.child = _defaultChild,
    this.pageNotifier,
    this.navigationNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      pageNotifier: pageNotifier,
      navigationNotifier: navigationNotifier,
      child: MaterialApp(
        home: Scaffold(
          body: PageParametersProxy(
            pageNotifier: pageNotifier,
            child: child,
          ),
        ),
      ),
    );
  }
}
