import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/svg_image/strategy/svg_image_strategy.dart';
import 'package:metrics/base/presentation/widgets/svg_image/widgets/svg_image.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("SvgImage", () {
    const testImageSrc = 'src';
    final strategyMock = _SvgImageStrategyMock();

    testWidgets(
      "applies the default strategy if the given strategy is null",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _SvgImageTestbed(strategy: null));
        });

        final svgImage = tester.widget<SvgImage>(find.byType(SvgImage));

        expect(svgImage.strategy, isNotNull);
      },
    );

    testWidgets(
      "displays the svg picture widget if the application uses the SKIA renderer",
      (WidgetTester tester) async {
        when(strategyMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(strategy: strategyMock),
          );
        });

        expect(find.byType(SvgPicture), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given src to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        when(strategyMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(src: testImageSrc, strategy: strategyMock),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
        final picture = svgPicture.pictureProvider as NetworkPicture;

        expect(picture.url, equals(testImageSrc));
      },
    );

    testWidgets(
      "applies the given alignment to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        const alignment = Alignment.bottomLeft;
        when(strategyMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(alignment: alignment, strategy: strategyMock),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.alignment, equals(alignment));
      },
    );

    testWidgets(
      "applies the given alignment to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        const alignment = Alignment.bottomLeft;
        when(strategyMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(alignment: alignment, strategy: strategyMock),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.alignment, equals(alignment));
      },
    );

    testWidgets(
      "applies the Alignment.center to the svg picture widget if the given alignment is null when using SKIA renderer",
      (WidgetTester tester) async {
        when(strategyMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(strategy: strategyMock, alignment: null),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.alignment, equals(Alignment.center));
      },
    );

    testWidgets(
      "applies the Boxfit.none to the svg picture widget if the given fit is null when using SKIA renderer",
      (WidgetTester tester) async {
        when(strategyMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(strategy: strategyMock, fit: null),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.fit, equals(BoxFit.none));
      },
    );

    testWidgets(
      "applies the given width to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        const width = 10.0;
        when(strategyMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(strategy: strategyMock, width: width),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.width, equals(width));
      },
    );

    testWidgets(
      "applies the given height to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        const height = 10.0;
        when(strategyMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(strategy: strategyMock, height: height),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.height, equals(height));
      },
    );

    testWidgets(
      "applies the given color to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        const color = Colors.red;
        const expectedColorFilter = ColorFilter.mode(color, BlendMode.srcIn);
        when(strategyMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(strategy: strategyMock, color: color),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.colorFilter, equals(expectedColorFilter));
      },
    );

    testWidgets(
      "displays the network image widget if the application doesn't use the SKIA renderer",
      (WidgetTester tester) async {
        when(strategyMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(strategy: strategyMock),
          );
        });

        expect(find.byType(Image), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given src to the network image widget when not using the SKIA renderer",
      (WidgetTester tester) async {
        when(strategyMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(src: testImageSrc, strategy: strategyMock),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));
        final networkImage = image.image as NetworkImage;

        expect(networkImage.url, equals(testImageSrc));
      },
    );

    testWidgets(
      "applies the Alignment.center to the network image widget when the given one is null when not using the SKIA renderer",
      (WidgetTester tester) async {
        when(strategyMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(alignment: null, strategy: strategyMock),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.alignment, equals(Alignment.center));
      },
    );
    testWidgets(
      "applies the given alignment to the network image widget when not using the SKIA renderer",
      (WidgetTester tester) async {
        const alignment = Alignment.bottomLeft;
        when(strategyMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(alignment: alignment, strategy: strategyMock),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.alignment, equals(alignment));
      },
    );

    testWidgets(
      "applies the given fit to the network image widget when not using the SKIA renderer",
      (WidgetTester tester) async {
        const fit = BoxFit.contain;
        when(strategyMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(fit: fit, strategy: strategyMock),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.fit, equals(fit));
      },
    );

    testWidgets(
      "applies the BoxFit.none to the network image widget if the given fit is null when not using the SKIA renderer",
      (WidgetTester tester) async {
        when(strategyMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(fit: null, strategy: strategyMock),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.fit, equals(BoxFit.none));
      },
    );

    testWidgets(
      "applies the given height to the network image widget when not using the SKIA renderer",
      (WidgetTester tester) async {
        const height = 20.0;
        when(strategyMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(height: height, strategy: strategyMock),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.height, equals(height));
      },
    );

    testWidgets(
      "applies the given width to the network image widget when not using the SKIA renderer",
      (WidgetTester tester) async {
        const width = 20.0;
        when(strategyMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(width: width, strategy: strategyMock),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.width, equals(width));
      },
    );

    testWidgets(
      "applies the given color to the network image widget when not using the SKIA renderer",
      (WidgetTester tester) async {
        const color = Colors.red;
        when(strategyMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(strategy: strategyMock, color: color),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.color, equals(color));
      },
    );
  });
}

/// A testbed class needed to test the [SvgImage] widget.
class _SvgImageTestbed extends StatelessWidget {
  /// A default source of the [SvgImage].
  static const String _defaultSrc = 'default src';

  /// A source of the [SvgImage].
  final String src;

  /// A height of the [SvgImage].
  final double height;

  /// A width of the [SvgImage].
  final double width;

  /// A [BoxFit] of the [SvgImage].
  final BoxFit fit;

  /// A [Color] of the [SvgImage].
  final Color color;

  /// An [AlignmentGeometry] of the [SvgImage].
  final AlignmentGeometry alignment;

  /// An [SvgImageStrategy] of the [SvgImage].
  final SvgImageStrategy strategy;

  /// Creates a new instance of the svg image testbed.
  ///
  /// The [src] defaults to default src.
  const _SvgImageTestbed({
    this.src = _defaultSrc,
    this.fit,
    this.height,
    this.width,
    this.color,
    this.alignment,
    this.strategy,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SvgImage(
          src,
          fit: fit,
          height: height,
          width: width,
          color: color,
          alignment: alignment,
          strategy: strategy,
        ),
      ),
    );
  }
}

class _SvgImageStrategyMock extends Mock implements SvgImageStrategy {}
