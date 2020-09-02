import 'package:flutter/material.dart';

/// Signature for the function that builds an offset using the [childSize].
typedef OffsetBuilder = Offset Function(Size childSize);

/// Signature for the function that builds a trigger widget
/// using the [openPopup] and the [closePopup] callbacks.
typedef TriggerBuilder = Widget Function(
  BuildContext context,
  VoidCallback openPopup,
  VoidCallback closePopup,
);

/// A widget that displays the trigger widget built by the [triggerBuilder]
/// that opens the given [popup] when the trigger widget is activated.
class BasePopup extends StatefulWidget {
  /// A [RouteObserver] to subscribe to the route callbacks.
  final RouteObserver routeObserver;

  /// An additional constraints to apply to the [popup].
  final BoxConstraints popupConstraints;

  /// A callback that is called to build the [popup] offset from
  /// the trigger widget.
  final OffsetBuilder offsetBuilder;

  /// A callback that is called to build the trigger widget.
  final TriggerBuilder triggerBuilder;

  /// A widget to display when the trigger widget is triggered.
  final Widget popup;

  /// Defines if the popup should be closed when the user taps on an empty area
  /// inside the popup.
  final bool closePopupOnEmptySpaceTap;

  /// Creates a new instance of the base popup.
  ///
  /// If the [popupConstraints] is null, an empty instance of
  /// the [BoxConstraints] is used.
  /// The [closePopupOnEmptySpaceTap] defaults to `false`.
  ///
  /// All the required parameters must not be null.
  const BasePopup({
    Key key,
    BoxConstraints popupConstraints,
    @required this.offsetBuilder,
    @required this.triggerBuilder,
    @required this.popup,
    this.closePopupOnEmptySpaceTap = false,
    this.routeObserver,
  })  : popupConstraints = popupConstraints ?? const BoxConstraints(),
        assert(offsetBuilder != null),
        assert(triggerBuilder != null),
        assert(popup != null),
        super(key: key);

  @override
  _BasePopupState createState() => _BasePopupState();
}

class _BasePopupState extends State<BasePopup> with RouteAware {
  /// A [OverlayEntry] where used to display a [BasePopup.popup].
  OverlayEntry _overlayEntry;

  /// The [LayerLink] that allows a [BasePopup.popup] to follow the trigger.
  final _layerLink = LayerLink();

  @override
  void didChangeDependencies() {
    widget.routeObserver?.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.triggerBuilder(
        context,
        _openPopup,
        _closePopup,
      ),
    );
  }

  /// Opens a [BasePopup.popup].
  void _openPopup() {
    final childBox = context.findRenderObject() as RenderBox;
    final childSize = childBox.size;
    final offset = widget.offsetBuilder(childSize);

    final _widget = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _closePopup,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: offset.dx,
            top: offset.dy,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: offset,
              child: GestureDetector(
                onTap: _onPopupEmptySpaceTap,
                child: MouseRegion(
                  child: ConstrainedBox(
                    constraints: widget.popupConstraints,
                    child: widget.popup,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    _overlayEntry = OverlayEntry(builder: (context) => _widget);
    Overlay.of(context).insert(_overlayEntry);
  }

  @override
  void didPop() {
    _closePopup();
    super.didPop();
  }

  @override
  void didPushNext() {
    _closePopup();
    super.didPushNext();
  }

  /// Closes a [BasePopup.popup].
  void _closePopup() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }

  /// Closes a [BasePopup.popup], when taps on the empty space.
  void _onPopupEmptySpaceTap() {
    if (widget.closePopupOnEmptySpaceTap) _closePopup();
  }

  @override
  void dispose() {
    widget.routeObserver?.unsubscribe(this);
    _closePopup();
    super.dispose();
  }
}
