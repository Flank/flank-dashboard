import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/util/web_platform.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("SvgImage", () {
    const testImageSrc = 'src';
    final platformMock = _WebPlatformMock();

    tearDown(() {
      reset(platformMock);
    });

    testWidgets(
      "applies the default web platform if the given one is null",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _SvgImageTestbed(platform: null));
        });

        final svgImage = tester.widget<SvgImage>(find.byType(SvgImage));

        expect(svgImage.platform, isNotNull);
      },
    );

    testWidgets(
      "displays the svg picture widget if the application uses the SKIA renderer",
      (WidgetTester tester) async {
        when(platformMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(platform: platformMock),
          );
        });

        expect(find.byType(SvgPicture), findsOneWidget);
      },
    );

    testWidgets(
      "uses the given web platform to detect whether the SKIA renderer is used",
      (WidgetTester tester) async {
        when(platformMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(platform: platformMock),
          );
        });

        verify(platformMock.isSkia).called(1);
      },
    );

    testWidgets(
      "applies the given src to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        when(platformMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(src: testImageSrc, platform: platformMock),
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
        when(platformMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(alignment: alignment, platform: platformMock),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.alignment, equals(alignment));
      },
    );

    testWidgets(
      "aligns the svg picture to the center if the given alignment is null when using SKIA renderer",
      (WidgetTester tester) async {
        when(platformMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(alignment: null, platform: platformMock),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.alignment, equals(Alignment.center));
      },
    );

    testWidgets(
      "applies the BoxFit.none to the svg picture widget if the given fit is null when using SKIA renderer",
      (WidgetTester tester) async {
        when(platformMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(platform: platformMock, fit: null),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.fit, equals(BoxFit.none));
      },
    );

    testWidgets(
      "applies the given fit to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        const fit = BoxFit.contain;
        when(platformMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(platform: platformMock, fit: fit),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.fit, equals(fit));
      },
    );

    testWidgets(
      "applies the given width to the svg picture widget when using SKIA renderer",
      (WidgetTester tester) async {
        const width = 10.0;
        when(platformMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(platform: platformMock, width: width),
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
        when(platformMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(platform: platformMock, height: height),
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
        when(platformMock.isSkia).thenReturn(true);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(platform: platformMock, color: color),
          );
        });

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

        expect(svgPicture.colorFilter, equals(expectedColorFilter));
      },
    );

    testWidgets(
      "displays the network image widget if the application doesn't use the SKIA renderer",
      (WidgetTester tester) async {
        when(platformMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(platform: platformMock),
          );
        });

        expect(find.byType(Image), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given src to the network image widget when not using the SKIA renderer",
      (WidgetTester tester) async {
        when(platformMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              src: testImageSrc,
              platform: platformMock,
            ),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));
        final networkImage = image.image as NetworkImage;

        expect(networkImage.url, equals(testImageSrc));
      },
    );

    testWidgets(
      "aligns to the network image to the center if the given alignment is null when not using the SKIA renderer",
      (WidgetTester tester) async {
        when(platformMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(alignment: null, platform: platformMock),
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
        when(platformMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              alignment: alignment,
              platform: platformMock,
            ),
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
        when(platformMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(fit: fit, platform: platformMock),
          );
        });

        final image = tester.widget<Image>(find.byType(Image));

        expect(image.fit, equals(fit));
      },
    );

    testWidgets(
      "applies the BoxFit.none to the network image widget if the given fit is null when not using the SKIA renderer",
      (WidgetTester tester) async {
        when(platformMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(fit: null, platform: platformMock),
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
        when(platformMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(height: height, platform: platformMock),
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
        when(platformMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(width: width, platform: platformMock),
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
        when(platformMock.isSkia).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _SvgImageTestbed(
              platform: platformMock,
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

  /// A [WebPlatform] of the [SvgImage].
  final WebPlatform platform;

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
    this.platform,
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
          platform: platform,
        ),
      ),
    );
  }
}

class _WebPlatformMock extends Mock implements WebPlatform {}
