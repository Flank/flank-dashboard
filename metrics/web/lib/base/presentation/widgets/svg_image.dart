import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metrics/util/renderer_helper.dart';

/// A class that displays an SVG image according to the graphics engine.
class SvgImage extends StatelessWidget {
  /// A default [RendererHelper] of the [SvgImage] class.
  static const _defaultRendererHelper = RendererHelper();

  /// A path to this image to display.
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

  /// A [RendererHelper] that helps to get the information about
  /// the current application's instance renderer.
  final RendererHelper rendererHelper;

  /// Creates a new instance of the [SvgImage].
  ///
  /// If the given [fit] is `null` the [BoxFit.none] is used.
  /// If the given [rendererHelper] is `null` the default helper is used.
  const SvgImage(
    this.src, {
    this.height,
    this.width,
    this.color,
    BoxFit fit,
    RendererHelper rendererHelper,
  })  : fit = fit ?? BoxFit.none,
        rendererHelper = rendererHelper ?? _defaultRendererHelper;

  @override
  Widget build(BuildContext context) {
    final _isSkia = rendererHelper.isSkia;

    return _isSkia
        ? SvgPicture.network(
            src,
            height: height,
            width: width,
            fit: fit,
            color: color,
          )
        : Image.network(
            src,
            height: height,
            width: width,
            fit: fit,
            color: color,
          );
  }
}
