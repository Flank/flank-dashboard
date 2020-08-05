import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/base_popup.dart';

void main() {
  group("BasePopup", () {
    const testChildWidget = Text('child widget');
    const testPopupWidget = Text('popup widget');
    final childWidgetFinder = find.byWidget(testChildWidget);
    final popupWidgetFinder = find.byWidget(testPopupWidget);

    testWidgets(
      "throws an AssertionError if the given child widget is null",
      (tester) async {
        await tester.pumpWidget(const _BasePopupTestbed(child: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given popup widget is null",
      (tester) async {
        await tester.pumpWidget(const _BasePopupTestbed(popup: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given offset builder is null",
      (tester) async {
        await tester.pumpWidget(const _BasePopupTestbed(offsetBuilder: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given transition builder is null",
      (tester) async {
        await tester.pumpWidget(
          const _BasePopupTestbed(transitionBuilder: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given transition duration is null",
      (tester) async {
        await tester.pumpWidget(
          const _BasePopupTestbed(transitionDuration: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given barrier dismissible is null",
      (tester) async {
        await tester.pumpWidget(
          const _BasePopupTestbed(barrierDismissible: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given child widget",
      (tester) async {
        await tester.pumpWidget(
          const _BasePopupTestbed(child: testChildWidget),
        );

        expect(childWidgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the given popup widget when the child widget is tapped",
      (tester) async {
        await tester.pumpWidget(const _BasePopupTestbed(
          popup: testPopupWidget,
          child: testChildWidget,
        ));

        await tester.tap(childWidgetFinder);
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
          child: testChildWidget,
        ));

        await tester.tap(childWidgetFinder);
        await tester.pumpAndSettle();

        final followerWidget = tester.widget<CompositedTransformFollower>(
          find.byType(CompositedTransformFollower),
        );

        expect(followerWidget.offset, equals(offset));
      },
    );

    testWidgets(
      "applies the given box constraints to the popup widget",
      (WidgetTester tester) async {
        const boxConstraints = BoxConstraints(maxWidth: 50.0, maxHeight: 50.0);

        await tester.pumpWidget(
          const _BasePopupTestbed(
            boxConstraints: boxConstraints,
            popup: testPopupWidget,
            child: testChildWidget,
          ),
        );

        await tester.tap(childWidgetFinder);
        await tester.pumpAndSettle();

        final constrainedBox = tester.widget<ConstrainedBox>(find.ancestor(
          of: popupWidgetFinder,
          matching: find.byType(ConstrainedBox),
        ));
        final actualBoxConstraints = constrainedBox.constraints;

        expect(actualBoxConstraints, equals(boxConstraints));
      },
    );

    testWidgets(
      "applies the default box constraints to the child widget if the given box constraints is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _BasePopupTestbed(
            boxConstraints: null,
            popup: testPopupWidget,
            child: testChildWidget,
          ),
        );

        await tester.tap(childWidgetFinder);
        await tester.pumpAndSettle();

        final constrainedBox = tester.widget<ConstrainedBox>(find.ancestor(
          of: popupWidgetFinder,
          matching: find.byType(ConstrainedBox),
        ));
        final actualBoxConstraints = constrainedBox.constraints;

        expect(actualBoxConstraints, isNotNull);
      },
    );

    testWidgets(
      "displays the widget built by the given transition builder when child widget is tapped",
      (tester) async {
        const transitionTestWidget = Text('transition widget');

        await tester.pumpWidget(_BasePopupTestbed(
          transitionBuilder: (_, __, ___, ____) => transitionTestWidget,
          child: testChildWidget,
        ));

        await tester.tap(childWidgetFinder);
        await tester.pumpAndSettle();

        expect(find.byWidget(transitionTestWidget), findsOneWidget);
      },
    );

    testWidgets(
      "closes a popup with the given child after tap outside of the popup is the barrier is dismissible",
      (tester) async {
        const defaultSize = 20.0;

        await tester.pumpWidget(const _BasePopupTestbed(
          barrierDismissible: true,
          boxConstraints: BoxConstraints(maxHeight: defaultSize),
          popup: testPopupWidget,
          child: testChildWidget,
        ));

        await tester.tap(childWidgetFinder);
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(defaultSize, defaultSize));
        await tester.pumpAndSettle();

        expect(popupWidgetFinder, findsNothing);
      },
    );

    testWidgets(
      "does not close a popup with the given child after tap outside of the popup is the barrier is not dismissible",
      (tester) async {
        const defaultSize = 20.0;

        await tester.pumpWidget(const _BasePopupTestbed(
          barrierDismissible: false,
          boxConstraints: BoxConstraints(maxHeight: defaultSize),
          popup: testPopupWidget,
          child: testChildWidget,
        ));

        await tester.tap(childWidgetFinder);
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(defaultSize, defaultSize));
        await tester.pumpAndSettle();

        expect(popupWidgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the given barrier dismissible to the popup modal route",
      (tester) async {
        const barrierDismissible = false;
        final globalKey = GlobalKey();

        await tester.pumpWidget(_BasePopupTestbed(
          barrierDismissible: barrierDismissible,
          popup: Container(key: globalKey),
          child: testChildWidget,
        ));

        await tester.tap(childWidgetFinder);
        await tester.pumpAndSettle();
        final modalRoute = ModalRoute.of(globalKey.currentContext);

        expect(modalRoute.barrierDismissible, equals(barrierDismissible));
      },
    );

    testWidgets(
      "applies the given barrier label to the popup modal route",
      (tester) async {
        const label = 'Label';
        final globalKey = GlobalKey();

        await tester.pumpWidget(_BasePopupTestbed(
          barrierLabel: label,
          popup: Container(key: globalKey),
          child: testChildWidget,
        ));

        await tester.tap(childWidgetFinder);
        await tester.pumpAndSettle();
        final modalRoute = ModalRoute.of(globalKey.currentContext);

        expect(modalRoute.barrierLabel, equals(label));
      },
    );

    testWidgets(
      "applies the given barrier color to the popup modal route",
      (tester) async {
        const color = Colors.black;
        final globalKey = GlobalKey();

        await tester.pumpWidget(_BasePopupTestbed(
          barrierColor: color,
          popup: Container(key: globalKey),
          child: testChildWidget,
        ));

        await tester.tap(childWidgetFinder);
        await tester.pumpAndSettle();
        final modalRoute = ModalRoute.of(globalKey.currentContext);

        expect(modalRoute.barrierColor, equals(color));
      },
    );

    testWidgets(
      "applies the given transition duration to the popup modal route",
      (tester) async {
        const transitionDuration = Duration(seconds: 2);
        final globalKey = GlobalKey();

        await tester.pumpWidget(_BasePopupTestbed(
          transitionDuration: transitionDuration,
          popup: Container(key: globalKey),
          child: testChildWidget,
        ));

        await tester.tap(childWidgetFinder);
        await tester.pumpAndSettle();
        final modalRoute = ModalRoute.of(globalKey.currentContext);

        expect(modalRoute.transitionDuration, equals(transitionDuration));
      },
    );
  });
}

/// A testbed class required to test the [BasePopup] widget.
class _BasePopupTestbed extends StatelessWidget {
  /// Builds the default offset.
  static Offset _defaultOffsetBuilder(Size size) => Offset.zero;

  /// Builds the default transition.
  static Widget _defaultRouteTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }

  /// A widget to display as a [popup] trigger.
  final Widget child;

  /// A widget to display when a [child] is triggered.
  final Widget popup;

  /// An additional constraints to apply to the [popup].
  final BoxConstraints boxConstraints;

  /// A callback that is called to build the [popup] offset from the [child].
  final OffsetBuilder offsetBuilder;

  /// A callback that is called to build the route transitions
  /// to display a [popup].
  final RouteTransitionsBuilder transitionBuilder;

  /// Duration of the transition going forwards.
  final Duration transitionDuration;

  /// Indicates whether you can dismiss a [popup] route by tapping the
  /// modal barrier.
  final bool barrierDismissible;

  /// A color to use for the [popup] modal barrier.
  ///
  /// If this is null, the barrier will be transparent.
  final Color barrierColor;

  /// A semantic label used for a dismissible barrier when
  /// a [popup] is triggered.
  final String barrierLabel;

  /// Creates the [BasePopup].
  ///
  /// The [child] defaults to the [Icon] with the [Icons.group] icon data.
  /// The [popup] defaults to the [SizedBox] with the empty constructor.
  /// The [boxConstraints] defaults to the [BoxConstraints]
  /// with the empty constructor.
  /// The [offsetBuilder] defaults to the [_defaultOffsetBuilder].
  /// The [transitionBuilder] defaults to the [_defaultRouteTransitionBuilder].
  /// The [transitionDuration] defaults to the `1 second`.
  /// The [barrierDismissible] defaults to `true`.
  const _BasePopupTestbed({
    Key key,
    this.child = const Icon(Icons.group),
    this.popup = const SizedBox(),
    this.boxConstraints = const BoxConstraints(),
    this.offsetBuilder = _defaultOffsetBuilder,
    this.transitionBuilder = _defaultRouteTransitionBuilder,
    this.transitionDuration = const Duration(seconds: 1),
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BasePopup(
          boxConstraints: boxConstraints,
          offsetBuilder: offsetBuilder,
          transitionBuilder: transitionBuilder,
          transitionDuration: transitionDuration,
          popup: popup,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          barrierDismissible: barrierDismissible,
          child: child,
        ),
      ),
    );
  }
}
