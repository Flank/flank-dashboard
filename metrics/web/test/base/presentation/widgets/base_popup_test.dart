// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BasePopup", () {
    const testTriggerWidget = Text('trigger widget');
    const testPopupWidget = Text('popup widget');
    final triggerWidgetFinder = find.byWidget(testTriggerWidget);
    final popupWidgetFinder = find.byWidget(testPopupWidget);
    final constrainedBoxFinder = find.ancestor(
      of: popupWidgetFinder,
      matching: find.byType(ConstrainedBox),
    );

    Widget _defaultTriggerBuilder(
      BuildContext context,
      VoidCallback openPopup,
      VoidCallback closePopup,
      bool isPopupOpened,
    ) {
      return GestureDetector(
        onTap: openPopup,
        child: testTriggerWidget,
      );
    }

    void pushDefaultRoute(GlobalKey<NavigatorState> key) {
      key.currentState.push(MaterialPageRoute(
        builder: (context) => const Scaffold(),
      ));
    }

    testWidgets(
      "throws an AssertionError if the given trigger builder is null",
      (tester) async {
        await tester.pumpWidget(_BasePopupTestbed(triggerBuilder: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given popup widget is null",
      (tester) async {
        await tester.pumpWidget(_BasePopupTestbed(
          popup: null,
          triggerBuilder: _defaultTriggerBuilder,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given offset builder is null",
      (tester) async {
        await tester.pumpWidget(_BasePopupTestbed(
          offsetBuilder: null,
          triggerBuilder: _defaultTriggerBuilder,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the trigger widget built by the given trigger builder",
      (tester) async {
        await tester.pumpWidget(
          _BasePopupTestbed(triggerBuilder: _defaultTriggerBuilder),
        );

        expect(triggerWidgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the given popup widget when the trigger widget is tapped",
      (tester) async {
        await tester.pumpWidget(_BasePopupTestbed(
          popup: testPopupWidget,
          triggerBuilder: _defaultTriggerBuilder,
        ));

        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();

        expect(popupWidgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the offset built by the given offset builder to the popup",
      (tester) async {
        const offset = Offset(20.0, 20.0);

        await tester.pumpWidget(_BasePopupTestbed(
          offsetBuilder: (_) => offset,
          triggerBuilder: _defaultTriggerBuilder,
        ));

        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();

        final followerWidget = tester.widget<CompositedTransformFollower>(
          find.byType(CompositedTransformFollower),
        );

        expect(followerWidget.offset, equals(offset));
      },
    );

    testWidgets(
      "applies the given popup constraints to the popup widget",
      (WidgetTester tester) async {
        const boxConstraints = BoxConstraints(maxWidth: 50.0, maxHeight: 50.0);

        await tester.pumpWidget(
          _BasePopupTestbed(
            popupConstraints: boxConstraints,
            popup: testPopupWidget,
            triggerBuilder: _defaultTriggerBuilder,
          ),
        );

        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();

        final box = tester.widget<ConstrainedBox>(constrainedBoxFinder);
        final actualBoxConstraints = box.constraints;

        expect(actualBoxConstraints, equals(boxConstraints));
      },
    );

    testWidgets(
      "delegates the given opaque to the mouse region",
      (WidgetTester tester) async {
        const opaque = false;

        await tester.pumpWidget(
          _BasePopupTestbed(
            popupOpaque: opaque,
            popup: testPopupWidget,
            triggerBuilder: _defaultTriggerBuilder,
          ),
        );

        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();

        final mouseRegion = tester.widget<MouseRegion>(find.ancestor(
          of: popupWidgetFinder,
          matching: find.byType(MouseRegion),
        ));

        expect(mouseRegion.opaque, equals(opaque));
      },
    );

    testWidgets(
      "applies the default box constraints to the popup widget if the given popup constraints is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _BasePopupTestbed(
            popupConstraints: null,
            popup: testPopupWidget,
            triggerBuilder: _defaultTriggerBuilder,
          ),
        );

        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();

        final box = tester.widget<ConstrainedBox>(constrainedBoxFinder);
        final actualBoxConstraints = box.constraints;

        expect(actualBoxConstraints, isNotNull);
      },
    );

    testWidgets(
      "closes a popup after tap outside of the popup content if the close on tap outside is true",
      (tester) async {
        await tester.pumpWidget(_BasePopupTestbed(
          popup: testPopupWidget,
          triggerBuilder: _defaultTriggerBuilder,
          offsetBuilder: (size) {
            return Offset(size.width, size.height);
          },
          closeOnTapOutside: true,
        ));

        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();
        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();

        expect(popupWidgetFinder, findsNothing);
      },
    );

    testWidgets(
      "does not close a popup after tap outside of the popup content if the close on tap outside is false",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _BasePopupTestbed(
            popup: testPopupWidget,
            triggerBuilder: _defaultTriggerBuilder,
            offsetBuilder: (size) {
              return Offset(size.width, size.height);
            },
            closeOnTapOutside: false,
          ),
        );

        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();
        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();

        expect(popupWidgetFinder, findsOneWidget);
      },
    );

    testWidgets("opens only one popup", (WidgetTester tester) async {
      await tester.pumpWidget(
        _BasePopupTestbed(
          popup: testPopupWidget,
          triggerBuilder: _defaultTriggerBuilder,
          offsetBuilder: (size) {
            return Offset(size.width, size.height);
          },
          closeOnTapOutside: false,
        ),
      );

      await tester.tap(triggerWidgetFinder);
      await tester.tap(triggerWidgetFinder);
      await tester.tap(triggerWidgetFinder);
      await tester.pumpAndSettle();

      expect(popupWidgetFinder, findsOneWidget);
    });

    testWidgets(
      "closes a popup after pushing a new route",
      (tester) async {
        final _key = GlobalKey<NavigatorState>();

        await tester.pumpWidget(_BasePopupTestbed(
          navigatorKey: _key,
          popup: testPopupWidget,
          triggerBuilder: _defaultTriggerBuilder,
        ));

        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();
        pushDefaultRoute(_key);
        await tester.pumpAndSettle();

        expect(popupWidgetFinder, findsNothing);
      },
    );

    testWidgets(
      "closes a popup after popping the current route",
      (tester) async {
        final _key = GlobalKey<NavigatorState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => GestureDetector(onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => _BasePopupTestbed(
                        navigatorKey: _key,
                        popup: testPopupWidget,
                        triggerBuilder: _defaultTriggerBuilder,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();
        await tester.tap(triggerWidgetFinder);
        await tester.pumpAndSettle();
        _key.currentState.pop();
        await tester.pumpAndSettle();

        expect(popupWidgetFinder, findsNothing);
      },
    );
  });
}

/// A testbed class required to test the [BasePopup] widget.
class _BasePopupTestbed extends StatelessWidget {
  /// Builds the default offset.
  static Offset _defaultOffsetBuilder(Size size) => Offset.zero;

  /// A key to apply to the [Navigator].
  final GlobalKey<NavigatorState> navigatorKey;

  /// A [RouteObserver] to subscribe to the route callbacks.
  final RouteObserver routeObserver;

  /// A widget to display when a trigger widget is activated.
  final Widget popup;

  /// An additional constraints to apply to the [popup].
  final BoxConstraints popupConstraints;

  /// A callback that is called to build the [popup] offset from
  /// the trigger widget.
  final OffsetBuilder offsetBuilder;

  /// A callback that is called to build the trigger widget.
  final TriggerBuilder triggerBuilder;

  /// A [popup] behavior on tap outside to apply to the widget under tests.
  final bool closeOnTapOutside;

  /// A popup opaqueness to apply to the widget under tests.
  final bool popupOpaque;

  /// Creates the a new base popup testbed.
  ///
  /// The [popup] defaults to the [SizedBox] with the empty constructor.
  /// The [popupConstraints] defaults to an empty [BoxConstraints] instance.
  /// The [offsetBuilder] defaults to the [_defaultOffsetBuilder].
  /// The [closeOnTapOutside] defaults to the `true`.
  /// The [popupOpaque] defaults to the `true`.
  /// If the given [navigatorKey], the default [GlobalKey] instance is used.
  /// If the given [routeObserver], the default [RouteObserver] instance is used.
  _BasePopupTestbed({
    Key key,
    GlobalKey<NavigatorState> navigatorKey,
    RouteObserver routeObserver,
    this.popup = const SizedBox(),
    this.popupConstraints = const BoxConstraints(),
    this.offsetBuilder = _defaultOffsetBuilder,
    this.closeOnTapOutside = true,
    this.popupOpaque = true,
    this.triggerBuilder,
  })  : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        routeObserver = routeObserver ?? RouteObserver(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      home: Scaffold(
        body: BasePopup(
          popupOpaque: popupOpaque,
          routeObserver: routeObserver,
          triggerBuilder: triggerBuilder,
          popupConstraints: popupConstraints,
          offsetBuilder: offsetBuilder,
          closeOnTapOutside: closeOnTapOutside,
          popup: popup,
        ),
      ),
    );
  }
}
