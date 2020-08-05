import 'package:flutter/material.dart';

/// Signature for the function that builds an offset using the [childSize].
typedef OffsetBuilder = Offset Function(Size childSize);

/// A widget that displays the given [child] that opens the given [popup]
/// when is triggered.
class BasePopup extends StatelessWidget {
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

  /// Creates a new instance of the base popup.
  ///
  /// The [barrierDismissible] defaults to `true`.
  /// If the [boxConstraints] is null, an empty instance of
  /// the [BoxConstraints] is used.
  ///
  /// All the required parameters and the [barrierDismissible] must not be null.
  const BasePopup({
    Key key,
    BoxConstraints boxConstraints,
    @required this.popup,
    @required this.offsetBuilder,
    @required this.transitionBuilder,
    @required this.child,
    @required this.transitionDuration,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
  })  : boxConstraints = boxConstraints ?? const BoxConstraints(),
        assert(popup != null),
        assert(offsetBuilder != null),
        assert(transitionBuilder != null),
        assert(child != null),
        assert(transitionDuration != null),
        assert(barrierDismissible != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _layerLink = LayerLink();

    return GestureDetector(
      onTap: () => _openPopup(context, _layerLink),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: child,
      ),
    );
  }

  /// Opens a [popup] using the [context] and the [layerLink].
  void _openPopup(BuildContext context, LayerLink layerLink) {
    final childBox = context.findRenderObject() as RenderBox;
    final childSize = childBox.size;
    final offset = offsetBuilder(childSize);

    Navigator.push(
      context,
      _PopupRoute(
        transitionDuration: transitionDuration,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        pageBuilder: (context, animation, secondaryAnimation) {
          return transitionBuilder(
            context,
            animation,
            secondaryAnimation,
            Stack(
              children: <Widget>[
                Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: CompositedTransformFollower(
                    link: layerLink,
                    offset: offset,
                    child: ConstrainedBox(
                      constraints: boxConstraints,
                      child: popup,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A popup route that overlays a widget over the current route.
class _PopupRoute extends PopupRoute {
  /// A callback that is called to build the route primary contents.
  final RoutePageBuilder pageBuilder;

  @override
  final Color barrierColor;

  @override
  final bool barrierDismissible;

  @override
  final String barrierLabel;

  @override
  final Duration transitionDuration;

  /// Create a new instance of the popup route.
  ///
  /// The [barrierDismissible] defaults to `true`.
  _PopupRoute({
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.pageBuilder,
    this.transitionDuration,
  });

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return pageBuilder(context, animation, secondaryAnimation);
  }
}
