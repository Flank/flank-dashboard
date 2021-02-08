// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metrics/platform/stub/renderer/renderer_stub.dart'
    if (dart.library.html) 'package:metrics/platform/web/renderer/web_renderer.dart';

/// A widget that displays an SVG image.
///
/// Uses the [SvgPicture.network] if the application uses SKIA renderer,
/// otherwise uses the [Image.network].
class SvgImage extends StatelessWidget {
  /// A default [Renderer] of the [SvgImage] class.
  static const _defaultRenderer = Renderer();

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

  /// A [Renderer] used to detect if the current application uses SKIA.
  final Renderer renderer;

  /// Creates a new instance of the [SvgImage].
  ///
  /// If the given [alignment] is `null` the [Alignment.center] is used.
  /// If the given [fit] is `null` the [BoxFit.none] is used.
  /// If the given [renderer] is `null`, the instance of the [Renderer]
  /// is used.
  const SvgImage(
    this.src, {
    this.height,
    this.width,
    this.color,
    AlignmentGeometry alignment,
    BoxFit fit,
    Renderer renderer,
  })  : alignment = alignment ?? Alignment.center,
        fit = fit ?? BoxFit.none,
        renderer = renderer ?? _defaultRenderer;

  @override
  Widget build(BuildContext context) {
    final _isSkia = renderer.isSkia;

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
