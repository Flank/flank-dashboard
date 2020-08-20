import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/shimmer_container.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

void main() {
  group("ShimmerContainer", () {
    final containerFinder = find.descendant(
      of: find.byType(ShimmerContainer),
      matching: find.byType(Container).first,
    );

    Shimmer findShimmer(WidgetTester tester) {
      return tester.widget<Shimmer>(find.byType(Shimmer));
    }

    testWidgets(
      "throws an AssertionError if the given padding is null",
      (tester) async {
        await tester.pumpWidget(const _ShimmerContainerTestbed(
          padding: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given duration is null",
      (tester) async {
        await tester.pumpWidget(const _ShimmerContainerTestbed(
          duration: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given direction is null",
      (tester) async {
        await tester.pumpWidget(const _ShimmerContainerTestbed(
          direction: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given border radius is null",
      (tester) async {
        await tester.pumpWidget(const _ShimmerContainerTestbed(
          borderRadius: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the enabled parameter is null",
      (tester) async {
        await tester.pumpWidget(const _ShimmerContainerTestbed(
          enabled: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given padding",
      (tester) async {
        const padding = EdgeInsets.all(10.0);

        await tester.pumpWidget(const _ShimmerContainerTestbed(
          padding: padding,
        ));

        final paddingWidget = tester.widget<Padding>(
          find.ancestor(
            of: find.byType(ClipRRect),
            matching: find.byType(Padding),
          ),
        );

        expect(paddingWidget.padding, equals(padding));
      },
    );

    testWidgets(
      "applies the given width",
      (tester) async {
        const width = 10.0;

        await tester.pumpWidget(
          const _ShimmerContainerTestbed(width: width),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.constraints.maxWidth, equals(width));
        expect(container.constraints.minWidth, equals(width));
      },
    );

    testWidgets(
      "applies the given height",
      (tester) async {
        const height = 11.0;

        await tester.pumpWidget(
          const _ShimmerContainerTestbed(height: height),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.constraints.maxHeight, equals(height));
        expect(container.constraints.minHeight, equals(height));
      },
    );

    testWidgets(
      "applies the given decoration",
      (tester) async {
        const decoration = BoxDecoration(
          color: Colors.blue,
        );

        await tester.pumpWidget(
          const _ShimmerContainerTestbed(decoration: decoration),
        );

        final container = tester.widget<Container>(containerFinder);

        expect(container.decoration, equals(decoration));
      },
    );

    testWidgets(
      "applies the given shimmer color to the shimmer animation",
      (tester) async {
        const color = Colors.red;

        await tester.pumpWidget(
          const _ShimmerContainerTestbed(shimmerColor: color),
        );

        final shimmer = findShimmer(tester);

        expect(shimmer.color, equals(color));
      },
    );

    testWidgets(
      "displays the given child widget",
      (tester) async {
        const child = Text('test');

        await tester.pumpWidget(
          const _ShimmerContainerTestbed(child: child),
        );

        expect(find.byWidget(child), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given duration to the shimmer animation",
      (tester) async {
        const duration = Duration(seconds: 2);

        await tester.pumpWidget(
          const _ShimmerContainerTestbed(duration: duration),
        );

        final shimmer = findShimmer(tester);

        expect(shimmer.duration, equals(duration));
      },
    );

    testWidgets(
      "applies the given direction to the shimmer animation",
      (tester) async {
        const direction = ShimmerDirection.fromLeftToRight();

        await tester.pumpWidget(
          const _ShimmerContainerTestbed(direction: direction),
        );

        final shimmer = findShimmer(tester);

        expect(shimmer.direction, equals(direction));
      },
    );

    testWidgets(
      "applies the border radius",
      (tester) async {
        final borderRadius = BorderRadius.circular(10.0);

        await tester.pumpWidget(
          _ShimmerContainerTestbed(borderRadius: borderRadius),
        );

        final shimmer = tester.widget<ClipRRect>(find.byType(ClipRRect));

        expect(shimmer.borderRadius, equals(borderRadius));
      },
    );

    testWidgets(
      "applies the given enabled parameter to the shimmer animation",
      (tester) async {
        const enabled = false;

        await tester.pumpWidget(
          const _ShimmerContainerTestbed(enabled: enabled),
        );

        final shimmer = findShimmer(tester);

        expect(shimmer.enabled, equals(enabled));
      },
    );
  });
}

/// A testbed class required to test the [ShimmerContainer] widget.
class _ShimmerContainerTestbed extends StatelessWidget {
  /// A width of the [ShimmerContainer].
  final double width;

  /// A height of the [ShimmerContainer].
  final double height;

  /// A decoration of the [ShimmerContainer].
  final Decoration decoration;

  /// A [Color] of the [ShimmerContainer]'s animation.
  final Color shimmerColor;

  /// A child widget to be displayed.
  final Widget child;

  /// An empty space surrounds the [ShimmerContainer].
  final EdgeInsetsGeometry padding;

  /// The [Duration] of the animation.
  final Duration duration;

  /// The direction of the animation.
  final ShimmerDirection direction;

  /// The [BorderRadius] of the [ShimmerContainer].
  final BorderRadius borderRadius;

  /// Enable or disable an animation;
  final bool enabled;

  /// Creates a new instance of the shimmer container testbed.
  ///
  /// The [padding] defaults to the [EdgeInsets.zero].
  /// The [duration] defaults to three seconds.
  /// The [direction] defaults to an empty instance of
  /// The [ShimmerDirection.fromLTRB].
  /// The [borderRadius] defaults to the [BorderRadius.zero].
  /// The [enabled] defaults to `true`.
  const _ShimmerContainerTestbed({
    Key key,
    this.width,
    this.height,
    this.decoration,
    this.shimmerColor,
    this.child,
    this.padding = EdgeInsets.zero,
    this.duration = const Duration(seconds: 3),
    this.direction = const ShimmerDirection.fromLTRB(),
    this.borderRadius = BorderRadius.zero,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ShimmerContainer(
          key: key,
          width: width,
          height: height,
          decoration: decoration,
          shimmerColor: shimmerColor,
          padding: padding,
          duration: duration,
          direction: direction,
          borderRadius: borderRadius,
          enabled: enabled,
          child: child,
        ),
      ),
    );
  }
}
