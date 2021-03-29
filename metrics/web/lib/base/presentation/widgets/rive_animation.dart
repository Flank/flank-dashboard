// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

/// A widget that displays the Rive animation.
class RiveAnimation extends StatefulWidget {
  /// An [Alignment] that determines how to align this animation
  /// within its bounds.
  final Alignment alignment;

  /// A name of the [Artboard] to display the animation.
  final String artboardName;

  /// A name of the animation asset to load.
  final String assetName;

  /// A collection of the assets to load the animation from.
  final AssetBundle bundle;

  /// A [RiveAnimationController] to control the animation's playback.
  final RiveAnimationController controller;

  /// A [BoxFit] that determines how to inscribe this animation into the space
  /// allocated during layout.
  final BoxFit fit;

  /// A flag that determines whether to use the absolute size defined by the
  /// [Artboard], or size the widget based on the available constraints only.
  final bool useArtboardSize;

  /// Creates a new instance of the [RiveAnimation] with the given parameters.
  ///
  /// If the given [alignment] is `null` the [Alignment.center] is used.
  /// If the given [fit] is `null` the [BoxFit.contain] is used.
  /// The [useArtboardSize] defaults to `false`.
  ///
  /// Throws an [AssertionError] if the given [assetName] is `null`.
  const RiveAnimation(
    this.assetName, {
    Key key,
    this.artboardName,
    this.bundle,
    this.controller,
    Alignment alignment,
    bool useArtboardSize,
    BoxFit fit,
  })  : assert(assetName != null),
        alignment = alignment ?? Alignment.center,
        fit = fit ?? BoxFit.contain,
        useArtboardSize = useArtboardSize ?? false,
        super(key: key);

  @override
  _RiveAnimationState createState() => _RiveAnimationState();
}

class _RiveAnimationState extends State<RiveAnimation> {
  /// An [Artboard] to display the animation.
  Artboard _artboard;

  /// Indicates whether the animation is loading.
  bool get _isAnimationLoading => _artboard == null;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAnimationLoading) return const SizedBox();

    return Rive(
      artboard: _artboard,
      fit: widget.fit,
      alignment: widget.alignment,
      useArtboardSize: widget.useArtboardSize,
    );
  }

  /// Loads the animation [Artboard] from the [widget.bundle] with the
  /// [widget.artboardName].
  ///
  /// If the [widget.bundle] is `null` the [DefaultAssetBundle] is used.
  /// If the [widget.artboardName] is `null` the main [Artboard] is loaded.
  ///
  /// If the [widget.controller] is not `null` adds it to the obtained artboard.
  Future<void> _loadAnimation() async {
    final bundle = widget.bundle ?? DefaultAssetBundle.of(context);
    final assetBytes = await bundle.load(widget.assetName);

    final riveFile = RiveFile();
    riveFile.import(assetBytes);

    final artboardName = widget.artboardName;
    final artboard = artboardName == null
        ? riveFile.mainArtboard
        : riveFile.artboardByName(artboardName);

    final controller = widget.controller;
    if (controller != null) {
      artboard.addController(controller);
    }

    setState(() {
      _artboard = artboard;
    });
  }
}
