// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/factory/rive_artboard_factory.dart';
import 'package:rive/rive.dart';

/// A widget that displays the Rive animation.
class RiveAnimation extends StatefulWidget {
  /// An [Alignment] that determines how to align this animation
  /// within its bounds.
  final Alignment alignment;

  /// A [RiveArtboardFactory] this widget uses to get the [Artboard] from the
  /// asset with the given [assetName].
  final RiveArtboardFactory artboardFactory;

  /// A name of the [Artboard] to display the animation.
  final String artboardName;

  /// A name of the animation asset to load.
  final String assetName;

  /// A [RiveAnimationController] to control the animation's playback.
  final RiveAnimationController controller;

  /// A [BoxFit] that determines how to inscribe this animation into the space
  /// allocated during layout.
  final BoxFit fit;

  /// A flag that determines whether to use the absolute size defined by the
  /// [Artboard], or resize the widget based on the constraints provided by
  /// the parent widget.
  final bool useArtboardSize;

  /// Creates a new instance of the [RiveAnimation] with the given parameters.
  ///
  /// The [fit] defaults to [BoxFit.contain].
  ///
  /// If the given [alignment] is `null`, the [Alignment.center] is used.
  /// The [useArtboardSize] defaults to `false`.
  ///
  /// Throws an [AssertionError] if the given [assetName] is `null`.
  const RiveAnimation(
    this.assetName, {
    Key key,
    this.artboardName,
    this.artboardFactory,
    this.controller,
    this.fit = BoxFit.contain,
    Alignment alignment,
    bool useArtboardSize,
  })  : assert(assetName != null),
        alignment = alignment ?? Alignment.center,
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
  void didUpdateWidget(RiveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.assetName != widget.assetName) {
      _loadAnimation();
    }
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

  /// Loads the animation [Artboard] using the [RiveAnimation.artboardFactory].
  ///
  /// If the [RiveAnimation.artboardFactory] is `null`, a new instance of the
  /// [RiveArtboardFactory] with the [DefaultAssetBundle] is used.
  ///
  /// If the [RiveAnimation.controller] is not `null` adds it to the obtained
  /// artboard.
  Future<void> _loadAnimation() async {
    final artboardFactory = widget.artboardFactory ??
        RiveArtboardFactory(DefaultAssetBundle.of(context));

    final artboard = await artboardFactory.create(
      widget.assetName,
      artboardName: widget.artboardName,
    );

    final controller = widget.controller;
    if (controller != null) {
      artboard.addController(controller);
    }

    _setArtboard(artboard);
  }

  /// Sets the [_artboard] value to given [artboard] if the widget is [mounted].
  void _setArtboard(Artboard artboard) {
    if (!mounted) return;

    setState(() {
      _artboard = artboard;
    });
  }
}
