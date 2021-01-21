import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metrics/platform/stub/web_platform/web_platform_stub.dart'
    if (dart.library.html) 'package:metrics/platform/web/web_platform/web_platform.dart';

/// A widget that displays an SVG image.
///
/// Uses the [SvgPicture.network] if the application uses SKIA renderer,
/// otherwise uses the [Image.network].
class SvgImage extends StatelessWidget {
  /// A default [WebPlatform] of the [SvgImage] class.
  static const _defaultPlatform = WebPlatform();

  /// A source of the image to display.
  final String src;

  /// A height of this image.
  final double height;

  /// A width of this image.
  final double width;

  /// A parameter that controls how to inscribe this image into the space
  /// allocated during layout.
  final BoxFit fit;

  /// A [Color] used to combine with this image.
  final Color color;

  /// An [AlignmentGeometry] to align this image within its parent widget.
  final AlignmentGeometry alignment;

  /// A [WebPlatform] used to detect if the current application uses SKIA.
  final WebPlatform platform;

  /// Creates a new instance of the [SvgImage].
  ///
  /// If the given [alignment] is `null` the [Alignment.center] is used.
  /// If the given [fit] is `null` the [BoxFit.none] is used.
  /// If the given [platform] is `null`, the instance of the [WebPlatform]
  /// is used.
  const SvgImage(
    this.src, {
    this.height,
    this.width,
    this.color,
    AlignmentGeometry alignment,
    BoxFit fit,
    WebPlatform platform,
  })  : alignment = alignment ?? Alignment.center,
        fit = fit ?? BoxFit.none,
        platform = platform ?? _defaultPlatform;

  @override
  Widget build(BuildContext context) {
    final _isSkia = platform.isSkia;

    return _isSkia
        ? SvgPicture.network(
            src,
            height: height,
            width: width,
            fit: fit,
            color: color,
            alignment: alignment,
          )
        : Image.network(
            src,
            height: height,
            width: width,
            fit: fit,
            color: color,
            alignment: alignment,
          );
  }
}
