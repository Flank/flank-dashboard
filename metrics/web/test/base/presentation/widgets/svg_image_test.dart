import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/util/renderer_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("SvgImage", () {
    const defaultSrc = 'src';
    final rendererHelperMock = _RendererHelperMock();

    testWidgets(
      "displays the svg picture widget if the application uses the SKIA renderer",
      (WidgetTester tester) async {
        when(rendererHelperMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              rendererHelper: rendererHelperMock,
            ),
          );
        });

        expect(find.byType(SvgPicture), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given src to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        when(rendererHelperMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(defaultSrc, rendererHelper: rendererHelperMock),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
        final picture = svgPicture.pictureProvider as NetworkPicture;

        expect(picture.url, equals(defaultSrc));
      },
    );

    testWidgets(
      "applies the given fit to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        const fit = BoxFit.contain;

        when(rendererHelperMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              fit: fit,
              rendererHelper: rendererHelperMock,
            ),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.fit, equals(fit));
      },
    );

    testWidgets(
      "applies the Boxfit.none to the svg picture widget if the given fit is null when using SKIA renderer",
      (WidgetTester tester) async {
        when(rendererHelperMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              rendererHelper: rendererHelperMock,
              fit: null,
            ),
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

        when(rendererHelperMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              rendererHelper: rendererHelperMock,
              width: width,
            ),
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

        when(rendererHelperMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              rendererHelper: rendererHelperMock,
              height: height,
            ),
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

        when(rendererHelperMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              rendererHelper: rendererHelperMock,
              color: color,
            ),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.colorFilter, equals(expectedColorFilter));
      },
    );

    testWidgets(
      "displays the network image widget if the application when not using use the SKIA renderer",
      (WidgetTester tester) async {
        when(rendererHelperMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              rendererHelper: rendererHelperMock,
            ),
          );
        });

        expect(find.byType(Image), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given src to the network image widget when not using the SKIA renderer",
      (WidgetTester tester) async {
        when(rendererHelperMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              rendererHelper: rendererHelperMock,
            ),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));
        final networkImage = image.image as NetworkImage;

        expect(networkImage.url, equals(defaultSrc));
      },
    );

    testWidgets(
      "applies the given fit to the network image widget when not using the SKIA renderer",
      (WidgetTester tester) async {
        const fit = BoxFit.contain;

        when(rendererHelperMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              fit: fit,
              rendererHelper: rendererHelperMock,
            ),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.fit, equals(fit));
      },
    );

    testWidgets(
      "applies the BoxFit.none to the network image widget if the given fit is null when not using the SKIA renderer",
      (WidgetTester tester) async {
        when(rendererHelperMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              fit: null,
              rendererHelper: rendererHelperMock,
            ),
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

        when(rendererHelperMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              height: height,
              rendererHelper: rendererHelperMock,
            ),
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

        when(rendererHelperMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              width: width,
              rendererHelper: rendererHelperMock,
            ),
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

        when(rendererHelperMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              defaultSrc,
              rendererHelper: rendererHelperMock,
              color: color,
            ),
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
  /// A path to an image to use in tests.
  final String src;

  /// A height of an image to use in tests.
  final double height;

  /// A width of an image to use in tests.
  final double width;

  /// A parameter that controls how to inscribe an image into the space
  /// allocated during layout.
  final BoxFit fit;

  /// A [Color] used to combine with an image to use in tests.
  final Color color;

  /// A [RendererHelper] to use in tests.
  final RendererHelper rendererHelper;

  /// Creates a new instance of the svg image testbed.
  const _SvgImageTestbed(
    this.src, {
    this.fit,
    this.height,
    this.width,
    this.color,
    this.rendererHelper,
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
          rendererHelper: rendererHelper,
        ),
      ),
    );
  }
}

class _RendererHelperMock extends Mock implements RendererHelper {}
