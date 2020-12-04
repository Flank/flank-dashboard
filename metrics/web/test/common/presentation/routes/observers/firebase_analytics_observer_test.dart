import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/routes/observers/firebase_analytics_observer.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/analytics_notifier_mock.dart';
import '../../../../test_utils/matcher_util.dart';

void main() {
  group("FirebaseAnalyticsObserver", () {
    final analyticsNotifier = AnalyticsNotifierMock();

    final observer = FirebaseAnalyticsObserver(
      analyticsNotifier: analyticsNotifier,
    );

    setUp(() {
      reset(analyticsNotifier);
    });

    test("throws an AssertionError if the given notifier is null", () {
      expect(
        () => FirebaseAnalyticsObserver(analyticsNotifier: null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test('.didPush does not log event if route is not PageRoute', () {
      final route = StubPopupRoute();

      observer.didPush(route, null);

      verifyNever(analyticsNotifier.logPageView(any));
    });

    test('.didPop does not log event if route is not PageRoute', () {
      final route = StubPopupRoute();

      observer.didPop(null, route);

      verifyNever(analyticsNotifier.logPageView(any));
    });

    test('.didReplace does not log event if route is not PageRoute', () {
      final route = StubPopupRoute();

      observer.didReplace(newRoute: route);

      verifyNever(analyticsNotifier.logPageView(any));
    });

    test('.didPush logs analytics event', () {
      final route = MaterialPageRoute(
        settings: const RouteSettings(name: '/test'),
        builder: (_) => const Text('test'),
      );

      observer.didPush(route, null);

      verify(analyticsNotifier.logPageView(any)).called(1);
    });

    test('.didReplace logs analytics event', () {
      final route = MaterialPageRoute(
        settings: const RouteSettings(name: '/test'),
        builder: (_) => const Text('test'),
      );

      observer.didReplace(newRoute: route);

      verify(analyticsNotifier.logPageView(any)).called(1);
    });

    test('.didPop logs analytics event', () {
      final route = MaterialPageRoute(
        settings: const RouteSettings(name: '/test'),
        builder: (_) => const Text('test'),
      );

      observer.didPop(null, route);

      verify(analyticsNotifier.logPageView(any)).called(1);
    });
  });
}

/// A stub implementation of the [PopupRoute] used for testing.
class StubPopupRoute extends PopupRoute {
  @override
  Color get barrierColor => Colors.white;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => 'test';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return const Text('test');
  }

  @override
  Duration get transitionDuration => Duration.zero;
}
