import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/routes/observers/firebase_analytics_observer.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("FirebaseAnalyticsObserver", () {
    final mockFirebaseAnalytics = FirebaseAnalyticsMock();
    final observer =
        FirebaseAnalyticsObserver(analytics: mockFirebaseAnalytics);
    test(
      "throws an AssertionError if the given analytics is null",
      () {
        expect(
          () => FirebaseAnalyticsObserver(analytics: null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );
    test('.didPush does not log event if route is not PageRoute', () {
      final route = StubPopupRoute();
      observer.didPush(route, null);
      verifyZeroInteractions(mockFirebaseAnalytics);
    });
    test('.didPush does not log event if route is null', () {
      observer.didPush(null, null);
      verifyZeroInteractions(mockFirebaseAnalytics);
    });
    test('.didPush does not log event if route.settings.name is null', () {
      final route = MaterialPageRoute(
        settings: const RouteSettings(name: null),
        builder: (_) => const Text('test'),
      );
      observer.didPush(route, null);
      verifyZeroInteractions(mockFirebaseAnalytics);
    });

    test('.didPush does not log event if route is root', () {
      final route = MaterialPageRoute(
        settings: const RouteSettings(name: '/'),
        builder: (_) => const Text('test'),
      );
      observer.didPush(route, null);
      verifyZeroInteractions(mockFirebaseAnalytics);
    });

    test('.didPush logs analytics event', () {
      final route = MaterialPageRoute(
        settings: const RouteSettings(name: '/test'),
        builder: (_) => const Text('test'),
      );
      observer.didPush(route, null);
      verify(mockFirebaseAnalytics.logEvent(name: 'test_page_view'))
          .called(equals(1));
    });
    test('.didReplace logs analytics event', () {
      final route = MaterialPageRoute(
        settings: const RouteSettings(name: '/test'),
        builder: (_) => const Text('test'),
      );
      observer.didReplace(newRoute: route);
      verify(mockFirebaseAnalytics.logEvent(name: 'test_page_view'))
          .called(equals(1));
    });

    test('.didPop logs analytics event', () {
      final route = MaterialPageRoute(
        settings: const RouteSettings(name: '/test'),
        builder: (_) => const Text('test'),
      );
      observer.didPop(null, route);
      verify(mockFirebaseAnalytics.logEvent(name: 'test_page_view'))
          .called(equals(1));
    });
  });
}

class FirebaseAnalyticsMock extends Mock implements FirebaseAnalytics {}

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
